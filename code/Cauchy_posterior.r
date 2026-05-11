# ==============================================================================
# Laplace Approximation for Cauchy Location Posterior
# Schervish Example 7.104 / PhD Bayesian Statistics Case Study
#
# Prior: N(m0, v0) on theta. Set v0 = Inf for a flat (improper) prior.
# Conjugate precision additivity: the normal prior contributes a fixed
# precision 1/v0 to the posterior curvature, which is 0 when v0 = Inf.
# ==============================================================================
#
# AI GENERATION NOTICE
# ------------------------------------------------------------------------------
# This script was generated with the assistance of Claude Sonnet (Anthropic),
# in an interactive session on May 11, 2026. The mathematical derivations
# (log-likelihood, score, curvature, third derivative) were worked out
# collaboratively in the session and then transcribed into code. Key design
# decisions discussed and adopted during the session include:
#   - Newton-Raphson for finding the posterior mode, initialised at the sample
#     median;
#   - exploitation of precision additivity from the normal prior, with v0 = Inf
#     as a clean special case recovering the flat prior;
#   - numerical normalisation of the true posterior via the trapezoidal rule,
#     consistent with Schervish's approach;
#   - adaptive theta grid based on 4 posterior SDs around the mode.
# The code was reviewed and approved by the course instructor.
# ==============================================================================
# ------------------------------------------------------------------------------
# Log-likelihood, score, and second derivative
# ------------------------------------------------------------------------------

log_lik <- function(theta, x) {
  -length(x) * log(pi) - sum(log(1 + (x - theta)^2))
}

score_lik <- function(theta, x) {
  sum(2 * (x - theta) / (1 + (x - theta)^2))
}

curv_lik <- function(theta, x) {
  u <- x - theta
  sum((2 * u^2 - 2) / (1 + u^2)^2)
}

# ------------------------------------------------------------------------------
# Log-posterior, score, and curvature
# Normal prior N(m0, v0) contributes precision 1/v0; set v0 = Inf for flat prior
# ------------------------------------------------------------------------------

log_posterior_unnorm <- function(theta, x, m0 = 0, v0 = Inf) {
  log_lik(theta, x) - (theta - m0)^2 / (2 * v0)   # second term is 0 when v0 = Inf
}

score_posterior <- function(theta, x, m0 = 0, v0 = Inf) {
  score_lik(theta, x) - (theta - m0) / v0           # prior score term is 0 when v0 = Inf
}

curv_posterior <- function(theta, x, v0 = Inf) {
  curv_lik(theta, x) - 1 / v0                       # prior precision is 0 when v0 = Inf
}

# ------------------------------------------------------------------------------
# Newton-Raphson to find posterior mode and Laplace approximation parameters
# ------------------------------------------------------------------------------

laplace_cauchy <- function(x,
                           m0         = 0,
                           v0         = Inf,
                           theta_init = median(x),
                           tol        = 1e-8,
                           max_iter   = 100,
                           verbose    = TRUE) {
  theta <- theta_init
  
  for (iter in seq_len(max_iter)) {
    s  <- score_posterior(theta, x, m0, v0)
    d2 <- curv_posterior(theta, x, v0)
    
    if (abs(d2) < .Machine$double.eps)
      stop("Second derivative is zero; Newton-Raphson failed.")
    
    step  <- s / d2
    theta <- theta - step
    
    if (verbose)
      cat(sprintf("Iter %3d | theta = %.6f | score = %.2e\n", iter, theta, s))
    
    if (abs(step) < tol) break
  }
  
  mode        <- theta
  post_var    <- -1 / curv_posterior(mode, x, v0)   # = 1 / (I(theta) + 1/v0)
  post_sd     <- sqrt(post_var)
  
  if (verbose) {
    prior_str <- if (is.infinite(v0)) "Flat (improper)"
    else sprintf("N(m0 = %.2f, v0 = %.2f)", m0, v0)
    cat("\n--- Laplace Approximation Results ---\n")
    cat(sprintf("Prior           : %s\n", prior_str))
    cat(sprintf("Posterior mode  : %.4f\n", mode))
    cat(sprintf("Curvature       : %.5f\n", curv_posterior(mode, x, v0)))
    cat(sprintf("Posterior var   : %.4f\n", post_var))
    cat(sprintf("Posterior sd    : %.4f\n", post_sd))
  }
  
  list(
    mode       = mode,
    post_var   = post_var,
    post_sd    = post_sd,
    m0         = m0,
    v0         = v0,
    iterations = iter
  )
}

# ------------------------------------------------------------------------------
# Compute posterior densities
# ------------------------------------------------------------------------------

posterior_densities <- function(fit, x, n_sd = 4, n_grid = 500) {
  theta_grid <- seq(fit$mode - n_sd * fit$post_sd,
                    fit$mode + n_sd * fit$post_sd,
                    length.out = n_grid)
  # Normal (Laplace) approximation density
  dens_normal <- dnorm(theta_grid, mean = fit$mode, sd = fit$post_sd)
  
  # Numerically normalised true posterior (trapezoidal rule)
  log_post <- sapply(theta_grid, log_posterior_unnorm,
                     x = x, m0 = fit$m0, v0 = fit$v0)
  log_post   <- log_post - max(log_post)          # stabilise before exp
  post_raw   <- exp(log_post)
  dtheta     <- theta_grid[2] - theta_grid[1]
  dens_numerical <- post_raw / (sum(post_raw) * dtheta)
  
  list(
    theta         = theta_grid,
    numerical     = dens_numerical,
    normal_approx = dens_normal
  )
}

# ------------------------------------------------------------------------------
# Plot posterior densities
# ------------------------------------------------------------------------------

plot_posterior <- function(dens, fit) {
  prior_str <- if (is.infinite(fit$v0)) "flat prior"
  else sprintf("N(%.1f, %.1f) prior", fit$m0, fit$v0)
  
  ymax <- max(dens$numerical, dens$normal_approx) * 1.05
  
  plot(dens$theta, dens$numerical,
       type = "l", lwd = 2, col = "black",
       ylim = c(0, ymax),
       xlab = expression(theta),
       ylab = "Density",
       main = sprintf("Posterior Density for \u03b8 in Cauchy Example (%s)", prior_str))
  
  lines(dens$theta, dens$normal_approx,
        lwd = 2, lty = 2, col = "steelblue")
  
  abline(v = fit$mode, lty = 3, col = "grey50")
  
  legend("topright",
         legend = c("Numerical posterior", "Normal (Laplace) approx.",
                    expression(hat(theta)[MAP])),
         lty    = c(1, 2, 3),
         lwd    = c(2, 2, 1),
         col    = c("black", "steelblue", "grey50"),
         bty    = "n")
}

# ==============================================================================
# Run for Schervish Example 7.104
# ==============================================================================

x <- c(-5, -3, 0, 2, 4, 5, 7, 9, 11, 14)

# --- Flat prior (reproduces Schervish): v0 = Inf ---
fit_flat  <- laplace_cauchy(x)
dens_flat <- posterior_densities(fit_flat, x)
plot_posterior(dens_flat, fit_flat)

# --- Normal prior example ---
mm0 <- 0
vv0 <- Inf # 10^2
fit_norm  <- laplace_cauchy(x, m0 = mm0, v0 = vv0)
dens_norm <- posterior_densities(fit_norm, x)
plot_posterior(dens_norm, fit_norm)
