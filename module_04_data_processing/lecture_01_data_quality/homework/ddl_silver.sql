CREATE SCHEMA silver;

CREATE TABLE silver.silver_countries(
	country_id INTEGER,
	country_name VARCHAR(50),
	country_code VARCHAR(3)
);

CREATE TABLE silver.silver_cities(
	city_id INTEGER,
	city_name VARCHAR(50),
	zipcode INTEGER,
	country_id INTEGER
);

CREATE TABLE silver.silver_categories(
	category_id INTEGER,
	category_name VARCHAR(50)
);

CREATE TABLE silver.silver_products(
	product_id INTEGER,
	product_name VARCHAR(50),
	price NUMERIC(10, 2),
	category_id INTEGER,
	class VARCHAR(1),
	modify_timestamp timestamp,
	resistant BOOLEAN, 
	is_allergic BOOLEAN,
	vitality_days INTEGER
);

CREATE TABLE silver.silver_shops(
	shop_id INTEGER,
	address VARCHAR(50),
	city_id INTEGER
);

CREATE TABLE silver.silver_employees(
	employee_id INTEGER,
	first_name VARCHAR(50),
	middle_initial VARCHAR(1),
	last_name VARCHAR(50),
	birth_date DATE,
	gender VARCHAR(1),
	city_id INTEGER,
	shop_id INTEGER,
	hire_date DATE
);

CREATE TABLE silver.silver_customers(
	customer_id INTEGER,
	first_name VARCHAR(50),
	middle_initial VARCHAR(1),
	last_name VARCHAR(50),
	address VARCHAR(50),
	city_id INTEGER
);

CREATE TABLE silver.silver_sales(
	sales_id INTEGER,
	employee_id INTEGER,
	customer_id INTEGER,
	product_id INTEGER,
	quantity INTEGER,
	discount NUMERIC(10, 2),
	total_price NUMERIC(10, 2),
	sales_timestamp TIMESTAMP,
	transaction_number VARCHAR(20),
	city_id INTEGER,  
    shop_id INTEGER
	
);