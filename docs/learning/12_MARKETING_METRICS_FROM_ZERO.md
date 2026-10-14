# 12 — Marketing Metrics From Zero

🔴 MUST KNOW — ye sabse important chapters mein se ek hai.

Pehle "metric" ka concept, phir har metric: **Definition → Formula → Example → Business Meaning → Why Companies Care → In My Project → Interpretation → Common Confusion → Interview Q.**

## 0. What Is a Metric?

**Kya hai:** Ek metric ek **number hai jo kisi specific business performance ko quantify karta hai.** Jab ek metric itna important ban jaaye ki business use regularly track kare, use **KPI** (Key Performance Indicator) kehte hain.

---

## 1. Impressions, Clicks, CTR, CPC *(background only — NOT in my project)*

> 📌 **Useful background metric — not used in my project.** Humare dataset mein koi ad-platform data (impressions/clicks) nahi hai, isliye in metrics ko humne kabhi calculate/claim nahi kiya.

| Metric | Formula | Meaning |
|---|---|---|
| **Impressions** | Raw count | Kitni baar ek ad screen pe dikhaya gaya |
| **Clicks** | Raw count | Kitni baar log ne us ad pe click kiya |
| **CTR (Click-Through Rate)** | `Clicks / Impressions × 100` | Dikhaye gaye ads mein se kitne % ne click kiya |
| **CPC (Cost Per Click)** | `Total Ad Spend / Total Clicks` | Har click ka average cost |

**Example:** 10,000 impressions, 500 clicks → CTR = 500/10,000 × 100 = **5%**.

**Interview Q:** *"Aapke project mein CTR kya hai?"* → "Humare dataset mein ad-impression/click data genuinely exist nahi karta — ye ek direct-marketing-campaign dataset hai (email/offer accept-reject), ad-platform dataset nahi. Isliye maine CTR calculate nahi kiya, aur openly document kiya hai ki ye metric is project mein unavailable hai."

---

## 2. Conversion Rate 🔴 (used in my project, as "Campaign Acceptance Rate")

- **Definition:** Total targeted logo mein se kitne % ne desired action complete ki.
- **Formula:** `Conversion Rate = (Conversions / Total Targeted) × 100`
- **Example:** 1000 users aaye, 50 ne purchase kiya → Conversion Rate = 50/1000 × 100 = **5%**.
- **Business Meaning:** Batata hai ek offer/campaign/page kitni effectively log ko action lene pe convince kar rahi hai.
- **Why Companies Care:** Directly business outcome (sales/signups) se linked hai — raw traffic/reach se zyada meaningful.
- **In My Project:** "Campaign Acceptance Rate" exactly ye hi hai — `SUM(accepted) / COUNT(*) × 100` per campaign. Real: Cmp6 = 15.05% (best), Cmp2 = 1.36% (worst).
- **Interpretation:** Cmp6 customers ko sabse zyada convince kar paayi — timing, offer quality, ya recency-targeting (customers jo recently active the) ismein role nibha sakte hain.
- **Common Confusion:** Conversion Rate aur Conversion Count ko confuse karna — "Campaign X ne 200 conversions diye" automatically better nahi hai agar usne 10,000 logo ko target kiya aur Campaign Y ne sirf 500 logo ko target karke 100 conversions diye (Y ka rate 20%, X ka sirf 2%).
- **Interview Q:** *"Conversion rate calculate karte waqt sabse important edge case kya hai?"* → Denominator sahi hona chahiye — sirf **targeted** audience, poora customer-base nahi (jab tak targeting genuinely sabko na ho, jaisa hamare dataset mein assume kiya gaya hai aur explicitly documented hai).

---

## 3. CTR vs. Conversion Rate — Comparison

| | CTR | Conversion Rate |
|---|---|---|
| Measures | Interest/attention (did they click) | Actual outcome (did they buy/accept) |
| Denominator | Impressions | Total targeted/visited |
| In my project | ❌ Not available | ✅ Campaign Acceptance Rate |
| Funnel position | Earlier stage | Later stage |

**Hinglish:** "CTR batata hai 'kitno ne dekh ke interest dikhaya,' Conversion Rate batata hai 'kitno ne actually action complete ki.' Ek campaign high CTR but low conversion rate ho sakti hai — matlab log click toh karte hain, lekin aakhir mein convert nahi hote (landing page/offer mismatch ka sign)."

---

## 4. Campaign Cost, Revenue, Profit 🔴 (used, with an explicit assumption)

- **Formulas (as used in this project):**
  - `Cost = Customers Targeted × Z_CostContact (3)`
  - `Revenue = Customers Accepted × Z_Revenue (11)`
  - `Profit = Revenue − Cost`
