/*
Question: What are the highest-paying skills for data scientists in Germany?
- Calculate the median salary for each skill required in data scientist positions
- Focus on data scientist postings located in Germany
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing
    how common those skills are, providing a more complete picture for skill development priorities
*/

SELECT 
  sd.skills,
  ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
  COUNT(jpf.job_id) AS skill_frequency
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
  ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
  ON sjd.skill_id = sd.skill_id
WHERE 
  LOWER(jpf.job_location) = 'germany'
  AND LOWER(jpf.job_title_short) = 'data scientist'
GROUP BY sd.skills
HAVING COUNT(jpf.job_id) >= 10
ORDER BY median_salary DESC
LIMIT 10;

/*
Key Takeaway:
- Spark pays the most (171,121) with solid demand (62 postings).
- Java and C# follow at 162,000; GCP and R at 158,891.
- R combines high pay with the highest volume among the top paying skills (277 postings).
- SQL is the most requested here (329) but pays the least (119,553), so it
  is a baseline skill, not a differentiator.

Breakdown:
Top pay in Germany goes to big-data and engineering-leaning skills. Spark
leads, followed by Java, C#, and cloud (GCP). R stands out as both well paid
and widely requested. SQL has the highest demand in this list but the lowest
median, so it is expected of everyone rather than a pay booster. To reach
higher pay tiers, add Spark and a cloud platform on top of the basics.

┌─────────┬───────────────┬─────────────────┐
│ skills  │ median_salary │ skill_frequency │
│ varchar │    double     │      int64      │
├─────────┼───────────────┼─────────────────┤
│ spark   │      171121.0 │              62 │
│ c#      │      162000.0 │              23 │
│ java    │      162000.0 │              79 │
│ gcp     │      158891.0 │              43 │
│ r       │      158891.0 │             277 │
│ git     │      155783.0 │              51 │
│ looker  │      155783.0 │              12 │
│ go      │      120564.0 │              27 │
│ github  │      120564.0 │              21 │
│ sql     │      119553.0 │             329 │
└─────────┴───────────────┴─────────────────┘
*/