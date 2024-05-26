data{
  int n;
  vector[n] x;
  real prior_loc;
  real<lower=0> prior_scale;
}
parameters{
  real theta;
}
model{
  target += cauchy_lpdf(x | theta, 1);
  target += normal_lpdf(theta | prior_loc, prior_scale);
}