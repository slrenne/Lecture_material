library(survival)
library(survminer)

# create the plots to explain difference between prognostic and predictive.
# let's simulate 10^4 pts
N <- 1e4
biomarker <- sample( x = c(1,5), 
                                size = N,
                                replace = TRUE, 
                                prob = c(0.2,0.8))

# generative survival model of a predictive biomarker
alpha <- - 0.1
TX <- sample( x = c(0,1), 
              size = N,
              replace = TRUE)
beta <- - 0.2 * biomarker + 1.3 * TX 
mu <- exp(alpha + beta)
lambda <- 1/mu
time_to_survival <- rexp(n=N, rate = lambda)
event <- sample( x = c(0,1), 
                 size = N,
                 replace = TRUE)
data <- data.frame(biomarker,
                   time_to_survival,
                   event, TX)
i <- sample(1:N,500)
data <- data[i,]

fit <- surv_fit(Surv(
  time = time_to_survival,
  event = ) ~ biomarker + TX, data = data)

ggsurvplot(fit, 
           data = data[i,], 
           xlim = c(0,4), 
           conf.int = TRUE, 
           legend.labs = c('BM1', 'BM1 Tx','BM2 no Tx',
                           'BM2 Tx' ))

ggsave('prognostic_TX.png', 
       width = 7,
       height = 7,
       units = 'in',
       dpi = 300)


i <- data$TX == 0

data <- data[i,]
fit <- surv_fit(Surv(
  time = time_to_survival,
  event = ) ~ biomarker + TX, data = data)


ggsurvplot(fit, 
           data = data[i,], 
           xlim = c(0,4), 
           conf.int = TRUE, 
           legend.labs = c('BM1', 'BM2'))

ggsave('prognostic.png', 
       width = 7,
       height = 7,
       units = 'in',
       dpi = 300)

# generative survival model predictive 
alpha <- - 0.1
TX <- sample( x = c(0,1), 
              size = N,
              replace = TRUE)
BM <- biomarker==1


beta <- 0.2 + 1.3 * TX * BM
mu <- exp(alpha + beta)
lambda <- 1/mu
time_to_survival <- rexp(n=N, rate = lambda)
event <- sample( x = c(0,1), 
                 size = N,
                 replace = TRUE)
data <- data.frame(biomarker,
                   time_to_survival,
                   event, TX)
i <- sample(1:N,500)

data <- data[i,]
fit <- surv_fit(Surv(
  time = time_to_survival,
  event = ) ~ biomarker+TX, data = data)

ggsurvplot(fit, 
           data = data, 
           xlim = c(0,2.7), 
           conf.int = TRUE, 
           legend.labs = c('BM1 no Tx', 'BM1 Tx','BM2 no Tx',
                            'BM2 Tx' ))

ggsave('predictive_TX.png', 
       width = 7,
       height = 7,
       units = 'in',
       dpi = 300)

i <- data$TX == 0

data <- data[i,]
fit <- surv_fit(Surv(
  time = time_to_survival,
  event = ) ~ biomarker + TX, data = data)


ggsurvplot(fit, 
           data = data[i,], 
           xlim = c(0,2.7), 
           conf.int = TRUE, 
           legend.labs = c('BM1', 'BM2'))

ggsave('predictive.png', 
       width = 7,
       height = 7,
       units = 'in',
       dpi = 300)


# generative survival model prognostic and predictive 
alpha <- - 0.1
TX <- sample( x = c(0,1), 
              size = N,
              replace = TRUE)
BM <- biomarker==1
beta <- 0.2 * biomarker + 1.3 * TX * BM

mu <- exp(alpha + beta)
lambda <- 1/mu
time_to_survival <- rexp(n=N, rate = lambda)
event <- sample( x = c(0,1), 
                 size = N,
                 replace = TRUE)
data <- data.frame(biomarker,
                   time_to_survival,
                   event, TX)
i <- sample(1:N,500)

data <- data[i,]
fit <- surv_fit(Surv(
  time = time_to_survival,
  event = ) ~ biomarker+TX, data = data)

ggsurvplot(fit, 
           data = data, 
           xlim = c(0,2.7), 
           conf.int = TRUE, 
           legend.labs = c('BM1 no Tx', 'BM1 Tx','BM2 no Tx',
                            'BM2 Tx' ))

ggsave('prog_pre_TX.png', 
       width = 7,
       height = 7,
       units = 'in',
       dpi = 300)

i <- data$TX == 0

data <- data[i,]
fit <- surv_fit(Surv(
  time = time_to_survival,
  event = ) ~ biomarker + TX, data = data)


ggsurvplot(fit, 
           data = data[i,], 
           xlim = c(0,2.7), 
           conf.int = TRUE, 
           legend.labs = c('BM1', 'BM2'))

ggsave('prog_pre.png', 
       width = 7,
       height = 7,
       units = 'in',
       dpi = 300)


