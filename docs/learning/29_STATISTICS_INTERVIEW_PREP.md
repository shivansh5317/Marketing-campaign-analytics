# 29 — Statistics Interview Prep

🟡 GOOD TO KNOW

Project-grounded stats already covered in [18_STATISTICS_FROM_ZERO.md](18_STATISTICS_FROM_ZERO.md). This file adds **general fresher-DA statistics knowledge**, including concepts NOT used in this project but commonly asked — each clearly labeled.

## Mean / Median / Mode

**Q: "Ek dataset mein ek extreme outlier hai — mean ya median, konsa report karoge?"**
> Median — it's resistant to outliers. Mean would be pulled toward the extreme value. (Real project example: `total_spend` mean 607 vs. median 397 due to high spenders.)

## Variance / Standard Deviation

**Q: "Variance aur Standard Deviation mein farak?"**
> Variance = average squared deviation from the mean (hard to interpret directly, since units are squared). Std Dev = square root of variance (same units as the original data, easier to interpret).

## Percentile / Quartile

**Q: "90th percentile ka matlab?"**
> The value below which 90% of the data falls. (Project example: RFM quartiles — Q1/Q2/Q3 cutoffs used directly to score Recency/Frequency/Monetary.)

## Distributions

**Q: "Normal distribution kya hai?"**
> A symmetric, bell-shaped distribution where most values cluster near the mean, and data is equally likely to be above or below it. (Our `income` is roughly this shape; `total_spend` is not — it's right-skewed.)

**Q: "Skewed distribution kya hai?"**
> Asymmetric — a long tail on one side. Right-skew: tail on the high side, mean > median (our `total_spend`). Left-skew: tail on the low side, mean < median.

## Outliers

**Q: "Outlier detect karne ka ek formal statistical method batao."**
> IQR method: a value is often flagged as an outlier if it's below `Q1 - 1.5×IQR` or above `Q3 + 1.5×IQR`. *(Not formally applied in this project — we used domain-logic checks instead, like implausible age thresholds — but good to know as a standard technique.)*

## Correlation

**Q: "Correlation ka range kya hota hai, aur kya matlab hai extremes ka?"**
> -1 to +1. +1 = perfect positive linear relationship, -1 = perfect negative, 0 = no linear relationship. Always remember: correlation ≠ causation.

## 📌 Probability Basics *(general knowledge — not used in this project)*

- **Probability:** A number between 0 and 1 representing how likely an event is.
- **Example:** If 604 of 2,212 customers accepted at least one campaign, the (empirical) probability a random customer is a "responder" ≈ 604/2212 ≈ 0.273.
- **Why not formally used in this project:** We're describing our full, known population — we don't need probability to estimate an unknown value, we just compute it directly.

## 📌 Hypothesis Testing Basics *(general knowledge — not used in this project)*

- **Null Hypothesis (H₀):** The "no effect/no difference" default assumption.
- **Alternative Hypothesis (H₁):** What you're trying to find evidence for.
- **p-value:** The probability of seeing a result at least this extreme, *if* the null hypothesis were actually true. A small p-value (commonly < 0.05) is taken as evidence against H₀.
- **Example (generic, not from our project):** "Does a new website design increase conversion rate?" → H₀: no difference in conversion rate; collect data from both designs; compute a p-value; if small, reject H₀.
- **Why not used in this project:** This dataset has no A/B-test structure (no "two versions" being compared on the same population) and we have the full customer population already, not a sample needing this kind of inference.

## 📌 Confidence Intervals *(general knowledge — not used in this project)*

- **What it is:** A range that likely contains the true population value, with a stated confidence level (e.g., "95% confident the true average is between X and Y").
- **Why not used here:** Confidence intervals matter when estimating an *unknown population parameter from a sample*. We have the actual population, not a sample, so there's no "unknown true value" left to estimate with an interval.

## INTERVIEW

**Q: "Aapke project mein hypothesis testing kyun nahi hai?"**
> "Humare paas poori customer population hai, sample nahi — hypothesis testing/p-values sample-se-population inference ke liye hain. Mujhe concept pata hai (general DA knowledge ke roop mein), lekin is specific project mein genuinely zaroorat nahi padi."

**Q: "P-value 0.03 ka matlab kya hota hai, simple terms mein?"**
> "Agar null hypothesis sach hoti (yaani asal mein koi real difference/effect nahi hota), toh itna extreme result dekhne ka chance sirf 3% hota. Itna chhota chance hone ki wajah se, hum null hypothesis ko reject kar dete hain — evidence maante hain ki ek real effect hai."

## Common Mistakes

- p-value ko "probability that the null hypothesis is true" bol dena — ye galat hai (p-value is about the data given H₀ is true, not about H₀'s truth itself).
- Correlation ko causation bol dena.
- Population ke paas hone ke bawajood hypothesis testing lagane ki koshish karna (unnecessary).

## What I Should Remember

1. Mean/median/mode/variance/std dev/percentile/correlation ARE used in this project — fluent, real-numbers-backed.
2. Probability/hypothesis-testing/p-values/confidence-intervals are general interview knowledge, clearly NOT used here — always say so if asked.
3. Know *why* they weren't needed (full population, no experiment), not just *that* they weren't used.

---
*Next: [30_MARKETING_ANALYTICS_INTERVIEW.md](30_MARKETING_ANALYTICS_INTERVIEW.md)*
