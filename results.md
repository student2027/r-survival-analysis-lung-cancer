# Results — Survival Analysis of Lung Cancer Patients

Dataset: `survival::lung` (North Central Cancer Treatment Group, n = 228 patients with advanced lung cancer). Run `analysis.R` to reproduce every number below.

Results below are the output of `analysis.R` (R 4.3.3, `survival` package, run 22 Nov 2026). Running the script also saves the Kaplan–Meier plots as `km_by_sex.png` and `km_by_ecog.png` in the folder where you run it.

## Sample
- Sample size: 228 patients
- Events (deaths): 165 (72.4%); 63 censored
- Survival time: days from enrolment to death or censoring (median 255.5 days, range 5–1,022)
- By sex: 138 men (112 deaths), 90 women (53 deaths)

## Kaplan–Meier

### Median survival by sex

| Group | n | Deaths | Median survival (days) | 95% CI |
|---|---|---|---|---|
| Male | 138 | 112 | 270 | 212–310 |
| Female | 90 | 53 | 426 | 348–550 |

Log-rank test for sex: chi-square = 10.3 on 1 df, p = 0.001.

### Median survival by ECOG performance status

| ECOG | n | Deaths | Median survival (days) | 95% CI |
|---|---|---|---|---|
| 0 — fully active | 63 | 37 | 394 | 348–574 |
| 1 — restricted | 113 | 82 | 306 | 268–429 |
| 2 — ambulatory | 50 | 44 | 199 | 156–288 |
| 3 — limited self-care | 1 | 1 | 118 | — (n = 1, no CI) |

Log-rank test for performance status: chi-square = 22 on 3 df, p = 0.00007.
Note: the ECOG 3 group has only 1 patient, so its median is not meaningful on its own; the adjusted model below also has a very wide confidence interval for ECOG 3.

## Cox proportional hazards

### Unadjusted model (sex only)

| Term | Hazard ratio | 95% CI | p-value |
|---|---|---|---|
| Female vs male | 0.59 | 0.42–0.82 | 0.001 |

### Adjusted model (age + sex + performance status)

n = 227 (1 observation dropped for missing ECOG), 164 events. Concordance = 0.637.

| Term | Hazard ratio | 95% CI | p-value |
|---|---|---|---|
| Age (per 1 year) | 1.01 | 0.99–1.03 | 0.25 |
| Female vs male | 0.58 | 0.42–0.81 | 0.001 |
| ECOG 1 vs 0 | 1.51 | 1.02–2.23 | 0.040 |
| ECOG 2 vs 0 | 2.47 | 1.58–3.86 | <0.001 |
| ECOG 3 vs 0 | 7.06 | 0.94–53.13 | 0.058 |

### Sensitivity model (age as a categorical variable)

Same adjustment with age grouped (≤55 reference, 56–65, >65): age 56–65 HR 0.93 (0.60–1.46, p = 0.76), age >65 HR 1.14 (0.74–1.73, p = 0.56); female HR 0.57 (0.41–0.79, p = 0.0009); ECOG 1 HR 1.47 (0.99–2.19, p = 0.058); ECOG 2 HR 2.48 (1.59–3.87, p < 0.001); ECOG 3 HR 6.81 (0.90–51.60, p = 0.063). Conclusions unchanged.

## Proportional hazards assumption

Schoenfeld residuals test (`cox.zph`) on the adjusted model — all p-values above 0.05, consistent with the proportional hazards assumption holding:

| Term | Chi-square | df | p-value |
|---|---|---|---|
| Age | 0.16 | 1 | 0.69 |
| Sex | 2.41 | 1 | 0.12 |
| Performance status | 5.65 | 3 | 0.13 |
| Global | 7.78 | 5 | 0.17 |

## Interpretation
- Women survived longer than men (median 426 vs 270 days), and the difference persisted after adjusting for age and performance status (adjusted HR 0.58).
- Performance status showed a graded association with hazard: compared with ECOG 0, the hazard was about 1.5× for ECOG 1 and about 2.5× for ECOG 2. The ECOG 3 estimate is unreliable (n = 1).
- Age was not significantly associated with hazard in this dataset, either as a continuous or a categorical variable.
- The proportional hazards assumption was not violated for any variable.

*This is a teaching dataset, not new clinical evidence.*
