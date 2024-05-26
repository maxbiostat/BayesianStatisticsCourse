library(cmdstanr)
library(rstan)
stanfit <- function(fit) rstan::read_stan_csv(fit$output_files())


impala <- c(15, 20, 21, 23, 26)
waterbuck <- c(53, 57, 66, 67, 72)
xobs <- impala[1]

stan.data <- list(x = c(xobs), n = length(xobs),
                  kappa_1 = 1, kappa_2 = .1,
                  M = 50000)

raftery  <- cmdstanr::cmdstan_model("stan/raftery_1.2_single_obs.stan")

fit <- stanfit(raftery$sample(data = stan.data,
                                  max_treedepth = 10,
                                  adapt_delta = .99,
                                  iter_warmup = 2000,
                                  iter_sampling = 2000,
                                  parallel_chains = 4))

fit

N.samples <- extract(fit, 'N')$N
quantile(N.samples, prob = c(.10, .90))
