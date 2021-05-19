library(cmdstanr)
library(rstan)
stanfit <- function(fit) rstan::read_stan_csv(fit$output_files())


impala <- c(15, 20, 21, 23, 26)
waterbuck <- c(53, 57, 66, 67, 72)

stan.data <- list(x = impala, n = length(impala), kappa_1 = 1, kappa_2 = 1)

raftery  <- cmdstanr::cmdstan_model("stan/raftery.stan")

fit <- stanfit(raftery$sample(data = stan.data,
                                  max_treedepth = 15,
                                  adapt_delta = .99,
                                  parallel_chains = 4))

fit
