library(rethinking)

data(homeworkch3)

## 3H1
#calculating the posterior by grid approximation:
p_grid <- seq(from=0, to=1, length.out=1000) 
prior <- rep(1, 1000)
likelihood <- dbinom(111, size=200, prob=p_grid) 
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
dens(samples, lwd = 2, col = 2, xlim = c(0, 1))
abline(v = CIs, lty = c(3:1, 1:3))

## 3H3
postpred <- rbinom(1e4, size = 200, prob = samples)
dens(postpred, lwd = 2, col = 2, xlim = c(0, 200))
abline(v = 111, col = 2)

## 3H4
postpredfirst <- rbinom(1e4, size = 100, prob = samples)
simplehist(postpredfirst, lwd = 2, xlim = c(0, 100))
abline(v = sum(birth1), col = 2, lwd = 2)

## 3H5
birth2.0first <- birth2[birth1 == 0]
postpredsec <- rbinom(1e4, size = sum(birth2.0first), prob = samples)
simplehist(postpredsec, lwd = 2, xlim = c(0, length(birth2.0first)))
abline(v = sum(birth2.0first), col = 2, lwd = 2)
