-- MODULE 6
1. Show Total number of Job posts by each state
SELECT DISTINCT(ds.state_name)
	 , COUNT(*) OVER(PARTITION BY fpr.state_id) AS state_count_posts
	FROM fact_pay_range fpr
		 INNER JOIN dim_state ds ON fpr.state_id = ds.state_id
;


-- 1. Average salaries based on states ----------------------------
SELECT 	DISTINCT(ds.state_name)
		, ROUND(AVG((fpr.inferred_yearly_from + fpr.inferred_yearly_to)/2) OVER(PARTITION BY fpr.state_id), 2) AS average_annual_salaries
	FROM fact_pay_range fpr
 		 INNER JOIN dim_state ds ON fpr.state_id = ds.state_id
	ORDER BY average_salaries DESC
;


-- 1. Difference in % between average salaries and the max salary in that state ----------------------------
WITH max_salaries AS (
			SELECT 	DISTINCT(fpr1.state_id) AS state_id
				, MAX(fpr1.inferred_yearly_to) OVER(PARTITION BY fpr1.state_id) AS max
				FROM fact_pay_range fpr1
)
SELECT 	DISTINCT(ds.state_name)
		, ROUND(AVG((fpr.inferred_yearly_from + fpr.inferred_yearly_to)/2) OVER(PARTITION BY fpr.state_id), 2) AS average_annual_salaries
        , ROUND((AVG((fpr.inferred_yearly_from + fpr.inferred_yearly_to)/2) OVER(PARTITION BY fpr.state_id) * 100)/ms.max, 2) AS '% from max annual salary'
        , ms.max
	FROM fact_pay_range fpr
 		 INNER JOIN dim_state ds ON fpr.state_id = ds.state_id
         INNER JOIN max_salaries ms ON fpr.state_id = ms.state_id
	ORDER BY average_annual_salaries DESC
;


-- 2. The percentage of cities that have <20% of job posts. ------------------------------
WITH count_posts AS (
			SELECT COUNT(*) AS count
		FROM fact_pay_range
),
percent AS (
	SELECT DISTINCT(dc.city_name)
		, COUNT(fpr.id) OVER(PARTITION BY fpr.city_id) AS post_count_by_city
        , ROUND(COUNT(fpr.id) OVER(PARTITION BY fpr.city_id) * 100/cp.count, 2) AS percent_from_all_posts
    FROM fact_pay_range fpr
		INNER JOIN dim_city dc ON fpr.city_id = dc.city_id
        CROSS JOIN count_posts AS cp 
ORDER BY post_count_by_city DESC
)
SELECT * FROM percent 
	WHERE percent_from_all_posts < 20
;


-- 3. Selecting the top 3 job boards by the highest percentage of job titles making over 150K in salary annualy and have at least 10 job posts
WITH count_all_posts AS (
		SELECT DISTINCT(dj.job_board)
				, dj.id
				, COUNT(fpr.id) OVER(PARTITION BY dj.job_board) AS cnt
			FROM fact_pay_range fpr
				INNER JOIN dim_job dj ON fpr.job_id = dj.id
			ORDER BY cnt DESC
),
have AS (
	SELECT DISTINCT(dj.job_board) AS job_board
			, COUNT(fpr.id) OVER(PARTITION BY dj.job_board) AS count_posts
		FROM fact_pay_range fpr 
			INNER JOIN dim_job dj ON fpr.job_id = dj.id
		ORDER BY count_posts DESC
),
percent AS (
		SELECT DISTINCT(cap.job_board) AS job_board
				, ROUND(COUNT(fpr.id) OVER(PARTITION BY cap.job_board) * 100/cap.cnt, 2) AS percent_150_from_all_posts_by_board
			FROM  fact_pay_range fpr  
				INNER JOIN count_all_posts cap ON cap.id = fpr.job_id
                INNER JOIN have h ON cap.job_board = h.job_board
			WHERE fpr.inferred_yearly_to > 150000
				AND h.count_posts >=10
			ORDER BY percent_150_from_all_posts_by_board DESC
)

SELECT percent.job_board
	, percent_150_from_all_posts_by_board
    , DENSE_RANK() OVER (ORDER BY percent.percent_150_from_all_posts_by_board DESC) AS rank_max_percent
	FROM percent 
ORDER BY rank_max_percent
LIMIT 3
;
-- 4. Top 5 job salaries in US breaking down by job_type/time_unit (Top Annual and Top Hourly rates) - use subquery or CTE
-- WITH salaries AS (
--  SELECT dc.country_short_name, dj.job_title
-- 			, dj.job_type, dtu.inferred_salary_time_unit_name AS time_unit
--             , fpr.inferred_salary_to, fpr.inferred_yearly_to
-- 	FROM fact_pay_range fpr
-- 		INNER JOIN dim_job dj ON fpr.job_id = dj.id
--         INNER JOIN dim_inferred_salary_time_unit dtu ON fpr.salary_time_unit_id = dtu.id
--         INNER JOIN dim_country dc ON fpr.country_id = dc.country_id
-- 	WHERE dc.country_short_name = 'US'
-- 	-- ORDER BY 
-- )
-- SELECT s.country_short_name, s.job_title, s.job_type, s.time_unit
-- 		, MAX(s.inferred_salary_to) OVER(PARTITION BY s.time_unit) AS max
-- 	FROM salaries s 
--      -- WHERE s.time_unit = 'hourly'
--  GROUP BY s.job_type, s.time_unit
-- -- ORDER BY s.inferred_salary_to DESC 
-- -- UNION ALL
-- -- SELECT s.country_short_name, s.job_title, s.job_type, s.time_unit
-- -- 		, MAX(s.inferred_salary_to) OVER(PARTITION BY s.time_unit) AS max
-- -- 	FROM salaries s 
-- --     -- WHERE s.time_unit = 'yearly'
-- --  GROUP BY s.job_type, s.time_unit
-- -- -- ORDER BY s.inferred_salary_to DESC
-- ;
-- 	
-- 5. Find hirest salaries per city in UK. In your output show Job_board, City, salary
WITH t1 AS (
	SELECT dj.job_board, dcty.city_name, fpr.inferred_yearly_to 
		FROM fact_pay_range fpr
			INNER JOIN dim_city dcty ON fpr.city_id = dcty.city_id
			INNER JOIN dim_country dc ON dcty.country_id = dc.country_id
			INNER JOIN dim_job dj ON fpr.job_id = dj.id
		WHERE dc.country_short_name = 'UK'
	ORDER BY fpr.inferred_yearly_to DESC
)
SELECT DISTINCT(city_name)
		, job_board
        , MAX(inferred_yearly_to) OVER(PARTITION BY city_name) AS max_annual_sal
	FROM t1
    ORDER BY max_annual_sal DESC
;
	










