# 05 — Data Model and Database

🔴 MUST KNOW

## 1. Core Database Vocabulary

### GENERAL CONCEPT

| Term | Meaning |
|---|---|
| **Database** | An organized collection of tables that store related data |
| **Table** | A grid of rows and columns storing one type of entity (e.g., customers) |
| **Row** | One record/observation |
| **Column** | One attribute, same for every row |
| **Primary Key (PK)** | A column that uniquely identifies each row; never NULL, never duplicated |
| **Foreign Key (FK)** | A column in one table that refers to another table's Primary Key, used to link tables |
| **Relationship** | How two tables connect via a PK-FK pair |
| **One-to-Many** | One row in Table A can relate to many rows in Table B (e.g., one customer → many orders) |
| **Many-to-Many** | Rows in Table A can relate to many rows in Table B, and vice versa (needs a "bridge" table) |
| **Normalization** | Organizing data to reduce redundancy — splitting one giant table into smaller, linked ones |

### MY PROJECT

| Concept | Our example |
|---|---|
| Primary Key | `dim_customers.customer_id` — verified 0 duplicates in Phase 1 |
| Foreign Key | `fact_campaign_response.customer_id` and `fact_channel_purchases.customer_id` — both point back to `dim_customers.customer_id` |
| Relationship type | **One-to-Many** in both cases (one customer → 6 campaign rows; one customer → 3 channel rows) |
| Normalization example | The raw file was one wide table (29 columns). We split it into 1 dimension + 2 fact tables — this *is* normalization, done specifically to unlock clean `GROUP BY`/`JOIN` patterns |

**Common mistake:** assuming a Foreign Key must be unique — it's not. `fact_campaign_response.customer_id` repeats 6 times per customer, and that's completely normal for a one-to-many relationship.

## 2. Fact vs. Dimension Tables (Star Schema)

- **Dimension table** = describes WHO/WHAT/WHERE — mostly static attributes, fewer rows. Ours: `dim_customers`.
- **Fact table** = records WHAT HAPPENED / a measurable event — many rows, has FK columns + numeric measures. Ours: `fact_campaign_response`, `fact_channel_purchases`.

```
dim_customers (2,212 rows)              -- WHO
fact_campaign_response (13,272 rows)    -- WHAT HAPPENED: did they accept campaign X?
fact_channel_purchases (6,636 rows)     -- WHAT HAPPENED: how many times did they buy via channel Y?
```

**Interview Q:** *"Fact aur Dimension table size se pehchante ho?"* → Nahi — size ek side-effect hai, definition nahi. Asli criterion: fact = events/measurements, dimension = descriptive attributes.

## 3. JOIN Types

### GENERAL CONCEPT

| JOIN Type | Analogy | Returns |
|---|---|---|
| **INNER JOIN** | "Sirf wahi log jo dono lists mein hain" | Rows where the key matches in BOTH tables |
| **LEFT JOIN** | "Saari left list, plus jo match mile right se" | All rows from left table + matched right rows (unmatched = NULL) |
| **RIGHT JOIN** | Same as LEFT, mirrored | All rows from right table + matched left rows |
| **FULL (OUTER) JOIN** | "Dono lists, sab kuch, matched ya unmatched" | All rows from both tables, NULL where no match |

**Tiny example:** Table `Students` (id, name) and `Grades` (student_id, marks). INNER JOIN only returns students who have a grade recorded. LEFT JOIN returns every student, even ones with no grade yet (marks = NULL for them).

### MY PROJECT — Which JOINs We Actually Used

We used **INNER JOIN** (written simply as `JOIN` in SQLite) throughout — e.g., `sql/03_customer_analysis.sql` Query 3:

```sql
FROM dim_customers d
JOIN fact_campaign_response f ON d.customer_id = f.customer_id
```

**Why only INNER JOIN?** Every customer in `dim_customers` genuinely has exactly 6 rows in `fact_campaign_response` (since the unpivot created a row for every campaign for every customer) — there's no "customer with no campaign data" case, so a LEFT JOIN would produce the identical result here. We didn't force a LEFT JOIN just to "use" it — using the JOIN type the data actually needs is the correct call.

**Common mistake we explicitly handled — JOIN fan-out:** after `JOIN fact_campaign_response`, each customer appears **6 times** (once per campaign) — so `COUNT(*)` after the join counts (customer × campaign) pairs, NOT unique customers. That's why our queries use `COUNT(DISTINCT d.customer_id)` when we need a true customer count, alongside a separate `COUNT(*)`/`SUM()` for the fact-level numbers.

**Interview Q:** *"Aapne LEFT JOIN kahin use nahi kiya — kya ye galti hai?"* → Nahi — LEFT JOIN tab zaroori hota jab kuch dimension rows ke fact table mein koi matching row na ho aur humein unhe phir bhi dikhana ho (with NULLs). Humare data mein har customer ke paas guaranteed fact rows hain (unpivot se), isliye INNER JOIN hi correct/simplest choice thi. Use the JOIN the *data* needs, not the JOIN that "looks more advanced."

## 4. Why Understanding the Schema Matters (a real story from this project)

Humne khud is project mein ek genuine schema-understanding mistake pakड़ी: shuru mein humne socha "Website Visits (monthly)" aur "Web Purchases (2-year)" ko funnel stages ki tarah treat karein. Jab actual numbers nikale, purchase-count visit-count se **bada** nikla — jo impossible hai ek real funnel mein. Wajah: dono columns ka time-window alag tha. Humne isse funnel se hata ke ek clearly-labeled "engagement proxy" bana diya. Ye exactly wo galti hai jo schema ko surface-level samajhne se hoti hai — deep samajhna (units, time-windows, definitions) is liye zaroori hai.

## 5. INTERVIEW

**Q: "Primary Key aur Foreign Key mein farak batao apne project ke example se."**
> "`dim_customers.customer_id` humara Primary Key hai — unique, never null, verified 0 duplicates. `fact_campaign_response.customer_id` ek Foreign Key hai — wahi values repeat hoti hain (6 baar per customer), aur `dim_customers.customer_id` ko reference karti hain. FK ka duplicate hona bilkul normal hai one-to-many relationship mein."

**Q: "INNER JOIN aur LEFT JOIN mein kab konsa use karoge?"**
> "Agar mujhe sirf wahi rows chahiye jinka match dono taraf ho, INNER JOIN. Agar mujhe 'left' table ki saari rows chahiye chahe unka match ho ya na ho (jaise 'sabhi customers dikhao, chahe unhone kabhi campaign accept ki ho ya nahi'), LEFT JOIN. Humare project mein har customer ke paas guaranteed fact-rows the, isliye INNER JOIN kaafi tha."

**Q: "JOIN ke baad `COUNT(*)` galat kyun ho sakta hai?"**
> "Kyunki one-to-many JOIN ke baad rows 'fan out' ho jaati hain — ek customer 6 baar dikh sakta hai. `COUNT(*)` tab customer count nahi, customer×campaign pair count dega. Sahi customer count ke liye `COUNT(DISTINCT customer_id)` chahiye."

## 6. What I Should Remember

1. `customer_id` = the PK/FK glue connecting all 3 tables.
2. Fact = events (many rows), Dimension = descriptive entity (fewer rows) — not a size rule, a meaning rule.
3. We only needed INNER JOIN — because our data's shape (guaranteed matching rows) didn't need LEFT/RIGHT/FULL.
4. Always check what `COUNT(*)` really counts after a JOIN — this is a real, common, easy-to-miss bug.

---
*Next: [06_SQL_FROM_ZERO.md](06_SQL_FROM_ZERO.md)*
