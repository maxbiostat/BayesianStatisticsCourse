data{
  int<lower=1> n;
  real<lower=0> x[n];
  real<lower=0> kappa_1;
  real<lower=0> kappa_2;
}
transformed data{
  real S = sum(x);
}
parameters{
  real<lower=max(x)> N;
  real<lower=0, upper=1> theta;
}
transformed parameters{
  real lPbar = 0.0;
  for(j in 1:n) lPbar += lchoose(N, x[j]);
}
model{
 target += -lgamma(N + 1) + lgamma(N + kappa_1) + lPbar;
 target += (-N + S)*log(theta) + (n*N -S)*log1m(theta)
 -(N + kappa_1)*log(1/theta + kappa_2);
}
