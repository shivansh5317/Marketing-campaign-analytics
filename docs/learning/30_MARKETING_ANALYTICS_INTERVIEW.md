# 30 — Marketing Analytics Interview

🔴 MUST KNOW

Format: **Question → Beginner Hinglish Answer → Technical Answer → Possible Follow-up → Practical Example.**

## "What is CTR?"
> **Hinglish:** "CTR batata hai kitne % logo ne ek ad dekhne ke baad usse click kiya." **Technical:** `Clicks/Impressions × 100`. **Follow-up:** "Aapke project mein CTR hai?" → "Nahi, ad-impression data nahi hai, maine ye openly document kiya hai." **Example:** 10,000 impressions, 500 clicks → CTR = 5%.

## "What is Conversion Rate?"
> **Hinglish:** "Total targeted logo mein se kitne % ne desired action complete ki — hamare project mein, campaign accept ki." **Technical:** `Conversions/Total Targeted × 100`. **Follow-up:** "Denominator galat ho sakta hai kaise?" → Agar sabko target nahi kiya gaya but humne poori population ko denominator maan liya. **Example:** Cmp6 = 333/2212 = 15.05%.

## "What is CAC?"
> **Hinglish:** "Ek naya responding customer 'lane' mein average kitna kharch hua." **Technical:** `Total Cost/Customers Acquired`. **Follow-up:** "High CAC ka matlab?" → Wrong targeting ya weak offer. **Example:** Cmp2 CAC = 221.20 (most expensive, worst campaign).

## "What is ROI?"
> **Hinglish:** "Invest kiye gaye har 1 unit pe kitna % return (ya loss) mila." **Technical:** `(Revenue-Cost)/Cost × 100`. **Follow-up:** "Negative ROI ka matlab marketing band karo?" → Nahi, better targeting chahiye. **Example:** Cmp6 ROI = -44.8% (best of a bad set).

## "What is ROAS?"
> **Hinglish:** "Har 1 rupaye spend pe kitna revenue wapas aaya, cost subtract kiye bina." **Technical:** `Revenue/Cost` (a ratio, like "2x"). **Follow-up:** "ROI aur ROAS mein farak?" → ROI profit % batata hai (cost subtract karke), ROAS sirf revenue-to-cost ratio hai — ROAS "achha" dikh sakta hai jabki actual loss ho.

## "Revenue vs. Profit?"
> **Hinglish:** "Revenue = total paisa aaya. Profit = Revenue minus Cost." **Technical:** Profit can be negative even with positive Revenue, if Cost exceeds it. **Example:** Cmp6 Revenue = 3,663, Cost = 6,636, Profit = -2,973 (negative despite positive revenue).

## "Why can Conversion Rate be better than Conversion Count?"
> **Hinglish:** "Count audience-size se bias ho sakta hai — zyada log target kiye toh zyada conversions automatically milenge, matlab ye nahi ki campaign better thi." **Example:** Campaign A: 2000 targeted, 100 conversions (5%). Campaign B: 200 targeted, 40 conversions (20%) — B is actually more effective despite a lower raw count.

## "What is a Marketing Funnel?"
> **Hinglish:** "Customer journey ko sequential stages mein dekhna, har stage pe drop-off track karna." **Project Example:** Total(2212)→Purchase(2206)→Deal-use(2168)→Campaign-accept(604).

## "What is Funnel Drop-off?"
> **Hinglish:** "Ek stage se agle stage tak kitne % log nahi pahunche." **Project Example:** Deal-use→Campaign-accept drop = 72.1%, the biggest in our funnel.

## "How would you compare two campaigns?"
> **Technical:** Primary = acceptance rate (not raw count); secondary = ROI/CAC if cost data exists; tertiary = segment-level breakdown (does one campaign work better for a specific segment?). **Example:** Cmp6 vs. Cmp2 — 15.05% vs. 1.36% rate, -44.8% vs. -95.0% ROI, 19.93 vs. 221.20 CAC — all 3 metrics agree Cmp6 is stronger.

## "What makes a campaign efficient?"
> **Hinglish:** "Sirf zyada log convert karna kaafi nahi — kitna kharch karke convert kiya, ye bhi matter karta hai." **Technical:** Low CAC + positive/less-negative ROI + reasonable acceptance rate, together.

## "Why can a high-spend campaign still be poor-performing?"
> **Hinglish:** "Agar bahut zyada logo ko contact kiya (high cost) lekin bahut kam ne accept kiya, toh total spend high hone ke bawajood ROI bahut negative ho sakta hai." **Project Example:** Every campaign here has meaningful spend (cost = targeted × 3) but all show negative ROI — spend alone doesn't guarantee good returns.

## "How would you investigate a sudden drop in conversions?"
> **Technical approach:** (1) Check if it's a data issue first (tracking broken, wrong join, date filter bug). (2) Segment the drop — is it uniform or concentrated in one channel/segment/campaign? (3) Check timing — did anything change (offer, audience, season)? (4) Compare against a historical baseline. **Hinglish:** "Pehle data-quality check karo, phir drop ko segment/channel-wise break down karo, tab hi root-cause hypothesis banao."

## "How would you identify which channel needs investigation?"
> **Technical:** Look beyond simple volume share — check penetration (% of customers who've *never* used it), not just total volume. **Project Example:** Catalog's 21.3% volume share alone looks "okay," but its 26% never-used rate reveals a distinct reach problem volume share hides.

## "How would you segment customers?"
> **Technical:** Depends on available data — demographic (age/income/family), behavioral (RFM), or engagement-based. **Project Example:** RFM (Recency/Frequency/Monetary) quartile-based, 4 segments, fully rule-based (no ML) — see [17_CUSTOMER_SEGMENTATION.md](17_CUSTOMER_SEGMENTATION.md).

## "What additional data would you ask the marketing team for?"
> **Technical/Hinglish:** "Real per-campaign cost/revenue (instead of the dataset's assumption constants), campaign launch/end dates (for time-series trend analysis), ad-channel data if CTR/Impressions matter, and ideally A/B test results to validate any causal hypothesis."

## Common Mistakes

- CTR aur Conversion Rate ko interchangeably use karna.
- ROAS ko "profitability" ka proof samajh lena (cost subtract nahi hota isme).
- Channel ko sirf volume-share se judge karna, penetration/never-used % ignore karna.
- Segmentation ko seedha ML samajh lena — rule-based (RFM) bhi equally valid, often more defensible.

## What I Should Remember

1. Every marketing-metric question here has both a plain-Hinglish answer AND a formula-level technical answer ready.
2. "Investigate a drop" and "identify which channel" questions test process-thinking, not just formulas — always mention segmentation/breakdown as the first analytical move.
3. I always know what additional data would strengthen any given analysis — this signals analytical maturity.

---
*Next: [31_PROJECT_DEFENSE.md](31_PROJECT_DEFENSE.md)*
