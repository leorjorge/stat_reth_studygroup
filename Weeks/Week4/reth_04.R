library(cmdstanr)
library(rethinking)
check_cmdstan_toolchain(fix = TRUE, quiet = TRUE)

## 4.1 Deducing the normal distribution as process
#addition (binomial and continuous)
par(mfrow = c(1,2))
pos <- replicate(1e4, sum(rbinom(64, prob = 0.5, size = 1)*2-1))
plot(density(pos))
pos <- replicate(1e4, sum(runif(16, -1, 1)))
plot(density(pos))
par(mfrow = c(1,1))

# product
growth <- replicate(1e4, prod(1 + runif(12,0,0.1)))
big <- replicate( 1e4 , prod( 1 + runif(12,0,0.5) ) )
small <- replicate( 1e4 , prod( 1 + runif(12,0,0.01) ) )
log.big <- replicate( 1e4 , log(prod(1 + runif(12,0,0.5))) )
par(mfrow = c(2,2))
dens(small, norm.comp=TRUE , main = "small")
dens(growth, norm.comp=TRUE, main = "medium")
dens(big, norm.comp=TRUE, main = "big")
dens(log.big, norm.comp=TRUE, main = "big.log")
par(mfrow = c(1,1))

##### Modelling Weight #####

## 4.3 Weight mean and sd (no predictors)
data(Howell1)
d <- Howell1
d.a <- d[d$age>=18,]
precis(d.a)
#data and priors
dens(d.a$weight)
curve(dnorm(x, 50, 20), from=-10, to=200)
curve(dunif(x, 0, 50), from=-10, to=60)
#prior predictive simulation
sample_mu <- rnorm( 1e4 , 50 , 20 )
sample_sigma <- runif( 1e4 , 0 , 50 )
prior_w <- rnorm( 1e4 , sample_mu , sample_sigma)
dens(prior_w, xlim = c(-350, 350))
sample_mu <- rnorm(1e4, 50, 100)
prior_w <- rnorm(1e4, sample_mu, sample_sigma)
dens(prior_w, add = T, col = 2)

#grid approximation
mu.grid <- seq(from=30, to=80 , length.out=1000) 
sigma.grid <- seq(from=4 , to=9 , length.out=1000) 
post <- expand.grid(mu=mu.grid , sigma=sigma.grid) 
post$LL <- sapply(1:nrow(post) , function(i) sum(dnorm(d.a$weight, post$mu[i], post$sigma[i], log=TRUE))) 
post$prod <- post$LL + dnorm(post$mu, 50, 20, log = TRUE) + dunif(post$sigma, 0, 50, log = TRUE) 
post$prob <- exp(post$prod - max(post$prod))

contour_xyz(post$mu, post$sigma, post$prob, xlim = c(40, 50), ylim = c(5.5, 7.5))
image_xyz(post$mu, post$sigma, post$prob, xlim = c(44, 46), ylim = c(5.7, 7.2))

sample.rows <- sample(1:nrow(post), size=1e4, replace=TRUE, prob=post$prob) 
sample.mu <- post$mu[sample.rows] 
sample.sigma <- post$sigma[sample.rows]

plot(sample.mu, sample.sigma, cex=1, pch=16, col=col.alpha(rangi2,0.1))

dens(sample.mu) 
dens(sample.sigma)
PI(sample.mu) 
PI(sample.sigma)

Weight_model <- cmdstan_model(stan_file = "Weeks/Week4/reth_4_weight.stan")
Weight_fit <- Weight_model$sample(
   data = list(W = d.a$weight, N = nrow(d.a)),
   chains = 8,
   parallel_chains = 4,
   refresh = 500
)
Weight_fit$cmdstan_summary()
precis(Weight_fit)

Weight_post <- Weight_fit$draws(format = "df")
precis(as.data.frame(Weight_post))

dens(Weight_post$mu)
dens(Weight_post$sigma)
plot(Weight_post$mu, Weight_post$sigma, cex=1 , pch=16 , col=col.alpha(rangi2,0.2) )

d.s <- sample(d.a$weight , size=20 )
Weight_fit.s <- Weight_model$sample(
   data = list(W = d.s, N = length(d.s)),
   chains = 8,
   parallel_chains = 4,
   refresh = 500)
Weight.s_post <- Weight_fit.s$draws(format = "df")
plot(Weight.s_post$mu, Weight.s_post$sigma , cex=0.5 ,
      col=col.alpha(rangi2,0.1) ,
      xlab="mu" , ylab="sigma" , pch=16 )
dens(Weight.s_post$sigma, norm.comp=TRUE )

### 4.4 Weight as a function of height

# Generative model (only from the lecture)
sim_weight <- function(H, b, sd){
   U <- rnorm(length(H), 0, sd)
   W <- b*H + U
   return(W)
}

H <- runif(20, 130, 200)
W <- sim_weight(H, b = 0.5, sd = 5)
plot(W~H, col = 2, lwd = 3)

plot(d.a$weight ~ d.a$height, col = 2, lwd = 3)

WeightHeight_model <- cmdstan_model(stan_file = "Weeks/Week4/reth_04_HW.stan")
## prior predictive
n <- 1e3
a <- rnorm(n, 0, 30)
b <- runif(n, 0, 1)

