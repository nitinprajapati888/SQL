# Data Analyst Job Market Analysis
# Introduction

This repository contains a data analysis project focused on understanding the job market for Data Analysts. The goal is to identify top-paying jobs, most demanded skills, and optimal skill sets for remote Data Analyst roles, providing valuable insights for job seekers and those looking to upskill.

# Background
The job market for Data Analysts is dynamic and competitive. This project aims to extract actionable insights from job posting data to help individuals navigate this landscape effectively. By analyzing salary trends and skill demands, we can pinpoint what employers are looking for and where the most lucrative opportunities lie, especially for remote positions.

# Tools I Used
- **SQL (PostgreSQL/SQL Server syntax used):** For querying and manipulating the job posting and skills data.

- **Database:** A relational database (e.g., PostgreSQL, MySQL, SQL Server) to store and manage the job data.

- **Data Visualization Tool:** (e.g., Tableau, Power BI, Matplotlib/Seaborn in Python) for creating insightful visualizations from the query results.

# The Analysis
The analysis is structured around several key questions, each answered by a specific SQL query.

### 1. Top 10 Highest Paying Remote Data Analyst Jobs
This query identifies the top 10 data analyst jobs with the highest average annual salaries, specifically focusing on remote positions available "Anywhere".

### 1_top_paying_jobs.sql
```sql
-- Here is a query for top 10 paying company for Data Analyst job roll
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
### ![Top Paying Rolles](imeages are in processings)
### 2. Top Paying Skills for Data Analysts in Top Companies
This query extends the previous one by joining the top-paying jobs with the skills required for those positions, providing insight into which skills are associated with the highest salaries in leading companies.
### 2_top_paying_job_skills.sql
```sql
-- Top Paying skill for Data Analyst in Top 10 Companies
WITH  top_paying_jobs AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM 
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
### 3. Top 5 Most Demanded Skills for Remote Data Analysts
This query identifies the top 5 skills most frequently requested for remote Data Analyst positions.
###3_top_demanded_skills.sql
```sql
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
LIMIT 5;
```
### 4. Top 25 Highest Paying Skills for Remote Data Analysts
This query calculates the average salary for the top 25 skills associated with remote Data Analyst jobs, helping to understand which skills command the highest pay.
### 4_top_paying_skills.sql
```sql
-- Top 25 skill salary_year_avg 
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills  
ORDER BY
    avg_salary DESC
LIMIT 25;
```
### 5. Optimal Skills for Remote Data Analysts (Balancing Demand and Salary)
This query combines insights from demand and average salary to identify optimal skills—those that are both highly demanded and well-paying for remote Data Analyst roles.
### 5_optimal_skills.sql
```sql
WITH combined_skill_stats AS (
    SELECT 
        sd.skill_id,
        sd.skills,
        COUNT(jpf.job_id) AS demand_count,
        ROUND(AVG(jpf.salary_year_avg), 0) AS avg_salary
    FROM 
        job_postings_fact AS jpf
    INNER JOIN 
        skills_job_dim AS sjd ON sjd.job_id = jpf.job_id
    INNER JOIN 
        skills_dim AS sd ON sd.skill_id = sjd.skill_id
    WHERE
        jpf.job_title_short = 'Data Analyst' AND
        jpf.salary_year_avg IS NOT NULL AND
        jpf.job_work_from_home = TRUE
    GROUP BY
        sd.skill_id 
)

SELECT
     skill_id,
     skills,
     demand_count,
     avg_salary
FROM
    combined_skill_stats
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;
```
# What I Learned
- **High-Value Skills:** Certain specialized skills (like PySpark, Bitbucket, Couchbase) command exceptionally high salaries, indicating niche demand or advanced requirements.

- **Core Skills Remain Crucial:** SQL, Excel, and Python consistently appear as highly demanded skills, reinforcing their foundational importance in Data Analyst roles, even if their average salaries aren't the absolute highest.

- **Remote Work Landscape:** The analysis specifically highlights trends in remote data analyst jobs, which is crucial in the current job market.

- **Balancing Demand and Pay:** The "optimal skills" analysis helps in identifying skills that offer a good balance of high demand and competitive salaries, guiding career development effectively.
# Conclusions
This project provides a data-driven approach to understanding the Data Analyst job market, particularly for remote positions. The insights gained can help aspiring and current Data Analysts make informed decisions about skill development and job searching strategies. Future work could involve analyzing geographical differences, industry-specific trends, and the impact of experience levels on salary and skill demand.
