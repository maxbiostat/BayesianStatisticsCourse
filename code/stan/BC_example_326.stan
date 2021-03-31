data{
  int<lower=1> N;
  real x[N];
  int<lower=1,upper=2> prior;
}
parameters{
  real theta;
}
model{
  target += normal_lpdf(x | theta, 1);
  if(prior == 1){
    target += normal_lpdf(theta | 0, sqrt(2.19));
  }else{
    target += cauchy_lpdf(theta | 0, 1);
  }
}
generated quantities{
  real x_pred[N];
  for(i in 1:N) x_pred[i] = normal_rng(theta, 1);
}