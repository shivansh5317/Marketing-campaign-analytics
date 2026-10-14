# 03 — Marketing KPIs

Ye document har KPI (business metric) define karta hai jo hum is project mein use karenge — **sirf wahi metrics jo hamare cleaned data se genuinely nikal sakte hain**, koi bhi number bina calculation ke likha nahi gaya. Har KPI ke real, verified values [scripts/clean_data.py](../scripts/clean_data.py) ke output (`data/processed/*.csv`) se directly calculate kiye gaye hain.

**Format har KPI ke liye:** Name → Formula → Matlab kya hai → Kyun important hai → Project mein kaha use hoga → Chota example → Interview question.

---

## Category A — Scale Metrics

### A1. Total Customers

- **Formula:** `COUNT(DISTINCT customer_id)`
- **Matlab:** Kitne unique customers hamare database mein hain.
- **Kyun important:** Ye baseline hai — har other metric ("kitne % responded," "average spend") isi total ke against measure hota hai.
- **Project mein use:** Dashboard ka pehla KPI card; har rate/percentage calculation ka denominator.
- **Real value:** **2,212** (cleaning ke baad; raw file mein 2,240 the, 28 rows drop hui).
- **Interview Q:** *"Aapke dataset mein total kitne customers/records hain, aur cleaning ke baad kitne bache?"* → 2,240 → 2,212 (1.25% dropped, reasons documented in Phase 2).

### A2. Total Campaigns

- **Formula:** `COUNT(DISTINCT campaign_name)`
- **Matlab:** Company ne total kitne alag marketing campaigns chalaye.
- **Kyun important:** Campaign-level comparison ("which campaign is best") ka scope define karta hai.
- **Project mein use:** SQL `GROUP BY campaign_name` queries ka scope.
- **Real value:** **6** (Cmp1–Cmp5 + Cmp6/Response).
- **Interview Q:** *"Multiple campaigns ko compare karne ke liye aap data ko kaise structure karoge?"* → Long/tidy fact table (`fact_campaign_response`), ek row per customer-per-campaign, phir `GROUP BY`.

---

## Category B — Campaign Performance Metrics

### B1. Campaign Acceptance Rate (= Conversion Rate)

- **Formula:** `Acceptance Rate = (Number of customers who accepted) / (Total customers targeted) × 100`
- **Matlab:** Kitne % customers ne ek particular campaign ka offer accept kiya.
- **Kyun important:** Ye sabse direct signal hai "ye campaign kaam kar rahi thi ya nahi" — jitna zyada, utna better campaign.
- **Project mein use:** Har campaign ko rank karne ke liye core metric.
- **Chota example:** Agar 100 customers ko ek offer bheja aur 7 ne accept kiya, toh Acceptance Rate = 7/100 × 100 = **7%**.
- **Real values (calculated, cleaned data):**

| Campaign | Accepted | Acceptance Rate |
|---|---|---|
| Cmp1 | 142 | 6.42% |
| Cmp2 | 30 | **1.36% (worst)** |
| Cmp3 | 163 | 7.37% |
| Cmp4 | 164 | 7.41% |
| Cmp5 | 161 | 7.28% |
| Cmp6 (Response) | 333 | **15.05% (best)** |

- **Interview Q:** *"Conversion rate kya hota hai aur ismein kya edge cases dhyan mein rakhne chahiye?"* → Denominator sahi hona chahiye (sirf targeted customers, na ki poora database agar sirf ek subset ko target kiya gaya ho). Yahan hum assume kar rahe hain **sabhi 2,212 customers** har campaign mein target kiye gaye (dataset mein har row ke liye har campaign ka flag maujood hai) — ye ek stated assumption hai.

### B2. Campaign Cost, Revenue, Profit (uses the dataset's assumption constants)

- **Formula:**
  - `Cost = Total customers contacted × Z_CostContact (3)`
  - `Revenue = Number who accepted × Z_Revenue (11)`
  - `Profit = Revenue − Cost`
