# 02 — Marketing Analytics From Zero

🔴 MUST KNOW

Ye chapter bahut important hai — poore project ka business context yahi hai. Sab kuch scratch se explain kiya gaya hai, phir project se map kiya gaya hai.

## 1. Core Marketing Vocabulary

### GENERAL CONCEPT

| Term | Meaning | Example |
|---|---|---|
| **Marketing** | Customers ko products/services ke baare mein batana aur unhe khareedne ke liye persuade karna | Ek email offer bhejna |
| **Digital Marketing** | Marketing jo online channels (email, social, search, ads) ke through hoti hai | Facebook ad campaign |
| **Marketing Campaign** | Ek specific, time-bound marketing effort ek goal ke saath (jaise "naya product launch karna") | "Diwali Sale Campaign" |
| **Marketing Channel** | Wo medium jisse company customer tak pahunchti hai | Email, Social Media, Website, **ya sales channel jaise Store/Catalog** |
| **Audience** | Wo log jinhe target kiya ja raha hai | "25-35 age group, high income" |
| **Acquisition** | Naya customer haasil karna | Pehli baar khareedne wala customer |
| **Engagement** | Customer brand ke saath kitna interact kar raha hai | Email open karna, website visit karna |
| **Conversion** | Desired action complete hona (usually purchase, but signup/click bhi ho sakta hai context ke hisaab se) | Offer accept karna, purchase karna |
| **Customer** | Wo insaan/entity jisne already khareeda hai (ya company ke database mein hai) | Humara dataset ka har row |
| **Prospect / Lead** | Potential customer jisne abhi khareeda nahi, lekin interest dikhaya hai | Website pe form fill kiya lekin khareeda nahi |
| **Retention** | Existing customers ko dobara-dobara khareedne ke liye rokna/encourage karna | Loyalty program |
| **Funnel** | Customer journey ko sequential stages mein dekhna, har stage pe drop-off track karna | Impression → Click → Purchase |

**Chota example (poora flow):** Ek company Instagram pe ad chalati hai (channel = Social) → 10,000 log dekhte hain (**Impression**) → 500 click karte hain (**Engagement/Click**) → 50 khareedte hain (**Conversion**). Ye ek chhota **funnel** hai.

## 2. Marketing Data vs. Marketing Analytics vs. Marketing Reporting

| Concept | Kya hai | Example |
|---|---|---|
| **Marketing Data** | Raw records — jo bhi track hua | "Customer 5524 ne Cmp6 accept kiya" |
| **Marketing Reporting** | Data ko summarize/present karna, usually periodic, WHAT hua | "Is mahine 15% customers ne Cmp6 accept kiya" |
| **Marketing Analytics** | Data ko analyze karke WHY aur WHAT NEXT nikalna | "Cmp6 ka acceptance rate baaki campaigns se dogune se zyada hai kyunki [hypothesis] — inhi patterns wale customers ko next campaign mein priority do" |

**Difference ka core:** Reporting **describes**, Analytics **explains aur guide karta hai decisions ko**.

## 3. Why Do Businesses Analyze Campaigns?

- Marketing budget **limited** hota hai — company ko pata hona chahiye kaunsi campaign paisa "kama" rahi hai, kaunsi waste kar rahi hai.
- Har customer same nahi respond karta — analytics batata hai **kise target karna chahiye**.
- Bina analytics ke, companies "gut feeling" pe decisions leti hain — jo mehenga galti ban sakta hai.

## 4. MY PROJECT — What Marketing Analytics Concepts Actually Apply

⚠️ **Important:** Humara project ek **specific** kism ka marketing data use karta hai — sab kuch upar diya generic concept humare dataset mein nahi hai. Yahan explicit mapping hai:

