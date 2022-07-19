-- select * FROM temp_table
-- -------------------------------------------------------
-- create table dim_job_category (
-- 	job_category_id INT NOT NULL auto_increment
--     , job_category_name VARCHAR(255)
--     , PRIMARY KEY (job_category_id)
-- );

-- INSERT IGNORE INTO dim_job_category (job_category_name)
-- 	SELECT DISTINCT tmp.category
-- 		FROM temp_table tmp
-- ;
-- select * FROM dim_job_category;
-- -------------------------------------------------------
-- create table dim_currency (
-- 	currency_id INT NOT NULL auto_increment
--     , currency_name VARCHAR(20)
--     , PRIMARY KEY (currency_id)
-- );

-- INSERT IGNORE INTO dim_currency (currency_name)
-- 	SELECT DISTINCT tmp.inferred_salary_currency
--  		FROM temp_table tmp
-- ;
-- select * FROM dim_currency
-- -------------------------------------------------------
-- create table dim_inferred_salary_time_unit (
-- 	id INT NOT NULL auto_increment
--     , inferred_salary_time_unit_name VARCHAR(50)
--     , PRIMARY KEY (id)
-- );
-- INSERT IGNORE INTO dim_inferred_salary_time_unit (inferred_salary_time_unit_name)
-- 	SELECT DISTINCT tmp.inferred_salary_time_unit
--  		FROM temp_table tmp
-- ;
-- select * FROM dim_inferred_salary_time_unit
-- -------------------------------------------------------

-- create table dim_country (
-- 	country_id INT NOT NULL
--     , country_name VARCHAR(100)
--     , PRIMARY KEY (country_id)
-- );

-- INSERT IGNORE INTO dim_country (country_id, country_name)
-- 	SELECT DISTINCT tmp.country_id, country
--  		FROM temp_table tmp
-- ;

-- ALTER TABLE dim_country ADD country_short_name VARCHAR(100);

-- select * FROM dim_country;
-- -------------------------------------------------------

-- create table dim_state (
-- 	state_id INT NOT NULL
-- 	, country_id INT NOT NULL
--     , state_name VARCHAR(100) NOT NULL
-- 	, state_short_name VARCHAR(100)
--     , PRIMARY KEY (state_id)
-- 	, FOREIGN KEY (country_id)
--         REFERENCES dim_country (country_id)
--         ON DELETE CASCADE
-- );

-- INSERT IGNORE INTO dim_state (state_id, country_id, state_name, state_short_name)
-- 	SELECT DISTINCT tmp.state_id, tmp.country_id,  tmp.inferred_state, tmp.state
--  		FROM temp_table tmp
-- ;
-- select * FROM dim_state;

-- -------------------------------------------------------
-- CREATE TABLE dim_city (
-- 	city_id INT NOT NULL
-- 	, country_id INT NOT NULL
-- 	, state_id INT NOT NULL
--     , city_name VARCHAR(150) NOT NULL
-- 	, city_short_name VARCHAR(150) 
--     , PRIMARY KEY (city_id)
-- 	, FOREIGN KEY (country_id)
--         REFERENCES dim_country (country_id)
--         ON DELETE CASCADE
-- 	, FOREIGN KEY (state_id)
-- 		REFERENCES dim_state (state_id)
-- 		ON DELETE CASCADE
-- );

-- INSERT IGNORE INTO dim_city (city_id, country_id, state_id, city_name, city_short_name)
-- 	SELECT DISTINCT tmp.city_id, tmp.country_id, tmp.state_id, tmp.inferred_city, tmp.city
--  		FROM temp_table tmp
-- ;
-- TRUNCATE TABLE dim_city;
-- select * FROM dim_city;

-- -------------------------------------------------------
-- create table dim_company (
-- 	company_id INT NOT NULL
--     , company_name VARCHAR(255) NOT NULL
-- 	, company_lat FLOAT
-- 	, company_lon FLOAT 
--     , PRIMARY KEY (company_id)
-- );

-- INSERT IGNORE INTO dim_company (company_id, company_name, company_lat, company_lon)
-- 	SELECT DISTINCT tmp.company_id, tmp.company_name, tmp.company_lat, tmp.company_lon
--  		FROM temp_table tmp
-- ;