- **Matlab:** Agar har customer ko contact karne mein ek fixed cost (3 units) lagta hai, aur har accept karne wale se 11 units revenue milta hai, toh net profit/loss kya bana.
- **⚠️ Important label:** `Z_CostContact` aur `Z_Revenue` **dataset ke apne diye hue constants hain** — hamne invent nahi kiye. Inhe use karna ek **modeling assumption** hai, observed fact nahi. Hum hamesha ye explicitly bolenge jab bhi ye numbers dikhayenge.
- **Kyun important:** Sirf "kitne % accept kiya" kaafi nahi hai — agar contact karne ka cost accept-karne-wale revenue se zyada hai, toh high acceptance rate wali campaign bhi financially loss-making ho sakti hai.
- **Project mein use:** ROI aur CAC calculation ka base.
- **Chota example:** 100 customers ko contact kiya (cost = 100×3 = 300), 7 ne accept kiya (revenue = 7×11 = 77) → Profit = 77 − 300 = **−223** (loss).
- **Real values (all 6 campaigns, cleaned data, cost = 2,212 × 3 = 6,636 per campaign):**

| Campaign | Cost | Revenue | Profit |
|---|---|---|---|
| Cmp1 | 6,636 | 1,562 | −5,074 |
| Cmp2 | 6,636 | 330 | −6,306 |
| Cmp3 | 6,636 | 1,793 | −4,843 |
| Cmp4 | 6,636 | 1,804 | −4,832 |
| Cmp5 | 6,636 | 1,771 | −4,865 |
| Cmp6 (Response) | 6,636 | 3,663 | **−2,973 (least loss)** |

- **Genuinely surprising, real finding:** under this assumption, **every single campaign shows a loss** — even the best one (Cmp6). We will not hide this. It becomes an important business insight in Phase 9 (hint: contacting *everyone* may not be efficient — targeting only likely responders, i.e., segmentation, is the natural next question).
- **Interview Q:** *"Agar har campaign loss dikha rahi hai, iska matlab company ko marketing band kar deni chahiye?"* → Nahi zaroori nahi — ho sakta hai company **poore database ko target karne ke bajaye sirf high-probability segments ko target kare** toh cost kam ho aur ROI positive ho jaaye. Ye hi segmentation (Phase 5) ka business case hai.

### B3. Campaign ROI (Return on Investment)

- **Formula:** `ROI % = (Profit / Cost) × 100`
- **Matlab:** Har 1 unit invest karne pe kitna % return (ya loss) mila.
- **Kyun important:** Absolute profit/loss numbers compare karna mushkil hota jab scale different ho; ROI % ek normalized, comparable number deta hai.
- **Project mein use:** Campaign ranking, Power BI KPI card.
- **Real values:** Cmp1: −76.5% · Cmp2: **−95.0% (worst)** · Cmp3: −73.0% · Cmp4: −72.8% · Cmp5: −73.3% · Cmp6: **−44.8% (best)**.
- **Interview Q:** *"ROI aur Profit mein practically kya farak hai jab dono negative hain?"* → Profit batata hai absolute loss ka size, ROI % batata hai efficiency — Cmp6 sabse "kam bura" hai relative to its cost, chahe absolute loss dusri campaigns se bhi bada ho sakta tha agar scale zyada hoti.

### B4. Customer Acquisition Cost (CAC)

- **Formula:** `CAC = Total Campaign Cost / Number of customers who accepted`
- **Matlab:** Ek "acquire" (yaha "accept karne wale") customer ko lane mein average kitna kharch aaya.
- **Kyun important:** Business ko pata chalta hai ki har naya responder kitna "mehenga" pada — agar CAC customer ke lifetime value se zyada hai, toh campaign sustainable nahi hai.
- **Project mein use:** Campaign efficiency comparison, dashboard KPI.
- **Chota example:** Cost = 300, 7 logo ne accept kiya → CAC = 300/7 ≈ **42.9 per acquired customer**.
- **Real values:** Cmp1: 46.73 · Cmp2: **221.20 (most expensive)** · Cmp3: 40.71 · Cmp4: 40.46 · Cmp5: 41.22 · Cmp6: **19.93 (cheapest)**.
- **Interview Q:** *"CAC high hone ka kya matlab hai business ke liye?"* → Matlab ya toh targeting galat thi (wrong audience contact kiya) ya offer itna attractive nahi tha ki log accept karein — dono cases mein campaign redesign ki zaroorat hai.

---

## Category C — Revenue / Spend Metrics

### C1. Total Revenue