- **⚠️ Label:** `Z_CostContact`/`Z_Revenue` dataset's own assumption constants — not observed real financials.
- **Example:** 100 targeted (cost=300), 7 accepted (revenue=77) → Profit = 77−300 = **−223** (loss).
- **In My Project:** Every one of the 6 campaigns shows a loss under this assumption — even the best (Cmp6: profit = −2,973).
- **Interpretation:** NOT "stop marketing" — more likely, "stop targeting everyone equally; target only high-probability segments" (see [22_BUSINESS_RECOMMENDATIONS.md](22_BUSINESS_RECOMMENDATIONS.md)).

## 5. Revenue vs. Profit — Comparison

| | Revenue | Profit |
|---|---|---|
| Meaning | Total money coming in | Revenue minus cost |
| Can be positive while the other is negative? | N/A | Yes — high revenue with even-higher cost = negative profit |
| In my project | `total_spend` (product revenue) is SEPARATE from campaign `Revenue` (Z_Revenue × accepts) — **don't confuse the two!** | Campaign Profit always negative here under the assumption constants |

**Hinglish:** "Revenue sirf 'kitna paisa aaya' batata hai, Profit batata hai 'kharch nikaalne ke baad kitna bacha.' Hamare project mein DO alag 'revenue' concepts hain — product revenue (`total_spend`, customer ka real spend) aur campaign-assumption revenue (`Z_Revenue × accepts`) — in dono ko kabhi mix mat karna, interview mein ye confusion bahut common hai."

---

## 6. ROI (Return on Investment) 🔴

- **Formula:** `ROI % = (Profit / Cost) × 100`
- **Example:** Profit = −223, Cost = 300 → ROI = −223/300×100 = **−74.3%**
- **Business Meaning:** Normalized efficiency metric — lets you compare campaigns of different scale fairly.
- **In My Project:** Cmp6 = −44.8% (best/least-bad), Cmp2 = −95.0% (worst).
- **Common Confusion:** Comparing absolute Profit across campaigns of different size is misleading — ROI % normalizes for scale.
- **Interview Q:** *"Dono campaigns negative ROI hain — toh comparison ka fayda?"* → "ROI % relative efficiency batata hai — Cmp6 'kam bura' hai relative to its own cost, chahe scale alag ho. Ye ranking ke liye useful hai chahe sab absolute terms mein loss ho."

## 7. ROAS (Return on Ad Spend) *(background — not calculated as a separate metric here)*

> 📌 **Useful background metric — closely related to ROI, not separately calculated in my project** (our "ROI" formula above effectively plays this role given our data).

- **Formula:** `ROAS = Revenue / Ad Spend` (usually expressed as a ratio like "3x", not a %)
- **ROI vs. ROAS:** ROI subtracts cost first (`(Revenue-Cost)/Cost`), ROAS doesn't (`Revenue/Cost` directly) — ROI tells you profit %, ROAS tells you "for every ₹1 spent, how much revenue came back" (can look "good" at ROAS=0.8x while still being a loss, since cost isn't subtracted).

## 8. Customer Acquisition Cost (CAC) 🔴

- **Formula:** `CAC = Total Campaign Cost / Number of Customers Acquired (Accepted)`
- **Example:** Cost=300, 7 accepted → CAC = 300/7 ≈ **42.9**
- **Business Meaning:** Average cost to "win" one responding customer.
- **In My Project:** Cmp6 = 19.93 (cheapest), Cmp2 = 221.20 (most expensive).
- **Interpretation:** High CAC = either wrong targeting (contacted people unlikely to respond) or an unattractive offer.

## 9. CAC vs. Cost per Conversion — Comparison

| | CAC | Cost Per Conversion |
|---|---|---|
| Typical usage | "Acquiring a NEW customer" | Any conversion event, new or repeat |
| In my project | Same formula used (`Cost / Accepted`) — our dataset doesn't distinguish new-vs-existing customers, so we use the terms interchangeably here, with that caveat stated |

**Interview Q:** *"CAC aur Cost per Conversion same hain kya?"* → "Conceptually bahut similar hain — CAC specifically 'naya customer acquire karne' ke context mein use hota hai, Cost per Conversion zyada general hai. Humare dataset mein customer 'naya' hai ya 'existing' ye track nahi hota, isliye maine formula same use kiya hai, lekin terminology ka ye nuance interview mein mention karna chahiye."

## 10. Total Revenue & Average Spend 🔴