plot(NULL, xlim = c(130, 200), ylim = c(50, 90))
for(j in 1:50) abline(a = a[j], b = b[j], lwd = 2, col = 2)

## Simulated data
WH_Sim_fit <- WeightHeight_model$sample(
   data = list(H = H, W = W, N = length(H)),
   chains = 8,
   parallel_chains = 4,
   refresh = 500
)
WH_Sim_fit
precis(WH_Sim_fit)
WH_Sim_post <- WH_Sim_fit$draws(format = "df")

## Fit the real data
WH_fit <- WeightHeight_model$sample(
   data = list(H = d.a$height, W = d.a$weight, N = nrow(d.a)),
   chains = 8,
   parallel_chains = 4,
   refresh = 500
)
WH_fit
precis(WH_fit)
summary(lm(weight~height, data = d.a))
WH_post <- WH_fit$draws(format = "df")

## Posterior mu
height_seq <- seq(from = 130, to = 190)
WH_postpred_mu <- matrix(nrow = nrow(WH_post), ncol = length(height_seq))
for(i in 1:ncol(WH_postpred_mu)){
   WH_postpred_mu[ ,i] <- WH_post$alfa + WH_post$beta*height_seq[i]
}
mean_mu <- apply(WH_postpred_mu, 2, mean)

#posterior predictive
WH_postpred_W <- matrix(nrow = nrow(WH_post), ncol = length(height_seq))
for(i in 1:length(WH_postpred_mu)){
   WH_postpred_W[i] <- rnorm(n = 1, mean = WH_postpred_mu[i], sd = WH_post$sigma)
}

plot(d.a$weight ~ d.a$height, col = 2, lwd = 3)
for(j in 1:1000){
   lines(height_seq, WH_postpred_mu[sample(1:8000, 1), ], lwd = 1, col = col.alpha(2, alpha = 0.01))
}
lines(height_seq, mean_mu, lwd = 3, col = 2)
shade(apply(WH_postpred_mu, 2, PI, prob = 0.95), height_seq, col = col.alpha(acol = 2, alpha = 0.2))

W_PI <- apply(WH_postpred_W, 2, PI, prob = 0.65)
shade(W_PI, height_seq, lty = 2, lwd = 2, col = col.alpha(acol = "black", alpha = 0.2))

W_PI <- apply(WH_postpred_W, 2, PI, prob = 0.95)
shade(W_PI, height_seq, lty = 2, lwd = 2, col = col.alpha(acol = "black", alpha = 0.2))


## Centered model like in the chapter - what are the advantages and disadvantages?
WH_centered_model <- cmdstan_model(stan_file = "Weeks/Week4/reth_04_HW_centered.stan")
WH_centered_fit <- WH_centered_model$sample(
   data = list(H = d.a$height, W = d.a$weight, N = nrow(d.a)),
   chains = 8,
   parallel_chains = 4,
   refresh = 500
)
WH_centered_fit
precis(WH_centered_fit)
WH_centered_post <- WH_centered_fit$draws(format = "df")

## Posterior mu
WH_centered_postpred_mu <- matrix(nrow = nrow(WH_centered_post), ncol = length(height_seq))
for(i in 1:ncol(WH_centered_postpred_mu)){
   WH_centered_postpred_mu[ ,i] <- WH_centered_post$alfa + WH_centered_post$beta*(height_seq[i]-mean(d.a$height))
}
mean_mu_centered <- apply(WH_centered_postpred_mu, 2, mean)

#posterior predictive
WH_centered_postpred_W <- matrix(nrow = nrow(WH_centered_post), ncol = length(height_seq))
for(i in 1:length(WH_centered_postpred_mu)){
   WH_centered_postpred_W[i] <- rnorm(n = 1, mean = WH_centered_postpred_mu[i], sd = WH_centered_post$sigma)
}

plot(d.a$weight ~ d.a$height, col = 2, lwd = 3)
for(j in 1:1000){
   lines(height_seq, WH_centered_postpred_mu[sample(1:8000, 1),], lwd = 1, col = col.alpha(2, alpha = 0.01))
}
lines(height_seq, mean_mu_centered, lwd = 3, col = 2)

WH_centered_PI <- apply(WH_centered_postpred_W, 2, PI, prob = 0.5)
shade(WH_centered_PI, height_seq, lty = 2, lwd = 2, col = col.alpha(acol = "black", alpha = 0.1))

WH_centered_PI <- apply(WH_centered_postpred_W, 2, PI, prob = 0.65)
shade(WH_centered_PI, height_seq, lty = 2, lwd = 2, col = col.alpha(acol = "black", alpha = 0.1))

WH_centered_PI <- apply(WH_centered_postpred_W, 2, PI, prob = 0.95)
shade(WH_centered_PI, height_seq, lty = 2, lwd = 2, col = col.alpha(acol = "black", alpha = 0.1))

WH_centered_PI <- apply(WH_centered_postpred_W, 2, PI, prob = 0.99)
shade(WH_centered_PI, height_seq, lty = 2, lwd = 2, col = col.alpha(acol = "black", alpha = 0.1))
