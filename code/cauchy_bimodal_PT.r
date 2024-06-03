xs <- c(-3, 2)

### The likelihood

c_loglik <- function(theta) {
  sum(dcauchy(
    x = xs,
    location = theta,
    log = TRUE
  ))
}
c_loglik <- Vectorize(c_loglik)

Mu <- 0
Sigma <- 1

c_logposterior_kernel <- function(theta) {
  dnorm(x = theta, mean = Mu, sd = Sigma) +
    c_loglik(theta)
}
c_logposterior_kernel <- Vectorize(c_logposterior_kernel)


minT <- -abs(4 * min(xs))
maxT <- abs(4 * max(xs))


## marginal likelihood via quadrature
m_of_x <- integrate(function(t)
  exp(c_logposterior_kernel(t)), -Inf, Inf)

c_posterior <- function(theta) {
  exp(c_logposterior_kernel(theta) - log(m_of_x$value))
}
c_posterior <- Vectorize(c_posterior)


curve(
  c_posterior,
  minT,
  maxT,
  lwd = 4,
  xlab = expression(theta),
  ylab = "Posterior density",
  main = "Cauchy example -- BC exercise 1.28"
)

############ Parallel tempering


U = function(gam, x)
{
  - gam * c_logposterior_kernel(x)
}

curried = function(gam)
{
  message(paste("Returning a function for gamma =", gam))
  function(x)
    U(gam, x)
}
U4 = curried(4)

op = par(mfrow = c(2, 1))
curve(U4(x), minT, maxT, main = "Potential function, U(x)")
curve(exp(-U4(x)), minT, maxT, main = "Unnormalised density function, exp(-U(x))")
par(op)


chain = function(target, tune = 0.1, init = 1)
{
  x = init
  xvec = numeric(iters)
  for (i in 1:iters) {
    can = x + rnorm(1, 0, tune)
    logA = target(x) - target(can)
    if (log(runif(1)) < logA)
      x = can
    xvec[i] = x
  }
  xvec
}

temps = 2 ^ (0:3)
iters = 1e5

mat = sapply(lapply(temps, curried), chain)
colnames(mat) = paste("gamma=", temps, sep = "")

require(smfsb)
mcmcSummary(mat, rows = length(temps))


chains_coupled = function(pot = U,
                          tune = 0.1,
                          init = 1)
{
  x = rep(init, length(temps))
  xmat = matrix(0, iters, length(temps))
  for (i in 1:iters) {
    can = x + rnorm(length(temps), 0, tune)
    logA = unlist(Map(pot, temps, x)) - unlist(Map(pot, temps, can))
    accept = (log(runif(length(temps))) < logA)
    x[accept] = can[accept]
    # now the coupling update
    swap = sample(1:length(temps), 2)
    logA = pot(temps[swap[1]], x[swap[1]]) + pot(temps[swap[2]], x[swap[2]]) -
      pot(temps[swap[1]], x[swap[2]]) - pot(temps[swap[2]], x[swap[1]])
    if (log(runif(1)) < logA)
      x[swap] = rev(x[swap])
    # end of the coupling update
    xmat[i, ] = x
  }
  colnames(xmat) = paste("gamma=", temps, sep = "")
  xmat
}

mc3 <- chains_coupled(tune = 1)

mcmcSummary(mc3, rows = length(temps))


par(mfrow = c(2, 2))
for (k in 1:ncol(mc3)){
  hist(mc3[, k], probability = TRUE,
       xlim = c(minT, maxT),
       main = paste("gamma =", temps[k]),
       xlab = expression(theta))
  curve(c_posterior, lwd = 3, add = TRUE)
}

