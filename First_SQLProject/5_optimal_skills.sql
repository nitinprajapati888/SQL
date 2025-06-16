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
        sd.skill_id -- Assumes skill_id is the primary key of skills_dim, making skills functionally dependent.
                    -- This matches the grouping logic of the original query.
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