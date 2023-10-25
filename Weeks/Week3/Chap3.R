library(rethinking)

## Chapter stuff

p_grid <- seq( from=0 , to=1 , length.out=1000 ) 
prob_p <- rep( 1 , 1000 ) 
prob_data <- dbinom( 6 , size=9 , prob=p_grid ) 
posterior <- prob_data * prob_p 
posterior <- posterior / sum(posterior)

samples <- sample( p_grid , prob=posterior , size=1e4 , replace=TRUE )

sum(samples < 0.5)/1e4

data(homeworkch3)


p0.1 <- rbinom(1e4, 9, 0.1)
p0.66 <- rbinom(1e4, 9, 0.66)
simplehist(p0.1, xlim = c(0,9))
points(table(p0.66), type = "h", col = 2, lwd = 2)
postpred <- rbinom(1e4, 9, samples)
simplehist(postpred, ylim = c(0, max(table(p0.66))))
points(table(p0.66), type = "h", col = 2, lwd = 2)

## 3H1
#calculating the posterior by grid approximation:
birth1
birth2
sum(c(birth1, birth2))
sum(c(birth1, birth2))/200

p_grid <- seq(from=0, to=1, length.out=1000) 
prior <- rep(1, 1000)
likelihood <- dbinom(sum(c(birth1, birth2)), size=length(c(birth1, birth2)), prob=p_grid)
posterior <- likelihood * prior 
posterior <- posterior / sum(posterior)

#Basic density plot
plot(p_grid, posterior, type = "l")
#Add the observed value
abline(v = 111/200, col = 2)

#What is the maximum likelihood estimate?
which.max(posterior)/1000
111/200

## 3H2
samples <- sample(p_grid, size = 1e4, replace = T, prob = posterior)
CIs <- HPDI(samples = samples, prob = c(0.5, 0.89, 0.97))
CIs2 <- HPDI(samples = samples, prob = c(0.67, 0.95, 0.99))
dens(samples, lwd = 2, xlim = c(0, 1))
abline(v = CIs, lty = c(3:1, 1:3))

## 3H3
postpred <- rbinom(1e4, size = length(c(birth1, birth2)), prob = samples)
simplehist(postpred, lwd = 2, xlim = c(0, length(c(birth1, birth2))))
PI(postpred)
abline(v = 111, col = 2)

## 3H4
postpredfirst <- rbinom(1e4, size = length(birth1), prob = samples)
simplehist(postpredfirst, lwd = 2, xlim = c(0, 100))
abline(v = sum(birth1), col = 2, lwd = 2)

## 3H5
birth2.0first <- birth2[birth1 == 0]
postpredsec <- rbinom(1e4, size = length(birth2.0first), prob = samples)
simplehist(postpredsec, lwd = 2, xlim = c(0, length(birth2.0first)))
abline(v = sum(birth2.0first), col = 2, lwd = 2)

table(birth1, birth2)

### Playing around

likelihood <- dbinom(sum(birth1), size=length(birth1), prob=p_grid) 
posterior.b1 <- likelihood * prior 
posterior.b1 <- posterior.b1 / sum(posterior.b1)
samples.b1 <- sample(p_grid, size = 1e4, replace = T, prob = posterior.b1)

likelihood <- dbinom(sum(birth2), size=length(birth2), prob=p_grid) 
posterior.b2 <- likelihood * prior 
posterior.b2 <- posterior.b2 / sum(posterior.b2)
samples.b2 <- sample(p_grid, size = 1e4, replace = T, prob = posterior.b2)

plot(p_grid, posterior, type = "l")
points(p_grid, posterior.b1, type = "l", col = 2)
points(p_grid, posterior.b2, type = "l", col = 3)
abline(v = c(111/200, sum(birth1)/100, sum(birth2)/100), col = 1:3)

predictive.all <- postpredfirst
predictive.b1 <- rbinom(1e4, size = 100, prob = samples.b1)
predictive.b2 <- rbinom(1e4, size = 100, prob = samples.b2)

simplehist(predictive.all, lwd = 4, xlim = c(0, length(birth1)))
points(table(predictive.b1), lwd = 2, type = "h", col = 2)
points(table(predictive.b2), lwd = 2, type = "h", col = 3)

