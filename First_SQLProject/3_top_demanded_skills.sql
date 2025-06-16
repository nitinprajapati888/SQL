-- Top 5 most demand skill for Data Analyst
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_work_from_home = TRUE
GROUP BY
    skills
    
ORDER BY
    demand_count DESC
LIMIT 5
-- [
--   {
--     "skills": "sql",
--     "demand_count": "7291"
--   },
--   {
--     "skills": "excel",
--     "demand_count": "4611"
--   },
--   {
--     "skills": "python",
--     "demand_count": "4330"
--   },
--   {
--     "skills": "tableau",
--     "demand_count": "3745"
--   },
--   {
--     "skills": "power bi",
--     "demand_count": "2609"
--   }
-- ]