- **Formula:** `SUM(total_spend)` across all customers (sum of all 6 product-category spend columns)
- **Matlab:** Company ne apne poore customer base se 2 saal mein kitna total revenue kamaya (product sales se, campaigns se nahi — ye alag hai).
- **Kyun important:** Overall business size ka indicator; segment-wise revenue contribution nikalne ka base.
- **Project mein use:** Dashboard headline KPI; "which segment contributes most revenue" (Phase 5/9).
- **Real value:** **1,343,277 monetary units** (currency dataset mein specify nahi hai, isliye hum sirf "monetary units" bolenge).
- **Interview Q:** *"Ye revenue kis se aaya — campaigns se ya product sales se?"* → Product sales se (`Mnt*` columns = amount spent on products in 2 years) — ye campaign-driven "Revenue" (`Z_Revenue`) se **bilkul alag concept hai**, dono ko kabhi mix mat karna.

### C2. Average Spend per Customer

- **Formula:** `AVG(total_spend)` = Total Revenue / Total Customers
- **Matlab:** Ek average customer 2 saal mein kitna spend karta hai.
- **Kyun important:** "Typical customer value" samajhne ke liye; segments compare karne ke liye baseline.
- **Project mein use:** RFM ka "Monetary" component (Phase 5); segment-wise comparison ka benchmark.
- **Real value:** **607.27** (median: 397 — mean median se zyada hai, matlab distribution **right-skewed** hai, yani thode high-spenders average ko upar khींch rahe hain — isiliye median bhi report karna zaroori hai, sirf mean nahi).
- **Interview Q:** *"Mean aur median dono kyun report karte ho?"* → Jab data skewed ho (kuch extreme high values), mean misleading ho sakta hai; median "typical" customer ko better represent karta hai.

---

## Category D — RFM Components (used fully in Phase 5)

### D1. Recency (R)

- **Formula:** given directly in data — `recency` = days since last purchase.
- **Matlab:** Customer ne kitne din pehle last purchase kiya — **kam Recency = zyada recently active** (better).
- **Kyun important:** Recently active customers zyada likely hain future mein bhi respond karne ke liye.
- **Real value:** min 0, max 99, mean 49.0 days.
- **Interview Q:** *"Recency mein low value better hai ya high?"* → Low better hai (recently purchased kiya).

### D2. Frequency (F)

- **Formula (derived):** `total_purchases = num_web_purchases + num_catalog_purchases + num_store_purchases`
- **Matlab:** Customer ne total kitni baar purchase kiya (2 saal mein, teeno channels milaake).
- **Kyun important:** Zyada frequency = zyada loyal/engaged customer.
- **Real value:** min 0, max 32, mean 12.6 purchases per customer (2 years).
- **Interview Q:** *"NumDealsPurchases ko Frequency mein kyun nahi jodha?"* → Kyunki wo ek "purchase type" hai (discount-driven), na ki ek alag channel — usse jodne se double-counting ka risk tha (ek hi purchase discount + web dono mein count ho sakti thi). Humne is ambiguity ko explicitly avoid kiya.

### D3. Monetary (M)

- **Formula:** `total_spend` (Category C1 wala hi)
- **Matlab:** Customer ne total kitna paisa spend kiya.
- **Kyun important:** Sabse direct "value" indicator ek customer ka.
- **Real value:** min 5, max 2,525, mean 607.3.
- **Interview Q:** *"RFM mein M sabse important kyun mana jaata hai kai business mein?"* → Kyunki ye directly revenue se linked hai — high Monetary customers business ke liye sabse zyada financially valuable hote hain.

---

## Category E — Channel Metrics

### E1. Channel Share (%)

- **Formula:** `Channel Share = SUM(num_purchases for that channel) / SUM(num_purchases across all channels) × 100`
- **Matlab:** Total purchases mein se kitna % ek particular sales channel (Web/Catalog/Store) se aaya.
- **Kyun important:** Batata hai company ka sales kis channel pe most depend karta hai — resource/investment allocation decisions ke liye useful.
- **Project mein use:** Channel comparison chart (Power BI Page 2).
- **Real values:** Store: **46.2% (largest)** · Web: 32.5% · Catalog: **21.3% (smallest)**.
- **Interview Q:** *"Sabse chhota channel (Catalog) ko band kar dena chahiye?"* → Zaroori nahi — 21% bhi meaningful contribution hai; pehle ye dekhna hoga ki kya Catalog-heavy customers kisi specific high-value segment se belong karte hain (Phase 5 mein explore karenge) — "abhi kam hai" != "invest karna galat hai."

