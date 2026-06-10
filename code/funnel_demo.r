################################################################################
# Neal's Funnel in Stan using cmdstanr
#
# Demonstrates the "Funnel of Hell" and the benefits of non-centering.
################################################################################

library(cmdstanr)
library(posterior)

set.seed(666)

################################################################################
# Write Stan models
################################################################################

writeLines(
  '
parameters {
  real theta;
  real v;
}

model {
  v ~ normal(0, 3);
  theta ~ normal(0, exp(v / 2));
}
',
"funnel_centered.stan"
)

writeLines(
  '
parameters {
  real theta_tilde;
  real v;
}

transformed parameters {
  real theta = exp(v / 2) * theta_tilde;
}

model {
  v ~ normal(0, 3);
  theta_tilde ~ normal(0, 1);
}
',
"funnel_noncentered.stan"
)

# Compile models

mod_centered <- cmdstan_model("funnel_centered.stan")
mod_noncentered <- cmdstan_model("funnel_noncentered.stan")

# Sample from centered funnel

fit_centered <- mod_centered$sample(
  chains = 4,
  parallel_chains = 4,
  iter_warmup = 1000,
  iter_sampling = 1000,
  seed = 3252,
  refresh = 500
)

# Sample from non-centered funnel

fit_noncentered <- mod_noncentered$sample(
  chains = 4,
  parallel_chains = 4,
  iter_warmup = 1000,
  iter_sampling = 1000,
  seed = 3252,
  refresh = 500
)

# Extract draws

draws_centered <- fit_centered$draws(
  variables = c("theta", "v"),
  format = "draws_df"
)

draws_noncentered <- fit_noncentered$draws(
  variables = c("theta", "v"),
  format = "draws_df"
)

# Count divergences

diag_centered <- fit_centered$sampler_diagnostics()
diag_noncentered <- fit_noncentered$sampler_diagnostics()

n_div_centered <- sum(diag_centered[, , "divergent__"])
n_div_noncentered <- sum(diag_noncentered[, , "divergent__"])

cat("\n")
cat("Centered divergences:     ", n_div_centered, "\n")
cat("Non-centered divergences: ", n_div_noncentered, "\n")
cat("\n")

# Exact IID draws from the funnel

N_exact <- 4000

v_exact <- rnorm(N_exact, mean = 0, sd = 3)
theta_exact <- rnorm(
  N_exact,
  mean = 0,
  sd = exp(v_exact / 2)
)

# Basic summaries

cat("Centered summary:\n")
print(fit_centered$summary(c("theta", "v")))

cat("\nNon-centered summary:\n")
print(fit_noncentered$summary(c("theta", "v")))

# Plot comparison

op <- par(
  mfrow = c(1, 3),
  mar = c(4, 4, 3, 1)
)

plot(
  theta_exact,
  v_exact,
  pch = 16,
  cex = 0.4,
  col = rgb(0, 0.6, 0, 0.15),
  xlab = expression(theta),
  ylab = "v",
  main = "Exact IID Draws"
)

plot(
  draws_centered$theta,
  draws_centered$v,
  pch = 16,
  cex = 0.4,
  col = rgb(1, 0, 0, 0.15),
  xlab = expression(theta),
  ylab = "v",
  main = paste0(
    "Centered\n",
    n_div_centered,
    " divergences"
  )
)

plot(
  draws_noncentered$theta,
  draws_noncentered$v,
  pch = 16,
  cex = 0.4,
  col = rgb(0, 0, 1, 0.15),
  xlab = expression(theta),
  ylab = "v",
  main = paste0(
    "Non-centered\n",
    n_div_noncentered,
    " divergences"
  )
)

par(op)

# Optional: pair plots

op <- par(mfrow = c(1, 2))

plot(
  draws_centered$theta,
  draws_centered$v,
  pch = 16,
  cex = 0.3,
  col = rgb(1, 0, 0, 0.10),
  xlab = expression(theta),
  ylab = "v",
  main = "Centered"
)

plot(
  draws_noncentered$theta,
  draws_noncentered$v,
  pch = 16,
  cex = 0.3,
  col = rgb(0, 0, 1, 0.10),
  xlab = expression(theta),
  ylab = "v",
  main = "Non-centered"
)

par(op)