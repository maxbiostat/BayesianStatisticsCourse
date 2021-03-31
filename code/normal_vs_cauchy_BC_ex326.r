M <- 1E6
theta.samp.1 <- rnorm(M, mean = 0, sd = sqrt(2.19))
theta.samp.2 <- rcauchy(M)

predictive.X1 <- rnorm(M, mean = theta.samp.1, sd = 1)
predictive.X2 <- rnorm(M, mean = theta.samp.2, sd = 1)


library(ggplot2)

forplot <- data.frame(x_pred = c(predictive.X1, predictive.X2),
                      prior = rep(c("Normal", "Cauchy"), each = M))

p0 <- ggplot(forplot,
                      aes(x = x_pred, colour = prior, fill = prior)) +
       geom_density(alpha = .4) +
  scale_x_continuous(expression(x[pred]), limits = c(-10, 10)) +
  scale_y_continuous("Density", expand = c(0, 0)) +
  theme_bw(base_size = 16) + 
  geom_vline(xintercept = c(-4, 4), linetype = "longdash") + 
  theme(legend.position = "bottom",
        legend.justification = "centre",
        legend.title = element_blank(),
        strip.background = element_blank(),
        strip.text.y = element_blank(),
        legend.margin = margin(0, 0, 0, 0),
        legend.box.margin = margin(0, 0, 0, 0))

p0

ggsave(plot = p0, filename = "../slides/figures/BC_example_326.pdf")

#### Second part: inference
## First let's generate some data

N <- 3
true_theta <- -20
X <- rnorm(n = N, mean = true_theta, sd = 1)

## Now let's fit the model under both priors
library(cmdstanr)
library(rstan)
stanfit <- function(fit) rstan::read_stan_csv(fit$output_files())

example_326  <- cmdstanr::cmdstan_model("stan/BC_example_326.stan")

stan.data <- list(N = N, x = X, prior = 1)
fit.normal <- stanfit(example_326$sample(data = stan.data, refresh = 0))
stan.data$prior <- 2
fit.cauchy <- stanfit(example_326$sample(data = stan.data, refresh = 0))
  
theta.df <- data.frame(
  theta = c(extract(fit.normal, 'theta')$theta,
            extract(fit.cauchy, 'theta')$theta)
)
theta.df$prior <- rep(c("Normal", "Cauchy"), each = nrow(theta.df)/2)

## Compare posteriors
p1 <- ggplot(theta.df,
             aes(x = theta, colour = prior, fill = prior)) +
  geom_density(alpha = .4) +
  scale_x_continuous(expression(theta)) +
  scale_y_continuous("Density", expand = c(0, 0)) +
  theme_bw(base_size = 16) + 
  theme(legend.position = "bottom",
        legend.justification = "centre",
        legend.title = element_blank(),
        strip.background = element_blank(),
        strip.text.y = element_blank(),
        legend.margin = margin(0, 0, 0, 0),
        legend.box.margin = margin(0, 0, 0, 0))
p1

## Compare posterior predictives
pred.df <- data.frame(
  x_pred = c(as.vector(extract(fit.normal, 'x_pred')$x_pred),
             as.vector(extract(fit.cauchy, 'x_pred')$x_pred))
)
pred.df$prior <- rep(c("Normal", "Cauchy"), each = nrow(pred.df)/2)


p2 <- ggplot(pred.df,
             aes(x = x_pred, colour = prior, fill = prior)) +
  geom_density(alpha = .4) +
  scale_x_continuous(expression(x[pred])) +
  scale_y_continuous("Density", expand = c(0, 0)) +
  theme_bw(base_size = 16) + 
  # geom_vline(xintercept = c(-4, 4), linetype = "longdash") + 
  theme(legend.position = "bottom",
        legend.justification = "centre",
        legend.title = element_blank(),
        strip.background = element_blank(),
        strip.text.y = element_blank(),
        legend.margin = margin(0, 0, 0, 0),
        legend.box.margin = margin(0, 0, 0, 0))

p2
