## See Bayesian Choice, pg. 181
posterior_ccdf <- function(n0, m){
  if(n0 < 1 || m < 1 || n0 <  m) stop("Something is wrong, check your parameters")
  require(VGAM)
  lnum <- log(VGAM::zeta(x = 2, shift = n0))
  ldenom <- log(VGAM::zeta(x = 2, shift = m))
  return(exp(lnum - ldenom))  
}
posterior_ccdf <- Vectorize(posterior_ccdf)
approximate_posterior_ccdf <- function(n0, m){
  m/n0
}
approximate_posterior_ccdf <- Vectorize(approximate_posterior_ccdf)

obs.tram.number <- 100

k <- 10

N0s <- obs.tram.number:(k*obs.tram.number)

ps <- posterior_ccdf(n0 = N0s, m = obs.tram.number)
app.ps <- approximate_posterior_ccdf(n0 = N0s, m = obs.tram.number)

plot(N0s, 1-ps, type = "l", lwd = 3, 
     main = "CDF of N given T",
     xlab = expression(n[0]), ylab = expression(Pr(N >= n[0])))
lines(N0s, 1-app.ps, col = 2, lwd = 2, lty = 2)
legend(x="bottomright",
       legend = c("Exact", "Approximate"),
       col = 1:2, lty = 1:2, lwd = 2, bty = 'n')
abline(h = 1/2, lty = 2)
abline(v = 2*obs.tram.number, lwd = 2, col = 2, lty = 2)