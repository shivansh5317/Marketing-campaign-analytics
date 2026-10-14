# 15 — Channel Analysis

🟡 GOOD TO KNOW

## 1. What Is a Marketing Channel?

### GENERAL CONCEPT

A channel is **the medium through which a company reaches or transacts with a customer.** Common digital-marketing examples: Email, Search (Google Ads), Social Media, Display Ads, Referral.

### MY PROJECT — Important Reframe

⚠️ Our dataset has **no ad/acquisition channel data** (no Email/Social/Search columns). What it *does* have is **sales/purchase channel** — how the customer actually bought: **Web, Catalog, Store**. This is a legitimate, different, still-valuable business question ("where do people buy"), not the classic "where did we advertise" question. We never blur this distinction.

## 2. MY PROJECT — Channel Comparison, In Full

| Channel | Total Purchases (2yr) | Share % | Avg Purchases/Customer | Customers Never Using It |
|---|---|---|---|---|
| Store | 12,844 | 46.2% | 5.81 | 14 (0.6%) |
| Web | 9,043 | 32.5% | 4.09 | 48 (2.2%) |
| Catalog | 5,911 | 21.3% | 2.67 | **575 (26.0%)** |

**Source:** `sql/02_channel_performance.sql`, cross-checked in the Phase 7 notebook.

## 3. Avoiding Misleading Channel Comparisons

### GENERAL CONCEPT

"Highest number of purchases" does **not** automatically mean "most efficient channel." A channel could have high volume simply because more customers habitually use it, while still being inefficient to operate, or under-penetrated among a valuable segment.

### MY PROJECT — Two Different, Both-Real Findings

- **Volume view:** Store dominates by sheer purchase count (46.2% share).
- **Penetration view:** Catalog has a *qualitatively different* problem — not just "lower volume," but **26% of customers have literally never used it once** — a reach/awareness gap that a pure volume-share number hides.

These are two **different diagnoses** requiring two different kinds of action — this is exactly why we look at both the share % AND the never-used %, not just one.

## 4. Should the Smallest Channel (Catalog) Be Cut?

**No — not from this data alone.** 21.3% is still a meaningful share of total volume. Before recommending any cut, we'd want to check: do Catalog-heavy customers belong to a specific valuable segment? (This is exactly the kind of cross-check [17_CUSTOMER_SEGMENTATION.md](17_CUSTOMER_SEGMENTATION.md) + channel data could answer, if pursued further — not yet done in this project, a legitimate "next step.")

## 5. INTERVIEW

**Q: "Aapke project mein 'channel' ka matlab ad-channel hai ya kuch aur?"**
> "Sales channel — Web/Catalog/Store, yaani customer ne kahan se khareeda. Humare dataset mein ad/acquisition-channel (jaise Email/Social) data nahi hai — maine ye explicitly document kiya hai taaki confusion na ho."

**Q: "Sabse chhota channel (Catalog) band kar dena chahiye?"**
> "Seedha nahi — 21% bhi meaningful contribution hai. Pehle check karna chahiye ki Catalog-heavy customers kisi specific high-value segment se belong karte hain ya nahi. 'Abhi kam hai' ka matlab 'invest karna galat hai' nahi hota."

**Q: "Catalog ka 26% never-used number aapko kya batata hai jo 21.3% share number nahi batata?"**
> "Share % ek volume-level view hai — total purchases mein contribution. Never-used % ek **reach/penetration** view hai — kitne customers is channel ko bilkul touch hi nahi karte. Dono alag diagnoses hain — ek 'kam efficient' keh sakta hai, doosra 'kam log isse access hi nahi kar rahe' keh sakta hai."

## 6. Common Mistakes

- "Highest volume" ko seedha "most efficient/important" maan lena.
- Chhote channel ko "non-performing" label karna bina penetration/reach alag se check kiye.
- Sales channel aur ad/acquisition channel ko confuse karna — ye project ismein especially important hai.

## 7. What I Should Remember

1. Our "channel" = sales channel (Web/Catalog/Store), not ad channel — a stated, deliberate reframe.
2. Volume share and never-used % are two different lenses — both are needed for a complete picture.
3. Never recommend cutting a channel based on volume share alone.

---
*Next: [16_CUSTOMER_ANALYSIS.md](16_CUSTOMER_ANALYSIS.md)*
