/*
Question: What are the most in-demand skills for data scientists in Germany?
- Join job_postings_fact to skills_job_dim and skills_dim (same inner-join pattern as query 2)
- Filter to postings located in Germany with the title "Data Scientist"
- Count postings per skill and return the top 10
- Why? Shows which skills appear most often in German data scientist job postings,
    helping job seekers decide which skills to prioritize
*/

SELECT 
  sd.skills,
  COUNT(jpf.job_id) as demand
FROM job_postings_fact AS jpf
INNER  JOIN skills_job_dim AS sjd
  ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
  ON sjd.skill_id = sd.skill_id
WHERE 
  LOWER(jpf.job_location) = 'germany'
  AND LOWER(jpf.job_title_short) = 'data scientist'
GROUP BY sd.skills
ORDER BY
    demand DESC
LIMIT 10 ;


/* 

Breakdown:
The results show that German data scientist postings are built on three layers.
The first is the core language layer: Python dominates with 647 postings, while
SQL (329) and R (277) round out the foundation. Python covers modeling and
analysis, SQL is needed to pull data from databases, and R's strong showing
suggests continued demand in research, statistics, and academic-style roles.
The second layer is infrastructure and communication: Azure (145) and AWS (113)
show that employers expect data scientists to work in cloud environments, with
Azure ahead, likely because of Germany's large enterprise sector, while Tableau
(104) shows that presenting insights to stakeholders is part of the job. The
third layer is the ML and data toolkit: Pandas (94) for data wrangling, and
scikit-learn (92), PyTorch (96), and TensorFlow (90) for classical machine
learning and deep learning. Their near-identical counts mean employers ask for
them depending on the role rather than favoring one. For job seekers, the
priority order is Python first, then SQL, then one cloud platform (Azure is a
safe pick), then one ML framework, with Tableau and R as useful extras.


┌──────────────┬────────┐
│    skills    │ demand │
│   varchar    │ int64  │
├──────────────┼────────┤
│ python       │    647 │
│ sql          │    329 │
│ r            │    277 │
│ azure        │    145 │
│ aws          │    113 │
│ tableau      │    104 │
│ pytorch      │     96 │
│ pandas       │     94 │
│ scikit-learn │     92 │
│ tensorflow   │     90 │
└──────────────┴────────┘



Key Takeaway:
- Python is the clear #1 skill (647 postings), nearly 2x SQL (329) and 2.3x R (277).
  Python + SQL + R form the core foundation employers expect.
- Cloud matters: Azure (145) leads AWS (113), reflecting Germany's
  enterprise-heavy, Microsoft-oriented market.
- Tableau (104) is the only BI tool in the top 10, so communicating
  insights is expected alongside modeling.
- ML frameworks cluster tightly (PyTorch 96, scikit-learn 92, TensorFlow 90),
  so no single framework dominates. Knowing one deep learning framework well
  is enough for most postings.
- Pandas (94) is the go-to tool for day-to-day data wrangling in Python.
*/