| Generic Concept | Available in my project? | What we actually have instead |
|---|---|---|
| Campaign | ✅ Yes | 6 real campaigns (Cmp1-5 + Response/Cmp6), accept/reject flag per customer |
| Channel | ⚠️ Reframed | Digital ad channels (Email/Social/Search) **nahi** hain — humare paas **sales/purchase channel** hai (Web/Catalog/Store — customer ne kahan se khareeda) |
| Audience/Targeting | ⚠️ Partial | Koi explicit "targeted list" nahi — dataset assume karta hai sabhi customers ko har campaign target kiya gaya |
| Impressions/Clicks/CTR | ❌ No | Ad-platform data nahi hai — hum ye invent nahi karte |
| Conversion | ✅ Yes | Campaign acceptance (`accepted` flag), aur purchases |
| Funnel | ⚠️ Adapted | Classic "Impression→Click→Purchase" nahi — humara real funnel hai "Total → Purchased → Used Deal → Accepted Campaign" (Phase 6) |
| Customer Acquisition | ⚠️ Partial | "Acquisition cost" ka concept hai (CAC), lekin naye-vs-purane customer difference track nahi hota, sirf campaign-response track hota hai |
| Retention | ⚠️ Proxy | Direct retention metric nahi, lekin `Recency`/`Tenure` se related inference nikalte hain |

**Ye table baar-baar refer karo** — interview mein agar koi generic marketing-analytics sawaal poochhe jo humare data mein nahi hai (jaise "aapka CTR kya tha"), tumhe confidently bolna hai "humare dataset mein ad-impression data nahi tha, isliye CTR calculate nahi kar sakte — humne iski jagah sales-channel efficiency dekhi."

## 5. How a Company Uses Analytics to Make Decisions (example flow)

```
Observation: Campaign X ka acceptance rate sirf 1.36% hai (sabse kam)
      ↓
Analytics: Compare karo baaki campaigns se, segment-wise breakdown dekho
      ↓
Insight: Ye specific campaign har segment mein hi kam perform kar rahi hai
      ↓
Decision: Agli baar is campaign ka offer/design redo karo, ya band karo
```

## 6. INTERVIEW

**Q: "Marketing Analytics kya hota hai, aur ye Marketing Reporting se kaise alag hai?"**
> "Reporting sirf batata hai 'kya hua' (jaise total sales), Analytics 'kyun hua aur aage kya karna chahiye' explain karta hai. Meri project mein, reporting hota "Cmp6 ka 15% acceptance rate hai," analytics hota hai "Cmp6 recent hai, aur recently-active customers zyada accept karte hain (recency correlation) — isliye timing/recency-based targeting kaam kar sakta hai.""

**Q: "Aapke project mein 'channel' ka matlab kya hai — ad channel ya kuch aur?"**
> "Humare dataset mein 'channel' ka matlab **sales channel** hai — Web, Catalog, Store — yani customer ne kahan se khareeda, na ki humne unhe kis ad-platform (Facebook/Google) se target kiya. Ye ek important distinction hai jo maine explicitly document kiya hai taaki main galti se CTR jaisa unavailable metric claim na karun."

**Q: "Agar aapke paas Impressions/Clicks ka data hota, toh aap kya alag karte?"**
> "Tab main ek real Awareness→Click→Visit funnel bana sakta tha aur CTR/CPC jaise metrics calculate kar sakta tha. Abhi humare paas sirf accept/reject aur purchase-count data hai, isliye humara funnel 'Purchase→Deal-use→Campaign-accept' pe based hai — genuinely different, lekin equally valid business question."

## 7. Common Mistakes

- Har marketing dataset mein CTR/Impressions assume kar lena hoga — nahi, dataset-dependent hota hai.
- "Channel" ko hamesha "ad channel" samajh lena — business context ke hisaab se "sales channel" bhi ho sakta hai.
- Reporting aur Analytics ko same treat karna interview mein — ye ek common trap question hai.

## 8. What I Should Remember

1. Marketing Analytics = data se "why" aur "what next" nikalna, sirf "what" nahi (reporting).
2. Humara "channel" = sales channel (Web/Catalog/Store), ad-channel nahi.
3. Humare paas Impressions/CTR/CPC genuinely nahi hai — hum kabhi invent nahi karte.
4. Funnel humesha same "Impression→Click→Purchase" template follow nahi karta — dataset ke hisaab se adapt hota hai.

---
*Next: [03_PROJECT_OVERVIEW.md](03_PROJECT_OVERVIEW.md)*
