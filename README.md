# Survival Analysis of Lung Cancer Patients in R

**Dataset:** `lung` dataset from the `survival` R package (North Central Cancer Treatment Group, 228 patients with advanced lung cancer). Public, built-in dataset — no data files are included in this repo; the code loads it directly from the package.
**Tools:** R, `survival`, `survminer`, `dplyr`, `ggplot2`

## Research question
Among patients with advanced lung cancer, how do survival times differ by sex and by performance status (ECOG score), and what is the adjusted association of age, sex, and performance status with the hazard of death?

## What this project shows
- Kaplan–Meier survival curves by sex and by ECOG performance status, with log-rank tests
- Cox proportional hazards models: unadjusted and adjusted for age, sex, and performance status
- Checking the proportional hazards assumption (Schoenfeld residuals)
- Clear, reproducible tables and figures

ECOG performance status: 0 = fully active, 1 = restricted in strenuous
activity, 2 = ambulatory and capable of self-care, 3 = capable of limited
self-care. (Only 1 patient in this dataset had ECOG 3, so that curve is
based on a single observation — see `results.md`.)

## Files
- `analysis.R` — complete, runnable analysis (data loading, cleaning, KM curves, log-rank tests, Cox models, diagnostics)
- `results.md` — results from running `analysis.R` (see "How to run")
- `km_by_sex.png`, `km_by_ecog.png` — Kaplan–Meier plots produced by `analysis.R` when you run it (not stored in the repo)

## How to run
```r
install.packages(c("survival", "survminer", "dplyr", "ggplot2"))
source("analysis.R")
```
Running the script prints the descriptive summary, Kaplan–Meier medians,
log-rank tests, Cox model summaries, and the Schoenfeld test to the
console, and saves the Kaplan–Meier plots as `km_by_sex.png` and
`km_by_ecog.png` in the folder where you run it. The numbers in
`results.md` are the output of this script (R 4.3.3, `survival` package,
run 22 Nov 2026). The PNGs are not stored in this repo — re-run the
script to regenerate them.

## Notes
- This is a learning / portfolio project using a well-known teaching dataset. It is not original clinical research, and no findings are presented as new evidence.
- Survival times are in days; `status` 1 = censored, 2 = dead.
