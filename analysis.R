# Survival Analysis of Lung Cancer Patients in R
# Data: survival::lung — North Central Cancer Treatment Group, 228 patients
#   with advanced lung cancer. Built-in public dataset; no files needed.
# Run: install.packages(c("survival", "survminer", "dplyr", "ggplot2"))
#      then source("analysis.R")

library(survival)
library(survminer)
library(dplyr)

# 1. Load and prepare -------------------------------------------------------
# 'lung' is a built-in dataset in the survival package (lazy-loaded on attach)
lung <- survival::lung

lung_clean <- lung %>%
  mutate(
    # status: 1 = censored, 2 = dead -> event indicator 0/1
    event = ifelse(status == 2, 1, 0),
    sex_label = factor(sex, levels = c(1, 2),
                       labels = c("Male", "Female")),
    # ECOG performance status: 0 = fully active ... 3 = capable of limited self-care
    ph_ecog = factor(ph.ecog),
    # Age groups for descriptive tables
    age_group = cut(age, breaks = c(0, 55, 65, 100),
                    labels = c("<=55", "56-65", ">65"))
  )

# Descriptive summary
cat("Sample size:", nrow(lung_clean), "\n")
cat("Events (deaths):", sum(lung_clean$event), "\n")
print(table(lung_clean$sex_label, lung_clean$event))
print(summary(lung_clean$time))

# 2. Kaplan-Meier curves ----------------------------------------------------
fit_sex <- survfit(Surv(time, event) ~ sex_label, data = lung_clean)
fit_ecog <- survfit(Surv(time, event) ~ ph_ecog, data = lung_clean)

# Median survival by sex and by ECOG performance status
print(fit_sex)
print(fit_ecog)

# Log-rank tests
print(survdiff(Surv(time, event) ~ sex_label, data = lung_clean))
print(survdiff(Surv(time, event) ~ ph_ecog, data = lung_clean))

# Plots — saved as PNG files in the repo root when the script runs
km_sex_plot <- ggsurvplot(fit_sex, data = lung_clean, pval = TRUE,
           risk.table = TRUE, xlab = "Days", ylab = "Survival probability",
           legend.title = "Sex", legend.labs = c("Male", "Female"),
           title = "Survival by sex")
km_ecog_plot <- ggsurvplot(fit_ecog, data = lung_clean, pval = TRUE,
           risk.table = TRUE, xlab = "Days", ylab = "Survival probability",
           legend.title = "ECOG performance status",
           legend.labs = c("0", "1", "2", "3"),
           title = "Survival by performance status")
print(km_sex_plot)
print(km_ecog_plot)
# Save the plots as PNG files (ggsurvplot objects are printed to a device)
png("km_by_sex.png", width = 1000, height = 750, res = 120)
print(km_sex_plot)
dev.off()
png("km_by_ecog.png", width = 1000, height = 750, res = 120)
print(km_ecog_plot)
dev.off()

# 3. Cox proportional hazards models ---------------------------------------
# Unadjusted: sex only
cox_sex <- coxph(Surv(time, event) ~ sex_label, data = lung_clean)
summary(cox_sex)

# Adjusted: age + sex + performance status
cox_adj <- coxph(Surv(time, event) ~ age + sex_label + ph_ecog,
                  data = lung_clean)
summary(cox_adj)

# Hazard ratios with 95% CIs
print(exp(coef(cox_adj)))
print(exp(confint(cox_adj)))

# 4. Proportional hazards assumption ---------------------------------------
# Schoenfeld residuals test; p > 0.05 supports the assumption
ph_test <- cox.zph(cox_adj)
print(ph_test)
# plot(ph_test)  # uncomment to visualise

# 5. Sensitivity: age as a categorical variable -----------------------------
cox_agecat <- coxph(Surv(time, event) ~ age_group + sex_label + ph_ecog,
                    data = lung_clean)
summary(cox_agecat)
