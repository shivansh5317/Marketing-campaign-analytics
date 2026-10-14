# 06 — Funnel Analysis

## 1. What is a Funnel? (Hinglish)

**Kya hai:** Funnel ek tarika hai customer journey ko **sequential stages** mein dekhne ka — jaise "kitne log dekhne aaye → kitno ne interest dikhaya → kitno ne kharida." Har stage pe kuch log "drop off" ho jaate hain (aage nahi badhte), aur funnel analysis batata hai **kahan sabse zyada log drop ho rahe hain.**

**Kyun zaroori hai:** Sirf "total sales X hai" jaanne se ye nahi pata chalta ki improvement kaha karni hai. Funnel batata hai **exact stage** jaha sabse zyada opportunity hai.

**Project mein use:** Humare paas ek idealized digital-ad funnel (Impressions → Clicks → Visits → Leads → Purchases) ka data nahi hai (jaisa Phase 0 mein hi clearly bataya tha). Lekin humare paas ek genuinely real, use karne layak funnel hai: **basic engagement → discount-seeking behavior → actual campaign response.**

## 2. Why We Rebuilt the Funnel After Checking the Numbers (an honest correction)

Shuru mein humne socha tha ki "Website Visits (monthly) → Web Purchases (2-year)" ek achha funnel stage-pair banega. Lekin jab humne **real numbers nikale**, ek problem mili:

| Check | Result |
|---|---|
| Customers with ≥1 web visit (this month) | 2,202 (99.5%) |
| Customers with ≥1 web purchase (2 years) | 2,206 (99.7%) |

**Purchase count VISIT count se zyada nikla!** Ek strict funnel mein aisa nahi ho sakta (aage ka stage pehle stage se bada nahi ho sakta). Wajah simple hai: `num_web_visits_month` sirf **is mahine** ka snapshot hai, jabki purchases **2 saal** ka cumulative total hai — ye do alag time-windows hain, isliye inhe sequential funnel stages ki tarah treat karna galat tha.

**Hum ye chhupa nahi rahe — humne pakड़ liya aur fix kiya.** Ye exactly wo tarah ki galti hai jo interview mein ek acha analyst pakadta hai apne aap, bina kisi aur ke bataye.

**Fix:** Hum sirf un fields ko sequential funnel banayenge jo **same time window (2 saal, cumulative)** share karte hain. Website-visit-vs-purchase ko ek **alag, clearly-labeled "engagement proxy"** ki tarah dikhayenge, funnel stage ki tarah nahi.

## 3. The Real Funnel (all stages use consistent 2-year cumulative fields)

```
Stage 1: Total Customers                           2,212   (100%)
              ↓  (drop-off: 6 customers, 0.3%)
Stage 2: Made ≥1 Purchase (any channel, 2 yrs)      2,206   (99.7%)
              ↓  (drop-off: 38 customers, 1.7%)
Stage 3: Used a Deal/Discount at least once         2,168   (98.0%)
              ↓  (drop-off: 1,564 customers, 72.1%)  ⚠️ BIGGEST DROP-OFF
Stage 4: Accepted ≥1 Marketing Campaign (of 6)        604   (27.3%)
```

**Where's the biggest drop-off?** Overwhelmingly between Stage 3 and Stage 4 — **72.1%** of customers who are otherwise perfectly normal, active, deal-using shoppers **never accept a single targeted marketing campaign.** Basic purchasing behavior is almost universal (98–100% at every early stage); the real business bottleneck is campaign responsiveness, not product engagement.

*(Language check: we say "may indicate" and "worth investigating," not "proves," in the interpretation below — consistent with the project's rule about not claiming causation from observational data.)*

## 4. Funnel by Customer Segment (using Phase 5 RFM segments)

| Segment | Customers | Made ≥1 Purchase | Accepted ≥1 Campaign |
|---|---|---|---|
| Champions | 534 | 100.0% | **47.8%** |
| Loyal Customers | 849 | 100.0% | 29.7% |
| At Risk | 560 | 99.6% | 13.8% |
| Lost / Hibernating | 269 | 98.5% | **7.4%** |

**Interpretation:** Basic purchase engagement barely varies by segment (98.5%–100%) — everyone in our database is a real, active-ish shopper. But campaign acceptance varies **6.5x** between the best segment (Champions, 47.8%) and the worst (Lost/Hibernating, 7.4%). This confirms the funnel drop-off isn't a "product problem" — it's specifically a **campaign targeting/relevance problem**, and it's not evenly distributed: it's concentrated in the At Risk and Lost segments.

## 5. Funnel by Sales Channel (drop-off = customers who never use that channel)

| Channel | Customers Using It (≥1 purchase) | Customers with ZERO purchases | Channel Share of Volume |
|---|---|---|---|
| Store | 2,198 (99.4%) | 14 (0.6%) | 46.2% |
| Web | 2,164 (97.8%) | 48 (2.2%) | 32.5% |
| Catalog | **1,637 (74.0%)** | **575 (26.0%)** | 21.3% |

**Interpretation:** Store and Web are used by almost everyone. Catalog is different — a full **26% of customers have never made a single catalog purchase.** This may indicate the catalog channel isn't reaching/appealing to a meaningful chunk of the customer base — worth investigating whether catalog distribution, format, or awareness is the limiting factor (data can't tell us *why*, only *that*).

## 6. What We Are NOT Claiming

- We are **not** claiming the low catalog usage or low campaign acceptance is *caused* by any specific factor (pricing, message, timing) — the data only shows association/pattern, not root cause.
- We are **not** presenting the visit-vs-purchase numbers as a "conversion rate" — explicitly demoted to a labeled engagement proxy after finding the time-window inconsistency above.
- We are **not** claiming this funnel generalizes beyond this company/dataset.

## 7. Interview Questions

- *"Aapka funnel kis stage pe sabse zyada drop-off dikhata hai, aur why does that make sense?"* → Deal-user → Campaign-acceptor stage (72.1% drop). Sensible hai kyunki "discount use karna" ek low-effort action hai, jabki "targeted campaign accept karna" customer se zyada specific interest/timing/relevance maangta hai.
- *"Aapne shuru mein ek funnel design kiya tha jo galat nikla — kya hua?"* → (great real story) Website-visits (monthly snapshot) ko web-purchases (2-year cumulative) ke against funnel stage banaya tha; jab numbers check kiye toh purchase-count visit-count se bada nikla — jo ek real funnel mein possible nahi. Time-window mismatch identify karke, us metric ko "funnel stage" se "engagement proxy" mein reclassify kiya.
- *"Catalog channel ka 26% non-usage number dekh ke aap kya business action suggest karoge?"* → "Investigate karo" — jaise catalog distribution reach, ya A/B test karke dekho ki catalog-non-users ko catalog exposure dene se purchase behavior badalta hai ya nahi. Seedha "catalog band kar do" nahi bolenge bina root-cause investigate kiye.
- *"Segment-wise funnel se business ko kya concrete insight milta hai?"* → Champions/Loyal segments already engaged hain — unke liye funnel theek hai. At Risk/Lost segments ke liye actual problem "purchase karna" nahi hai (wo already kar rahe hain), balki "campaign se connect na hona" hai — isliye inke liye alag messaging/offer strategy chahiye, na ki generic "buy more" push.

---
*Next: Phase 7 — `notebooks/01_marketing_eda.ipynb` (Python/pandas EDA notebook bringing SQL + segmentation + funnel findings together with visualizations) + `docs/07_python_eda_learning.md`.*
