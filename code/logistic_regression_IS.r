# ==============================================================================
# Importance Sampling for Logistic Regression Posteriors
# PhD Bayesian Statistics --- Computational Methods Case Study
#
# Model:
#   y_i | beta ~ Bernoulli(sigmoid(x_i^T beta)),  i = 1, ..., n
#   beta ~ N(0, sigma^2 * I_p)
#
# The posterior p(beta | y) is analytically intractable. We compare two
# importance sampling proposals:
#   (1) Naive / prior proposal:    q(beta) = N(0, sigma^2 * I_p)
#   (2) Informed / Laplace proposal: q(beta) = N(beta_MAP, Sigma_LA)
#       where beta_MAP is found by gradient ascent on the log-posterior and
#       Sigma_LA = [-H(beta_MAP)]^{-1} is the inverse of the negative Hessian.
#
# Self-normalised IS weights are used throughout since the normalising
# constant Z = p(y) is unavailable in closed form.
#
# AI GENERATION NOTICE
# ------------------------------------------------------------------------------
# This script was generated with the assistance of Claude Sonnet 4.6
# (Anthropic, model string: claude-sonnet-4-6), in an interactive session on
# May 13, 2026. The session began with a discussion of instructive importance
# sampling examples for PhD Bayesian statistics teaching, focusing on cases
# where the target is a genuine posterior and the normalising constant is
# unknown. The first example selected was logistic regression with a Gaussian
# prior. An interactive HTML/JS visualisation was first built in-chat
# contrasting the prior proposal against a Laplace proposal, after which this
# self-contained R script was requested. Key design decisions adopted during
# the session:
#   - MAP found via vanilla gradient ascent (avoids external optimisers);
#   - Laplace covariance via direct inversion of the observed Hessian, computed
#     analytically from the logistic likelihood and Gaussian prior;
#   - self-normalised IS throughout, with log-sum-exp stabilisation;
#   - ESS = (sum w_i)^2 / sum(w_i^2) as the primary diagnostic;
#   - weight visualisation sorted in descending order to expose collapse;
#   - convergence plot of the running IS mean of E[beta_j | y] for both
#     proposals, to illustrate stability differences;
#   - all functions self-contained and re-usable with clear argument contracts.
# The code was reviewed and approved by the course instructor.
# ==============================================================================

library(MASS)
library(ggplot2)
library(patchwork)

sigmoid <- function(eta) 1 / (1 + exp(-eta))

log_posterior_unnorm <- function(beta, X, y, sigma2) {
  eta    <- as.vector(X %*% beta)
  loglik <- sum(y * eta - log1p(exp(eta)))
  logpri <- -0.5 * sum(beta^2) / sigma2
  loglik + logpri
}

generate_data <- function(n, true_beta, seed = 42) {
  set.seed(seed)
  p <- length(true_beta)
  X <- cbind(1, matrix(rnorm(n * (p - 1)), n, p - 1))
  eta <- as.vector(X %*% true_beta)
  y <- rbinom(n, 1, sigmoid(eta))
  list(X = X, y = y)
}

laplace_approx <- function(X, y, sigma2, tol = 1e-7, max_iter = 5000, lr = 0.05) {
  p    <- ncol(X)
  beta <- rep(0, p)
  
  for (iter in seq_len(max_iter)) {
    eta  <- as.vector(X %*% beta)
    mu   <- sigmoid(eta)
    grad <- t(X) %*% (y - mu) - beta / sigma2
    beta_new <- beta + lr * grad
    if (max(abs(beta_new - beta)) < tol) { beta <- beta_new; break }
    beta <- beta_new
  }
  
  W      <- diag(as.vector(sigmoid(X %*% beta) * (1 - sigmoid(X %*% beta))))
  H_neg  <- t(X) %*% W %*% X + diag(p) / sigma2
  Sigma  <- solve(H_neg)
  
  list(map = beta, Sigma = Sigma)
}

importance_weights <- function(betas, log_target_fn, log_proposal_fn) {
  log_w   <- apply(betas, 1, log_target_fn) - apply(betas, 1, log_proposal_fn)
  log_w   <- log_w - max(log_w)
  w       <- exp(log_w)
  w_norm  <- w / sum(w)
  w_norm
}

ess <- function(w_norm) 1 / sum(w_norm^2)

run_is_prior <- function(N, X, y, sigma2) {
  p     <- ncol(X)
  betas <- matrix(rnorm(N * p, mean = 0, sd = sqrt(sigma2)), N, p)
  
  log_target   <- function(b) log_posterior_unnorm(b, X, y, sigma2)
  log_proposal <- function(b) sum(dnorm(b, 0, sqrt(sigma2), log = TRUE))
  
  w <- importance_weights(betas, log_target, log_proposal)
  list(betas = betas, weights = w, ess = ess(w), label = "Prior proposal")
}

