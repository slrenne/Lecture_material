set.seed(241203)
library(survival)    # Load the survival analysis package.
library(survminer)   # Load the package for creating survival plots.

# Simulate a dataset of 10^4 patients to illustrate prognostic vs predictive biomarkers.
N <- 1e4  # Number of patients.

# Generate a binary biomarker variable with probabilities 0.2 for 1 and 0.8 for 5.
biomarker <- sample(x = c(1, 5), size = N, replace = TRUE, prob = c(0.2, 0.8))

# Define the parameters for a survival model with a prognostic biomarker.
alpha <- -0.1  # Baseline log hazard rate.
TX <- sample(x = c(0, 1), size = N, replace = TRUE)  # Binary treatment indicator.
beta <- -0.2 * biomarker + 1.3 * TX  # Linear predictor based on biomarker and treatment.

# Simulate survival times using an exponential distribution.
mu <- exp(alpha + beta)  # Mean survival time.
lambda <- 1 / mu         # Hazard rate (inverse of mean survival).

# simulate the time to survival
time_to_survival <- rexp(n = N, rate = lambda)  # Simulated TRUE survival times.
# Randomly assign event indicators (0 = censored, 1 = event).
event <- sample(x = c(0, 1), size = N, replace = TRUE)
# create a vector for right censoring
censoring <- runif(n = N, min = 0, max = time_to_survival)
# Assign right censoring to censored cases
time_to_survival <- ifelse(event == 1, time_to_survival, censoring)
# Combine variables into a dataset.
data <- data.frame(biomarker, time_to_survival, event, TX)

# Randomly sample 500 patients for plotting.
i <- sample(1:N, 500)
data <- data[i, ]

# Fit a survival model to evaluate the interaction between biomarker and treatment.
fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker + TX, data = data)

# Generate and save the survival plot for prognostic biomarkers with treatment groups.
ggsurvplot(fit, data = data[i,], xlim = c(0, 4), conf.int = TRUE, 
           legend.labs = c('BM1', 'BM1 Tx', 'BM2 no Tx', 'BM2 Tx'))
ggsave('prognostic_TX.png', width = 7, height = 7, units = 'in', dpi = 300)

# Subset data to patients without treatment (TX = 0).
i <- data$TX == 0
data <- data[i, ]

# Refit the survival model to assess prognostic value without treatment.
fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker + TX, data = data)

# Generate and save the survival plot for prognostic biomarkers without treatment.
ggsurvplot(fit, data = data[i,], xlim = c(0, 4), conf.int = TRUE, 
           legend.labs = c('BM1', 'BM2'))
ggsave('prognostic.png', width = 7, height = 7, units = 'in', dpi = 300)
##############################################################################
##############################################################################

# Define the parameters for a predictive biomarker survival model.
alpha <- -0.1  # Baseline log hazard rate.
TX <- sample(x = c(0, 1), size = N, replace = TRUE)  # Binary treatment indicator.
BM <- biomarker == 1  # Indicator for biomarker = 1.

# Adjust survival times to include interaction between treatment and biomarker.
beta <- 0.2 + 1.3 * TX * BM
mu <- exp(alpha + beta)  # Mean survival time.
lambda <- 1 / mu         # Hazard rate.

# simulate the time to survival
time_to_survival <- rexp(n = N, rate = lambda)  # Simulated TRUE survival times.
# Randomly assign event indicators (0 = censored, 1 = event).
event <- sample(x = c(0, 1), size = N, replace = TRUE)
# create a vector for right censoring
censoring <- runif(n = N, min = 0, max = time_to_survival)
# Assign right censoring to censored cases
time_to_survival <- ifelse(event == 1, time_to_survival, censoring)
# Combine variables into a dataset.
data <- data.frame(biomarker, time_to_survival, event, TX)
# Create a new dataset and sample 500 patients for plotting.
data <- data.frame(biomarker, time_to_survival, event, TX)
i <- sample(1:N, 500)
data <- data[i, ]

# Fit a survival model for predictive biomarkers with treatment interaction.
fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker + TX, data = data)

# Generate and save the survival plot for predictive biomarkers with treatment.
ggsurvplot(fit, data = data, xlim = c(0, 2.7), conf.int = TRUE, 
           legend.labs = c('BM1 no Tx', 'BM1 Tx', 'BM2 no Tx', 'BM2 Tx'))
ggsave('predictive_TX.png', width = 7, height = 7, units = 'in', dpi = 300)

# Subset data to patients without treatment (TX = 0).
i <- data$TX == 0
data <- data[i, ]

# Refit the survival model to evaluate predictive biomarkers without treatment.
fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker + TX, data = data)

# Generate and save the survival plot for predictive biomarkers without treatment.
ggsurvplot(fit, data = data[i,], xlim = c(0, 2.7), conf.int = TRUE, 
           legend.labs = c('BM1', 'BM2'))
ggsave('predictive.png', width = 7, height = 7, units = 'in', dpi = 300)

# Define a combined survival model with both prognostic and predictive components.
alpha <- -0.1  # Baseline log hazard rate.
TX <- sample(x = c(0, 1), size = N, replace = TRUE)  # Binary treatment indicator.
BM <- biomarker == 1  # Indicator for biomarker = 1.

# Include both prognostic and predictive effects in the linear predictor.
beta <- 0.2 * biomarker + 1.3 * TX * BM
mu <- exp(alpha + beta)  # Mean survival time.
lambda <- 1 / mu         # Hazard rate.
time_to_survival <- rexp(n = N, rate = lambda)  # Simulated survival times.
event <- sample(x = c(0, 1), size = N, replace = TRUE)  # Event indicators.

# Create a new dataset and sample 500 patients for plotting.
data <- data.frame(biomarker, time_to_survival, event, TX)
i <- sample(1:N, 500)
data <- data[i, ]

# Fit a survival model to assess combined prognostic and predictive effects.
fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker + TX, data = data)

# Generate and save the survival plot for combined effects with treatment.
ggsurvplot(fit, data = data, xlim = c(0, 2.7), conf.int = TRUE, 
           legend.labs = c('BM1 no Tx', 'BM1 Tx', 'BM2 no Tx', 'BM2 Tx'))
ggsave('prog_pre_TX.png', width = 7, height = 7, units = 'in', dpi = 300)

# Subset data to patients without treatment (TX = 0).
i <- data$TX == 0
data <- data[i, ]

# Refit the survival model to evaluate combined effects without treatment.
fit <- surv_fit(Surv(time = time_to_survival, event = event) ~ biomarker + TX, data = data)

# Generate and save the survival plot for combined effects without treatment.
ggsurvplot(fit, data = data[i,], xlim = c(0, 2.7), conf.int = TRUE, 
           legend.labs = c('BM1', 'BM2'))
ggsave('prog_pre.png', width = 7, height = 7, units = 'in', dpi = 300)
