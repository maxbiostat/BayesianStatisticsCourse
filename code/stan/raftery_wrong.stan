functions{
  real bin_lpdf(real x, real n, real p){
    real ans  = lchoose(n, x) + x*log(p) + (n-x)*log1m(p);
    return(ans);
  }
  real pois_lpdf(real z, real mu){
    real ans = -mu + z*log(mu) - lgamma(z + 1);
    return(ans);
  }
}
data{
  int<lower=1> n;
  real<lower=0> x[n];
  real<lower=0> kappa_1;
  real<lower=0> kappa_2;
}
parameters{
  real<lower=max(x)> N;
  real<lower=0, upper=1> theta;
  real<lower=0> mu;
}
model{
  for(j in 1:n) target += bin_lpdf(x[j] | N, theta);
  target += pois_lpdf(N | mu);
}
