
data {
  int<lower=0> N;
  vector[N] H;
  vector[N] W;
}

parameters {
  real alfa;
  real beta;
  real<lower=0, upper = 50> sigma;
}

model {
  vector[N] mu;
  mu = alfa + beta*(H);
  W ~ normal(mu, sigma);
  alfa ~ normal(0, 10);
  beta ~ uniform(0, 1);
  sigma ~ exponential(1);
}
