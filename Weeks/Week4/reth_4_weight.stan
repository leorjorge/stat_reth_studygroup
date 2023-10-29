
data {
  int<lower=0> N;
  vector[N] W;
}

parameters {
  real mu;
  real<lower=0, upper = 50> sigma;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  W ~ normal(mu, sigma);
  mu ~ normal(50, 20);
}