- **Total Revenue:** `SUM(total_spend)` = **1,343,277** monetary units (2 years, all customers).
- **Avg Spend per Customer:** `AVG(total_spend)` = 607.27 (median 397 — report both, data is right-skewed).
- **Common Confusion:** This "Revenue" is **product sales revenue**, completely separate from the campaign-assumption "Revenue" (Z_Revenue) in Section 4 — always clarify which one you mean.

## 11. Channel Share % 🔴

- **Formula:** `Channel Share = SUM(purchases for channel) / SUM(purchases all channels) × 100`
- **In My Project:** Store 46.2% > Web 32.5% > Catalog 21.3%.
- **Common Confusion:** "Smallest share" ≠ "should be shut down" — 21% is still a meaningful chunk; always check if it serves a specific valuable segment before recommending cuts.

## 12. Engagement Proxy (Visit-to-Purchase) ⚠️

- **Formula:** `num_web_visits_month / web purchases` (aggregate ratio)
- **⚠️ Caveat:** Different time windows (1-month visits vs. 2-year purchases) — **not** a true same-window conversion rate, explicitly labeled a "directional proxy" only.

## 13. Multi-Campaign Responsiveness (Engagement Depth) 🔴

- **Formula:** `num_campaigns_accepted` (0-5) per customer.
- **In My Project:** 72.7% accepted 0 campaigns ever; only 10 customers accepted 5 (max found, nobody accepted all 6).

## 14. Complaint Rate 🟡

- **Formula:** `AVG(complain) × 100` = **0.9%** (20 of 2,212).
- **Common Confusion:** Low complaint rate ≠ high satisfaction — could be "silent churn" (unhappy customers who just leave without complaining), a genuine limitation we state explicitly.

## 15. Summary Table — All Metrics At a Glance

| Metric | Formula | Real Value (best/worst or headline) |
|---|---|---|
| Campaign Acceptance Rate | accepted/targeted × 100 | 15.05% (Cmp6) / 1.36% (Cmp2) |
| Campaign ROI % | (Rev−Cost)/Cost × 100 | −44.8% (Cmp6) / −95.0% (Cmp2) |
| CAC | Cost/Accepted | 19.93 (Cmp6) / 221.20 (Cmp2) |
| Total Revenue | SUM(total_spend) | 1,343,277 units |
| Avg Spend/Customer | AVG(total_spend) | 607.27 (median 397) |
| Channel Share | SUM(channel)/SUM(all) | Store 46.2% / Web 32.5% / Catalog 21.3% |
| Never-Responder % | count(accepted=0)/total | 72.7% |
| Complaint Rate | AVG(complain)×100 | 0.9% |

## 16. INTERVIEW

**Q: "ROI aur ROAS mein farak batao."**
> "ROI = `(Revenue − Cost) / Cost` — profit % batata hai. ROAS = `Revenue / Cost` — directly revenue-to-spend ratio, cost subtract nahi hota. Isliye ROAS 'achha' dikh sakta hai (jaise 0.8x) jabki actually loss ho raha ho — ROI zyada honestly profitability batata hai."

**Q: "Revenue aur Profit mein farak, apne project ke numbers ke saath."**
> "Revenue = total paisa aaya, Profit = Revenue minus Cost. Hamari har campaign ka Revenue positive hai (jaise Cmp6 = 3,663), lekin Profit negative hai (-2,973) kyunki Cost (6,636) Revenue se zyada hai — dono ek saath dekhna zaroori hai, sirf Revenue dekh ke 'achha perform kiya' bolna galat hoga."

**Q: "CAC high hone ka matlab?"**
> "Ya toh targeting galat thi (wrong audience contact kiya), ya offer attractive nahi tha. Dono cases mein campaign-redesign ki zaroorat hai."

## 17. Common Mistakes

- CTR aur Conversion Rate ko same bol dena — alag funnel stages measure karte hain.
- Revenue dekh kar "profitable" keh dena bina Cost check kiye.
- Absolute Profit compare karna bina scale (Cost) normalize kiye — ROI % use karo.
- Channel ka chhota share dekh kar "band kar do" bol dena bina segment-level investigation ke.

## 18. What I Should Remember

1. Humare project mein DO "Revenue" concepts hain — product revenue (`total_spend`) vs. campaign-assumption revenue (`Z_Revenue × accepts`) — hamesha specify karo kaunsa.
2. CTR/Impressions/CPC genuinely unavailable hain — kabhi fake number mat do.
3. ROI negative hone ka matlab "marketing band karo" nahi, "targeting better karo" ho sakta hai.
4. Har metric ek formula + ek real number + ek caveat (agar applicable ho) ke saath yaad rakho.

---
*Next: [13_FUNNEL_ANALYSIS.md](13_FUNNEL_ANALYSIS.md)*
