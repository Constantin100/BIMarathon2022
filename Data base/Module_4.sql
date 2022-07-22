-- SELECT job_id, country_id, state_id, city_id, 
-- 	COUNT(*) AS CNT
-- FROM fact_pay_range
-- 	GROUP BY job_id, country_id, state_id, city_id
-- HAVING COUNT(*) > 1;
    
    
-- INSERT INTO fact_pay_range (inferred_salary_from,inferred_salary_to,inferred_yearly_from,inferred_yearly_to,job_id,
-- 							currency_id,salary_time_unit_id,country_id,state_id,city_id,post_date)
-- 	SELECT inferred_salary_from,inferred_salary_to,inferred_yearly_from,inferred_yearly_to,job_id,
-- 		currency_id,salary_time_unit_id,country_id,state_id,city_id,post_date
--         FROM fact_pay_range fpr
--         WHERE fpr.id IN (1,2,3,5,6,7,8,9,10);
-- ==============================================     

-- WITH CTE(id, job_id, country_id, state_id, city_id, duplicateCount)
-- 	AS (SELECT id, job_id, country_id, state_id, city_id,
-- 				(ROW_NUMBER() OVER(PARTITION BY job_id, country_id, state_id, city_id))
-- 				 AS duplicateCount
-- 			FROM fact_pay_range
--             ORDER BY id)
--             SELECT * FROM CTE
--             WHERE duplicateCount > 1
--             ;
            
-- 	AS (SELECT id, job_id, country_id, state_id, city_id,
-- 				(ROW_NUMBER() OVER(PARTITION BY job_id, country_id, state_id, city_id))
-- 				 AS duplicateCount
-- 			FROM fact_pay_range)
--             DELETE FROM fact_pay_range 
--             WHERE job_id IN 
-- 							(SELECT job_id FROM CTE
-- 								WHERE duplicateCount > 1)
-- ;

-- =======================================================================

-- SELECT *, 
-- 		CASE
-- 			WHEN fpr.currency_id = 1 THEN 'USD'
--             WHEN fpr.currency_id = 2 THEN 'GBP'
-- 		ELSE 'Unknouwn corrency' END AS 'currency' 
-- 	FROM fact_pay_range fpr
-- ;

-- 	SELECT job_id, country_id, state_id, city_id,
-- 			coalesce(state_id, 'Unknown') AS state
-- 		FROM fact_pay_range
-- 		WHERE id IN (1,2,3,4,5,6,7,8,9,10);

-- 	SELECT job_id, country_id, state_id, city_id,
-- 			NULLIF(state_id, 39) AS state
-- 		FROM fact_pay_range
-- 		WHERE id IN (1,2,3,4,5,6,7,8,9,10);

-- 	SELECT job_id, country_id, state_id, city_id,
-- 			GREATEST(40, state_id) AS state
-- 		FROM fact_pay_range
-- 		WHERE id IN (1,2,3,4,5,6,7,8,9,10);

-- 	SELECT job_id, country_id, state_id, city_id,
-- 			LEAST(30, state_id) AS state
-- 		FROM fact_pay_range
-- 		WHERE id IN (1,2,3,4,5,6,7,8,9,10);

-- 	SELECT DISTINCT city_id
-- 		FROM fact_pay_range
-- ;

	



