
data {
  int<lower=0> N;
  vector[N] H;
  vector[N] W;
}

transformed data {
   real H_bar = mean(H);
}

parameters {
  real alfa;
  real beta;
  real<lower=0, upper = 50> sigma;
}

model {
  vector[N] mu;
  mu = alfa + beta*(H - H_bar);
  W ~ normal(mu, sigma);
  alfa ~ normal(50, 20);
  beta ~ uniform(0, 1);
  sigma ~ exponential(1);
}
