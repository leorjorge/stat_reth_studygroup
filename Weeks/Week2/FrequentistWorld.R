library(rethinking)

## A randomization-based frequentist approach (just because this is not a gaussian problem)

## function to toss a globe covered by p by water N times
sim_globe <- function(p = 0.7, N = 9){
   sample(c("W", "L"), size = N, prob = c(p, 1-p), replace = TRUE)
}

(sample <- sim_globe(p = 0.7, N = 9))
(p_bar <- sum(sample == "W"))

## all of the frequentist statistics is based on repeated sampling. If I would go back to the field and 
## sample infinite times following my null hypothesis, what is the probability I'd get such an extreme value?

## Our null hypothesis will be that the globe is 50% covered in water 

(null_samples <- t(replicate(sim_globe(p = 0.5), n = 1e4)))

null_dist <- apply(null_samples, MARGIN = 1, FUN = function(x){sum(x == "W")}, simplify = T)

simplehist(null_dist, lwd = 5, round = F)
abline(v = p_bar, lwd = 2, col = 2)

p_diff <- p_bar - mean(null_dist)
p_value <- sum(null_dist > mean(null_dist) + p_diff)/length(null_dist) + sum(null_dist < mean(null_dist) - p_diff)/length(null_dist)
p_value

## Usando pbinom
pbinom(q = mean(null_dist) + p_diff, prob = 0.5, size = 9, lower.tail = F) + pbinom(q = mean(null_dist) - p_diff, prob = 0.5, size = 9, lower.tail = T)