-- select * FROM dim_company;
-- -------------------------------------------------------

-- create table dim_job (
-- 	id INT NOT NULL auto_increment
-- 	, job_id VARCHAR (255) NOT NULL 
-- 	, job_type  VARCHAR(100)
-- 	, job_title VARCHAR(255)
--     , inferred_job_title VARCHAR(255)
-- 	, job_board VARCHAR(20) 
-- 	, inferred_seniority_level VARCHAR(100) 
-- 	, job_category_id INT 
-- 	, company_id INT NOT NULL
--     , PRIMARY KEY (id)
-- 	, FOREIGN KEY (job_category_id)
--         REFERENCES dim_job_category (job_category_id)
--         ON DELETE SET NULL
-- 	, FOREIGN KEY (company_id)
-- 		REFERENCES dim_company (company_id)
-- 		ON DELETE CASCADE
-- );

-- INSERT IGNORE INTO dim_job (job_id, job_type, job_title, inferred_job_title, 
-- 							job_board, inferred_seniority_level, job_category_id, company_id)
-- 	SELECT DISTINCT 		tmp.job_id, tmp.job_type, tmp.job_title, tmp.inferred_job_title, 
-- 							tmp.job_board, tmp.inferred_seniority_level, djc.job_category_id, tmp.company_id
--  		FROM temp_table tmp
-- 			INNER JOIN dim_job_category djc ON tmp.category = djc.job_category_name
-- ;

-- SELECT * FROM dim_job;
-- -------------------------------------------------------

-- create table fact_pay_range (
--  	id INT NOT NULL auto_increment
-- 	, inferred_salary_from DECIMAL
--     , inferred_salary_to DECIMAL
-- 	, inferred_yearly_from DECIMAL
-- 	, inferred_yearly_to DECIMAL
--   	, job_id INT NOT NULL
-- 	, currency_id INT NOT NULL
--     , salary_time_unit_id INT NULL
--   	, country_id INT NOT NULL
--     , state_id INT NULL
--     , city_id INT NOT NULL
--     , post_date DATETIME
--     , PRIMARY KEY (id)
-- 	, FOREIGN KEY (job_id)
--         REFERENCES dim_job (id)
--         ON DELETE CASCADE
--  	, FOREIGN KEY (currency_id)
--  		REFERENCES dim_currency (currency_id)
--  		ON DELETE CASCADE
-- 	, FOREIGN KEY (salary_time_unit_id)
-- 		REFERENCES dim_inferred_salary_time_unit (id)
-- 		ON DELETE SET NULL
-- 	, FOREIGN KEY (country_id)
-- 		REFERENCES dim_country (country_id)
-- 		ON DELETE CASCADE
-- 	, FOREIGN KEY (state_id)
-- 		REFERENCES dim_state (state_id)
-- 		ON DELETE SET NULL
-- 	, FOREIGN KEY (city_id)
-- 		REFERENCES dim_city (city_id)
-- 		ON DELETE CASCADE
--  );

-- INSERT IGNORE INTO fact_pay_range (inferred_salary_from, inferred_salary_to, inferred_yearly_from, inferred_yearly_to,
-- 							job_id, currency_id, salary_time_unit_id, country_id, state_id, city_id, post_date)
-- 	SELECT DISTINCT 		tmp.inferred_salary_from, tmp.inferred_salary_to, tmp.inferred_yearly_from, tmp.inferred_yearly_to, 
-- 							dj.id, dc.currency_id, tu.id, dctr.country_id, dstt.state_id, dct.city_id, CONVERT(tmp.created, signed)
--  		FROM temp_table tmp
-- 			INNER JOIN dim_job dj ON tmp.job_id = dj.job_id
--             INNER JOIN dim_currency dc ON tmp.inferred_salary_currency = dc.currency_name
--             INNER JOIN dim_inferred_salary_time_unit tu ON tmp.inferred_salary_time_unit = tu.inferred_salary_time_unit_name
--             INNER JOIN dim_city dct ON tmp.city_id = dct.city_id
--             INNER JOIN dim_state dstt ON dct.state_id = dstt.state_id
--             INNER JOIN dim_country dctr ON dct.country_id = dctr.country_id
-- ;

-- SELECT * FROM fact_pay_range;


 

