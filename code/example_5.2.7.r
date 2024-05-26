log1pexp <- function(x)
{
  ## taken from https://github.com/mfasiolo/qgam/blob/3bff42449b865a12c264c5b61438def5d74fdc70/R/log1pexp.R
  indx <- .bincode(x, 
                   c(-Inf, -37, 18, 33.3, Inf), 
                   right = TRUE, 
                   include.lowest = TRUE)
  
  kk <- which(indx==1)
  if( length(kk) ){  x[kk] <- exp(x[kk])  }
  
  kk <- which(indx==2)
  if( length(kk) ){  x[kk] <- log1p( exp(x[kk]) ) }
  
  kk <- which(indx==3)
  if( length(kk) ){  x[kk] <- x[kk] + exp(-x[kk]) }
  
  return(x)
}
####

logPr <- function(x, n, rho0){
  -log1pexp(
    log1p(-rho0)-log(rho0) +
      n * log(2) + 
      lbeta(x + 1, n -x +1)
  )
}

f_rho <- function(rho){
  exp(logPr(x = 5, n = 10, rho0 = rho))
}
f_rho <- Vectorize(f_rho)

curve(f_rho, xlab = expression(rho[0]), ylab = "Posterior probability",
      main = "x = 5, n = 10")

f_x <- function(x){
  exp(logPr(x = x, n = 10, rho0 = 1/2))
}
f_x <- Vectorize(f_x)

curve(f_x, 0, 10,
      xlab = expression(x), ylab = "Posterior probability",
      main = "n = 10, rho0 = 1/2")