---

## Category F — Funnel / Engagement Metrics

### F1. Visit-to-Purchase Engagement Ratio (proxy — labeled clearly)

- **Formula:** `SUM(num_web_visits_month) / SUM(web num_purchases)` — ya per-customer ratio, aggregate ke bajaye.
- **Matlab:** Website par visits ke muqable kitni purchases ho rahi hain.
- **⚠️ Important caveat:** `num_web_visits_month` ek **1-month snapshot** hai, jabki web `num_purchases` **2-year cumulative total** hai — dono ka time window match nahi karta. Isiliye hum ise "precise conversion rate" nahi bolenge, sirf ek **directional engagement proxy**.
- **Kyun important:** Phir bhi, relative comparison (jaise segment A vs segment B) useful reh sakta hai kyunki time-window bias dono groups mein equally apply hota hai.
- **Real values:** Total monthly web visits (summed across all customers) = 11,771; Total 2-year web purchases = 9,043 — ratio ~1.30 visits-per-purchase in raw aggregate terms (again, NOT a true same-window conversion rate).
- **Interview Q:** *"Ye funnel metric 100% accurate hai?"* → Nahi — explicitly bolna hai ki time-window mismatch hai, aur ye ek proxy/directional indicator hai, precise conversion rate nahi.

### F2. Multi-Campaign Responsiveness (Engagement Depth)

- **Formula:** `num_campaigns_accepted` = count of campaigns (out of 6) a customer said yes to.
- **Matlab:** Kitne customers "never responders" hain vs "serial responders."
- **Kyun important:** Ek bahut powerful segmentation angle — agar same 10-15% customers har baar respond karte hain, toh company unhi logo pe repeatedly paisa kharch kar rahi hai jabki baaki untouched hain.
- **Real values (cleaned data):** 0 campaigns: 1,608 (**72.7%**) · 1: 368 · 2: 139 · 3: 51 · 4: 36 · 5: 10. **Nobody accepted all 6.**
- **Interview Q:** *"72.7% customers ne kabhi respond nahi kiya — isse kya business action nikalta hai?"* → Ye suggest karta hai ki either targeting broad/untargeted hai, ya offers un customers ke liye relevant nahi hain — segment-specific campaigns (Phase 5) is problem ko address kar sakti hain.

### F3. Complaint Rate

- **Formula:** `AVG(complain) × 100`
- **Matlab:** Kitne % customers ne pichle 2 saal mein complain kiya.
- **Kyun important:** Customer satisfaction ka basic proxy; high complaint segments ko alag se dekhna zaroori hai.
- **Real value:** **0.9%** (very low — 20 out of 2,212 customers).
- **Interview Q:** *"Itna low complaint rate ka matlab customers khush hain?"* → Zaroori nahi — ho sakta hai log complain hi na karte hon (silent churn). Ye ek **limitation** hai jo hum openly bolenge, overclaim nahi karenge.

---

## Summary Table (all KPIs at a glance)

| # | KPI | Real Value |
|---|---|---|
| A1 | Total Customers | 2,212 |
| A2 | Total Campaigns | 6 |
| B1 | Best / Worst Acceptance Rate | 15.05% (Cmp6) / 1.36% (Cmp2) |
| B3 | Best / Worst ROI | −44.8% (Cmp6) / −95.0% (Cmp2) |
| B4 | Best / Worst CAC | 19.93 (Cmp6) / 221.20 (Cmp2) |
| C1 | Total Revenue | 1,343,277 monetary units |
| C2 | Avg Spend per Customer | 607.27 (median 397) |
| E1 | Channel Share | Store 46.2% / Web 32.5% / Catalog 21.3% |
| F2 | Never-responders | 72.7% of customers |
| F3 | Complaint Rate | 0.9% |

---
*Next: Phase 4 — `sql/` folder + `docs/04_sql_learning.md` (writing real SQL queries against this data in SQLite, from basic SELECT up to simple CTEs and joins across the star schema).*