run_is_laplace <- function(N, X, y, sigma2, lap) {
  p     <- ncol(X)
  betas <- mvrnorm(N, mu = lap$map, Sigma = lap$Sigma)
  
  log_target   <- function(b) log_posterior_unnorm(b, X, y, sigma2)
  log_proposal <- function(b) dmvnorm_log(b, lap$map, lap$Sigma)
  
  w <- importance_weights(betas, log_target, log_proposal)
  list(betas = betas, weights = w, ess = ess(w), label = "Laplace proposal")
}

dmvnorm_log <- function(x, mu, Sigma) {
  p      <- length(x)
  d      <- x - mu
  ch     <- chol(Sigma)
  z      <- backsolve(ch, d, transpose = TRUE)
  -0.5 * p * log(2 * pi) - sum(log(diag(ch))) - 0.5 * sum(z^2)
}

plot_weights <- function(is_prior, is_laplace) {
  make_df <- function(res) {
    w_sorted <- sort(res$weights, decreasing = TRUE)
    n_show   <- min(length(w_sorted), 300)
    data.frame(
      rank   = seq_len(n_show),
      weight = w_sorted[seq_len(n_show)],
      label  = res$label
    )
  }
  
  df      <- rbind(make_df(is_prior), make_df(is_laplace))
  N       <- length(is_prior$weights)
  uniform <- 1 / N
  
  ggplot(df, aes(x = rank, y = weight, fill = label)) +
    geom_col(width = 1, alpha = 0.85) +
    geom_hline(yintercept = uniform, linetype = "dashed", colour = "firebrick", linewidth = 0.6) +
    facet_wrap(~label, scales = "free_y", ncol = 1) +
    scale_fill_manual(values = c("Prior proposal" = "#378ADD", "Laplace proposal" = "#639922")) +
    labs(
      title   = "Normalised importance weights (sorted descending)",
      subtitle = "Dashed line = 1/N (ideal uniform weights)",
      x = "Rank", y = expression(tilde(w)[i])
    ) +
    theme_bw(base_size = 12) +
    theme(legend.position = "none", strip.text = element_text(face = "bold"))
}

plot_ess <- function(is_prior, is_laplace) {
  N <- length(is_prior$weights)
  
  df <- data.frame(
    label = c("Prior proposal", "Laplace proposal"),
    ess   = c(is_prior$ess, is_laplace$ess),
    ess_pct = 100 * c(is_prior$ess, is_laplace$ess) / N
  )
  
  ggplot(df, aes(x = label, y = ess_pct, fill = label)) +
    geom_col(width = 0.45, alpha = 0.9) +
    geom_text(aes(label = sprintf("ESS = %.0f\n(%.1f%%)", ess, ess_pct)),
              vjust = -0.4, size = 3.8) +
    scale_fill_manual(values = c("Prior proposal" = "#378ADD", "Laplace proposal" = "#639922")) +
    scale_y_continuous(limits = c(0, 105), labels = function(x) paste0(x, "%")) +
    labs(
      title    = "Effective sample size",
      subtitle = sprintf("N = %d total draws", N),
      x = NULL, y = "ESS  /  N  (%)"
    ) +
    theme_bw(base_size = 12) +
    theme(legend.position = "none")
}

plot_convergence <- function(is_prior, is_laplace, component = 2) {
  running_mean <- function(betas, weights) {
    n    <- nrow(betas)
    cumw <- cumsum(weights)
    cumwb <- cumsum(weights * betas[, component])
    cumwb / cumw
  }
  
  n     <- nrow(is_prior$betas)
  steps <- seq(1, n, length.out = min(n, 500))
  
  df <- rbind(
    data.frame(iter = steps,
               est  = running_mean(is_prior$betas, is_prior$weights)[steps],
               label = "Prior proposal"),
    data.frame(iter = steps,
               est  = running_mean(is_laplace$betas, is_laplace$weights)[steps],
               label = "Laplace proposal")
  )
  
  ggplot(df, aes(x = iter, y = est, colour = label)) +
    geom_line(linewidth = 0.8) +
    scale_colour_manual(values = c("Prior proposal" = "#378ADD", "Laplace proposal" = "#639922")) +
    labs(
      title    = bquote("Running IS estimate of" ~ E(beta[.(component - 1)] ~ "|" ~ bold(y))),
      subtitle = "Self-normalised estimator; each proposal independently sampled",
      x = "Sample index", y = "Running estimate",
      colour = NULL
    ) +
    theme_bw(base_size = 12) +
    theme(legend.position = "bottom")
}

