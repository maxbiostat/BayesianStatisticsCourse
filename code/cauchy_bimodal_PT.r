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

