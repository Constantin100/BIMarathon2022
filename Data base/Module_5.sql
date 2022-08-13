-- 1
-- str_to_date
UPDATE fact_pay_range SET post_date = 
(SELECT str_to_date(tt.created, '%m/%d/%Y %h:%i')
	FROM temp_table tt
		INNER JOIN dim_job dj ON tt.job_id = dj.job_id
    WHERE dj.id = fact_pay_range.job_id);

-- =======================================================
-- 2
-- a -- CTE
WITH state_ids AS ( SELECT state_id, state_name
						FROM dim_state
					WHERE state_short_name IN ('TX', 'CA', 'OH')
)
SELECT MAX(inferred_yearly_from) AS max_inferred_income, si.state_name
	FROM fact_pay_range fpr
		INNER JOIN state_ids si ON fpr.state_id = si.state_id
WHERE fpr.state_id IN (SELECT state_id FROM state_ids)
	GROUP BY si.state_name;
-- -------------------------------------------------------
-- c -- PIVOTING
SELECT  
		ds.state_name
        , MAX(CASE WHEN dj.job_type = 'Contract' THEN ( inferred_yearly_to) END) AS 'contract max payment per year'
		, MAX(CASE WHEN dj.job_type = 'Full Time' THEN ( inferred_yearly_to) END) AS 'Full Time max payment per year'
        , MAX(CASE WHEN dj.job_type = 'Part Time' THEN ( inferred_yearly_to) END) AS 'Part Time max payment per year'
        , MAX(CASE WHEN dj.job_type = 'Volunteer' THEN ( inferred_yearly_to) END) AS 'Volunteer max payment per year'
        , MAX(CASE WHEN dj.job_type = 'Undefined' THEN ( inferred_yearly_to) END) AS 'Undefined type of employment'
	FROM fact_pay_range fpr
			INNER JOIN dim_job dj ON fpr.job_id = dj.id
            INNER JOIN dim_state ds ON fpr.state_id = ds.state_id
            WHERE state_name = 'california'
        GROUP BY 1;
-- -------------------------------------------------------
-- e - WF
SELECT ds.state_name
		, fpr.inferred_yearly_to
        , DENSE_RANK() OVER (ORDER BY inferred_yearly_to DESC) AS rank_max_annual_salaries
	FROM fact_pay_range fpr
		INNER JOIN dim_state ds ON fpr.state_id = ds.state_id
	group by 2,1;
-- -------------------------------------------------------
-- h - EXCEPT
WITH state_ids (state_id, state_name) 
			AS ( SELECT state_id, state_name
 						FROM dim_state
 					WHERE state_short_name IN ('TX', 'CA', 'OH')
)
SELECT dc.country_name, ds.state_name, fpr.inferred_yearly_from, fpr.inferred_yearly_to, fpr.inferred_yearly_to
		FROM fact_pay_range fpr
			INNER JOIN dim_state ds ON fpr.state_id = ds.state_id
			LEFT JOIN dim_country dc ON fpr.country_id = dc.country_id
		WHERE fpr.country_id = 1 
EXCEPT -- NOT IN             
(
SELECT dc.country_name, ds.state_name, fpr.inferred_yearly_from, fpr.inferred_yearly_to, fpr.inferred_yearly_to
		FROM fact_pay_range fpr
			INNER JOIN dim_state ds ON fpr.state_id = ds.state_id
			LEFT JOIN dim_country dc ON fpr.country_id = dc.country_id
		WHERE fpr.country_id = 1
			AND fpr.state_id NOT IN (SELECT state_id FROM state_ids)
)
;
-- -------------------------------------------------------





