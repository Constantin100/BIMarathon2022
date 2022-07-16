-- create database bi_marathon_constantin;
-- use bi_marathon_constantin;

CREATE TABLE temp_table (
	id INT NOT NULL,
    created VARCHAR(50),
	modified VARCHAR(50),
	job_id VARCHAR(255),
	job_title VARCHAR(255),
	inferred_job_title VARCHAR(255),
	url VARCHAR(255),
	category VARCHAR(255),
	job_board VARCHAR(20),
	post_date VARCHAR(50),
	salary_offered VARCHAR(255),
	annual_salary VARCHAR(100),
    hourly_salary VARCHAR(100),
	inc_benefit VARCHAR(100),
	inferred_salary_currency VARCHAR(20),
	inferred_salary_from VARCHAR(20),
	inferred_salary_to VARCHAR(20),
	is_remote BIT,
    inferred_seniority_level VARCHAR(100),
    inferred_salary_time_unit VARCHAR(50),
    inferred_max_experience VARCHAR(100),
    inferred_min_experience VARCHAR(100),
    company_id INT NOT NULL,
    indexed_to_es VARCHAR(20),
    inferred_yearly_from VARCHAR(20), 
    inferred_yearly_to VARCHAR(20),
    sign_on_bonuses VARCHAR(20),
    city_id INT NOT NULL,
    country_id INT NOT NULL,
    state_id INT NOT NULL,
    html_job_description VARCHAR(20),
    company_name VARCHAR(20),
    company_lat VARCHAR(255),
    company_lon VARCHAR(255),
    country VARCHAR(100),
    inferred_country VARCHAR(100),
    country_max_pay_range INT,
    country_min_pay_range INT,
    state VARCHAR(100),
    inferred_state VARCHAR(100),
    city VARCHAR(100),
    inferred_city VARCHAR(100)
);








