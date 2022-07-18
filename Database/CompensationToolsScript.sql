-- create database bi_marathon_constantin;
-- use bi_marathon_constantin;

CREATE TABLE temp_table (
	id INT NOT NULL,
    created VARCHAR(50),
	modified VARCHAR(50),
	job_id VARCHAR(255),
	job_title VARCHAR(255),
	inferred_job_title VARCHAR(255),
    job_type VARCHAR(100),
	url TEXT,
	category VARCHAR(255),
	job_board VARCHAR(20),
	post_date VARCHAR(50),
	salary_offered VARCHAR(255),
	annual_salary VARCHAR(100),
    hourly_salary VARCHAR(100),
	inc_benefit VARCHAR(100),
	inferred_salary_currency VARCHAR(20),
	inferred_salary_from DECIMAL,
	inferred_salary_to DECIMAL,
	is_remote INT,
    inferred_seniority_level VARCHAR(100),
    inferred_salary_time_unit VARCHAR(50),
    inferred_max_experience VARCHAR(100),
    inferred_min_experience VARCHAR(100),
    company_id INT NOT NULL,
    indexed_to_es VARCHAR(20),
    inferred_yearly_from DECIMAL, 
    inferred_yearly_to DECIMAL,
    sign_on_bonuses INT,
    city_id INT NOT NULL,
    country_id INT NOT NULL,
    state_id INT NOT NULL,
    html_job_description TEXT,
    company_name VARCHAR(255),
    company_lat DECIMAL,
    company_lon DECIMAL,
    country VARCHAR(100),
    inferred_country VARCHAR(100),
    country_max_pay_range INT,
    country_min_pay_range INT,
    country_pay_range_step INT,
    state VARCHAR(100),
    inferred_state VARCHAR(100),
    city VARCHAR(100),
    inferred_city VARCHAR(100)
);


create table dim_job_category (
	job_category_id INT NOT NULL auto_increment
    , job_category_name VARCHAR(500)
    , PRIMARY KEY (job_category_id)
);

create table dim_currency (
	currency_id INT NOT NULL auto_increment
    , currency_name VARCHAR(150)
    , PRIMARY KEY (currency_id)
);

create table dim_inferred_salary_time_unit (
	inferred_salary_time_unit_id INT NOT NULL auto_increment
    , inferred_salary_time_unit_name VARCHAR(150)
    , PRIMARY KEY (inferred_salary_time_unit_id)
);

create table dim_country (
	country_id INT NOT NULL
    , country_name VARCHAR(150)
    , PRIMARY KEY (country_id)
);

create table dim_state (
	state_id INT NOT NULL
	, country_id NOT
    , state_name VARCHAR(150) NOT NULL
	, state_short_name VARCHAR(150)
    , PRIMARY KEY (state_id)
	, FOREIGN KEY (country_id)
        REFERENCES dim_country (country_id)
        ON DELETE SET NULL
);

create table dim_city (
	city_id INT NOT NULL
	, country_id INT NOT NULL
	, state_id INT NOT NULL
    , city_name VARCHAR(150) NOT NULL
	, city_short_name VARCHAR(150) 
    , PRIMARY KEY (city_id)
	, FOREIGN KEY (country_id)
        REFERENCES dim_country (country_id)
        ON DELETE SET NULL
	, FOREIGN KEY (state_id)
		REFERENCES dim_state (state_id)
		ON DELETE SET NULL
);

create table dim_company (
	company_id INT NOT NULL
    , company_name VARCHAR(150) NOT NULL
	, company_lat VARCHAR(100) 
	, company_lon VARCHAR(100) 
    , PRIMARY KEY (company_id)
);

create table dim_job (
	job_id VARCHAR (255) NOT NULL 
	, job_type  VARCHAR(100)
	, job_title VARCHAR(255)
    , inferred_job_title VARCHAR(255)
	, job_board VARCHAR(20) 
	, inferred_seniority_level VARCHAR(100) 
	, job_category_id INT 
	, company_id INT
    , PRIMARY KEY (job_id)
	, FOREIGN KEY (job_category_id)
        REFERENCES job_category (job_category_id)
        ON DELETE SET NULL
	, FOREIGN KEY (company_id)
		REFERENCES dim_company (company_id)
		ON DELETE SET NULL
);


