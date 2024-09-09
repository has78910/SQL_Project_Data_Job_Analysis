/* Question:What are the most optimal skills to learn (aka it’s in high demand and a high-paying skill) for a data scientist?

- Identify skills in high demand and associated with high average salaries for Data Scientist roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data science
*/


WITH skills_demand AS (
    SELECT 
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) as demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim on skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
    job_title_short = 'Data Scientist'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
    GROUP BY
    skills_dim.skill_id
    
),


average_salary AS (
    SELECT 
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg),2) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
   
    WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = TRUE
    GROUP BY
    skills_job_dim.skill_id
    
)

SELECT 
skills_demand.skills,
skills_demand.demand_count,
average_salary.avg_salary

FROM 
skills_demand 
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id

ORDER BY
demand_count DESC,
avg_salary DESC
LIMIT 25




