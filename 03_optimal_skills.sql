/*
Question: What are the most optimal skills for data scientists in Germany, balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on Data Scientist positions located in Germany.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data science careers in Germany.
*/


SELECT 
  sd.skills,
  ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
  COUNT(jpf.*) AS demand_count,
  ROUND(LN(COUNT(jpf.*)), 1) AS ln_demand_count,
  ROUND((LN(COUNT(jpf.*)) * MEDIAN(jpf.salary_year_avg))/1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER  JOIN skills_job_dim AS sjd
  ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
  ON sjd.skill_id = sd.skill_id
WHERE 
  LOWER(jpf.job_location) = 'germany'
  AND LOWER(jpf.job_title_short) = 'data scientist'
GROUP BY sd.skills
HAVING 
    COUNT(sjd.job_id) >= 25
ORDER BY optimal_score DESC
LIMIT 20;




/*
┌──────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│    skills    │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│   varchar    │    double     │    int64     │     double      │    double     │
├──────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ r            │      158891.0 │          277 │             5.6 │          0.89 │
│ python       │      118543.0 │          647 │             6.5 │          0.77 │
│ java         │      162000.0 │           79 │             4.4 │          0.71 │
│ spark        │      171121.0 │           62 │             4.1 │          0.71 │
│ sql          │      119553.0 │          329 │             5.8 │          0.69 │
│ git          │      155783.0 │           51 │             3.9 │          0.61 │
│ gcp          │      158891.0 │           43 │             3.8 │           0.6 │
│ tableau      │      118543.0 │          104 │             4.6 │          0.55 │
│ sas          │      118543.0 │           72 │             4.3 │          0.51 │
│ azure        │       88956.0 │          145 │             5.0 │          0.44 │
│ tensorflow   │       88956.0 │           90 │             4.5 │           0.4 │
│ scikit-learn │       88956.0 │           92 │             4.5 │           0.4 │
│ go           │      120564.0 │           27 │             3.3 │           0.4 │
│ pandas       │       88956.0 │           94 │             4.5 │           0.4 │
│ javascript   │       85400.0 │           47 │             3.9 │          0.33 │
│ power bi     │       80871.0 │           59 │             4.1 │          0.33 │
│ snowflake    │       88956.0 │           36 │             3.6 │          0.32 │
│ c++          │       86400.0 │           36 │             3.6 │          0.31 │
│ sap          │       43200.0 │           51 │             3.9 │          0.17 │
│ excel        │       43200.0 │           38 │             3.6 │          0.16 │
└──────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘



Breakdown:

High-demand skills (by demand_count):
- Python (647), SQL (329), and R (277) dominate postings, followed by Azure (145),
  Tableau (104), Pandas (94), Scikit-learn (92), and TensorFlow (90).
- Python and SQL are near-universal requirements. Their medians (118,543 and
  119,553) are only mid-range, so they are expected of everyone and do not
  create a pay premium on their own.
- Azure and the ML libraries (Pandas, Scikit-learn, TensorFlow) are frequently
  requested but sit at a median of 88,956, well below the top-paid skills.

High-paid skills (by median_salary):
- Spark (171,121), Java (162,000), R and GCP (158,891), and Git (155,783)
  lead on pay, with Go (120,564) next.
- Most of these have lower demand (Spark 62, Java 79, Git 51, GCP 43, Go 27),
  which suggests a premium for engineering-leaning, big-data skills.
- R is the exception: it is both high-paid and high-demand, which is why it
  ranks #1 overall.

Skills by category:
- Programming languages: R (0.89), Python (0.77), Java (0.71), and Go (0.40) score
  best. SAS (0.51) and JavaScript/C++ (about 0.3) score lower, with medians
  of 85,000-119,000.
- Big data and cloud: Spark (0.71) and GCP (0.60) pay the most. Azure (0.44) and
  Snowflake (0.32) have a lower median (88,956).
- ML libraries: Pandas, Scikit-learn, and TensorFlow tie at 0.40, with
  high demand (90-94) but a modest median (88,956).
- BI and visualization: Tableau (0.55) leads, then Power BI (0.33) and
  Excel (0.16). Excel has one of the lowest medians (43,200).
- Tools and enterprise software: Git (0.61) scores well, while SAP (0.17) has
  the lowest score and median (43,200).

Key Takeaways:
- R is the most optimal skill (0.89): high pay (158,891) plus strong demand (277).
- Python ranks #2 (0.77) because of demand (647), not pay. It is a must-have
  foundation rather than a salary booster.
- Spark, Java, and GCP combine top-tier pay with moderate demand, making them
  the best skills to add on top of the basics for higher pay.
- SQL and Tableau are solid, reliable skills (0.69 and 0.55) with high demand
  and average pay.
- Excel and SAP rank last, so they are low-value skills to prioritize.
- Caveat: demand_count includes postings without a listed salary, while the
  medians use only salaried rows. Many skills share identical medians,
  which points to a small salary sample, so treat the scores as directional.
*/