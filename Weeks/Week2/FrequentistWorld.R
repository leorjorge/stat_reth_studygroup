library(rethinking)

## A randomization-based frequentist approach (just because this is not a gaussian problem)

## function to toss a globe covered by p by water N times
sim_globe <- function(p = 0.7, N = 10){
   sample(c("W", "L"), size = N, prob = c(p, 1-p), replace = TRUE)
}

(sample <- sim_globe())
(p_bar <- sum(sample == "W")/length(sample))

## all of the frequentist statistics is based on repeated sampling. If I would go back to the field and 
## sample infinite times following my null hypothesis, what is the probability I'd get such an extreme value?

## Our null hypothesis will be that the globe is 50% covered in water 

(null_samples <- t(replicate(sim_globe(p = 0.5), n = 1e4)))

null_dist <- apply(null_samples, MARGIN = 1, FUN = function(x){sum(x == "W")/length(x)}, simplify = T)

dens(null_dist, lwd = 2)
abline(v = p_bar, lwd = 2, col = 2)


p_value <- min(sum(null_dist > p_bar)/length(null_dist), 
               sum(null_dist < p_bar)/length(null_dist))*2
p_value