plot_laplace_approx <- function(lap, sigma2, K_max = 5, stan_draws = NULL) {
  p <- length(lap$map)
  K <- min(p, K_max)
  
  beta_names <- if (!is.null(colnames(lap$map))) {
    colnames(lap$map)[seq_len(K)]
  } else {
    paste0("beta[", seq_len(K) - 1, "]")
  }
  
  plots <- vector("list", K)
  
  for (k in seq_len(K)) {
    mu_k    <- lap$map[k]
    sd_k    <- sqrt(lap$Sigma[k, k])
    x_range <- mu_k + c(-4, 4) * sd_k
    
    if (!is.null(stan_draws)) {
      stan_col <- stan_draws[, k]
      x_range  <- range(c(x_range, quantile(stan_col, c(0.001, 0.999))))
    }
    
    x_grid   <- seq(x_range[1], x_range[2], length.out = 300)
    lap_dens <- dnorm(x_grid, mean = mu_k, sd = sd_k)
    
    df_lap <- data.frame(x = x_grid, density = lap_dens)
    
    beta_label <- parse(text = beta_names[k])
    
    g <- ggplot() +
      labs(
        title = beta_label,
        x     = beta_label,
        y     = "density"
      ) +
      theme_bw(base_size = 11) +
      theme(plot.title = element_text(hjust = 0.5, size = 11))
    
    if (!is.null(stan_draws)) {
      df_stan <- data.frame(x = stan_draws[, k])
      g <- g +
        geom_histogram(
          data     = df_stan,
          aes(x = x, y = after_stat(density)),
          bins     = 40,
          fill     = "#CCCCCC",
          colour   = "white",
          alpha    = 0.7
        )
    }
    
    g <- g +
      geom_line(
        data      = df_lap,
        aes(x = x, y = density),
        colour    = "#639922",
        linewidth = 0.9
      ) +
      geom_vline(
        xintercept = mu_k,
        linetype   = "dashed",
        colour     = "#639922",
        linewidth  = 0.5
      )
    
    plots[[k]] <- g
  }
  
  wrap_plots(plots, nrow = 1) +
    plot_annotation(
      title    = "Laplace marginals vs posterior (Stan)",
      subtitle = sprintf(
        "Green curve = Laplace N(MAP, diag(Sigma_LA)); grey = Stan posterior draws | first K = %d of p = %d coefficients shown",
        K, p
      ),
      theme = theme(plot.title = element_text(face = "bold", size = 13))
    )
}

summarise_is <- function(is_result, label = NULL) {
  if (is.null(label)) label <- is_result$label
  N       <- length(is_result$weights)
  post_means <- colSums(is_result$weights * is_result$betas)
  cat(sprintf("\n--- %s ---\n", label))
  cat(sprintf("  N             : %d\n", N))
  cat(sprintf("  ESS           : %.1f  (%.2f%%)\n", is_result$ess, 100 * is_result$ess / N))
  cat(sprintf("  Max weight    : %.6f  (ideal = %.6f)\n", max(is_result$weights), 1 / N))
  cat(sprintf("  Post. means   : %s\n", paste(sprintf("%.4f", post_means), collapse = ", ")))
}


# ==============================================================================
# Example usage
# ==============================================================================

true_beta <- c(0.5, 1.2)
sigma2    <- 4
N         <- 2000
n_obs     <- 10

dat <- generate_data(n_obs, true_beta, seed = 7)
X   <- dat$X
y   <- dat$y

lap       <- laplace_approx(X, y, sigma2)
is_prior  <- run_is_prior(N, X, y, sigma2)
is_lap    <- run_is_laplace(N, X, y, sigma2, lap)

summarise_is(is_prior)
summarise_is(is_lap)

p1 <- plot_weights(is_prior, is_lap)
p2 <- plot_ess(is_prior, is_lap)
p3 <- plot_convergence(is_prior, is_lap, component = 2)

(p1 | p2) / p3 +
  plot_annotation(
    title    = "Importance sampling: prior vs Laplace proposal",
    subtitle = sprintf("Logistic regression, p = %d, n = %d, sigma^2 = %.0f, N = %d",
                       ncol(X), n_obs, sigma2, N),
    theme    = theme(plot.title = element_text(face = "bold", size = 14))
  )

plot_laplace_approx(lap, sigma2)

# ==============================================================================
# Once Stan posterior draws are available, pass them in as a matrix with one
# column per coefficient (same column ordering as X) to overlay histograms:
#
#   stan_draws <- as.matrix(fit_stan, pars = "beta")   # N_draws x p matrix
#   plot_laplace_approx(lap, sigma2, stan_draws = stan_draws)
# ==============================================================================