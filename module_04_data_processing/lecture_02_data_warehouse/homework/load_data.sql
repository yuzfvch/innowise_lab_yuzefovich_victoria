BEGIN;

CREATE TABLE IF NOT EXISTS gold.load_control (
    last_loaded_sales_id INTEGER DEFAULT 0,
    last_load_timestamp TIMESTAMP DEFAULT NOW()
);


TRUNCATE TABLE gold.dim_customer CASCADE;
TRUNCATE TABLE gold.dim_employee CASCADE;
TRUNCATE TABLE gold.dim_shop CASCADE;
TRUNCATE TABLE gold.dim_product CASCADE;
TRUNCATE TABLE gold.dim_category CASCADE;
TRUNCATE TABLE gold.dim_location CASCADE;
TRUNCATE TABLE gold.dim_date CASCADE;


INSERT INTO gold.dim_date (date_sk, full_date, day_of_week, week_num, month_num, month_name, quarter_num, year_num)
SELECT
    (EXTRACT(YEAR FROM days.d) * 10000 + EXTRACT(MONTH FROM days.d) * 100 + EXTRACT(DAY FROM days.d))::INTEGER,
    days.d,
    EXTRACT(ISODOW FROM days.d)::INTEGER,
    EXTRACT(WEEK FROM days.d)::INTEGER,
    EXTRACT(MONTH FROM days.d)::INTEGER,
    TO_CHAR(days.d, 'Month'),
    EXTRACT(QUARTER FROM days.d)::INTEGER,
    EXTRACT(YEAR FROM days.d)::INTEGER
FROM (
    SELECT generate_series(
        (SELECT MIN(sales_timestamp)::DATE FROM silver.silver_sales),
        (SELECT MAX(sales_timestamp)::DATE FROM silver.silver_sales),
        '1 day'::INTERVAL
    ) AS d
) AS days;

INSERT INTO gold.dim_location (country_id, country_name, country_code, city_id, city_name, zipcode)
SELECT DISTINCT
    cnt.country_id,
    cnt.country_name,
    cnt.country_code,
    c.city_id,
    c.city_name,
    c.zipcode
FROM silver.silver_cities c
JOIN silver.silver_countries cnt ON c.country_id = cnt.country_id;

INSERT INTO gold.dim_category (category_id, category_name)
SELECT DISTINCT category_id, category_name
FROM silver.silver_categories
WHERE category_id IS NOT NULL;

INSERT INTO gold.dim_product (
    product_id, product_name, price, category_sk, class,
    modify_timestamp, resistant, is_allergic, vitality_days
)
SELECT DISTINCT ON (p.product_id)
    p.product_id,
    p.product_name,
    p.price,
    cat.category_sk,
    p.class,
    p.modify_timestamp,
    p.resistant,
    p.is_allergic,
    p.vitality_days
FROM silver.silver_products p
LEFT JOIN gold.dim_category cat ON p.category_id = cat.category_id
WHERE p.product_id IS NOT NULL
ORDER BY p.product_id, p.modify_timestamp DESC NULLS LAST;

INSERT INTO gold.dim_shop (shop_id, address, location_sk)
SELECT DISTINCT
    s.shop_id,
    s.address,
    loc.location_sk
FROM silver.silver_shops s
LEFT JOIN gold.dim_location loc ON s.city_id = loc.city_id
WHERE s.shop_id IS NOT NULL;

INSERT INTO gold.dim_employee (
    employee_id, first_name, middle_name, last_name,
    birth_date, gender, hire_date, shop_sk,
    valid_from_dt, valid_to_dt, is_current
)
SELECT DISTINCT ON (e.employee_id)
    e.employee_id,
    e.first_name,
    e.middle_initial,
    e.last_name,
    e.birth_date,
    e.gender,
    e.hire_date,
    sh.shop_sk,
    '1900-01-01'::DATE,
    '9999-12-31'::DATE,
    TRUE
FROM silver.silver_employees e
LEFT JOIN gold.dim_shop sh ON e.shop_id = sh.shop_id
WHERE e.employee_id IS NOT NULL
ORDER BY e.employee_id, e.hire_date DESC NULLS LAST;

INSERT INTO gold.dim_customer (
    customer_id, first_name, middle_initial, last_name, address, location_sk
)
SELECT DISTINCT ON (c.customer_id)
    c.customer_id,
    c.first_name,
    c.middle_initial,
    c.last_name,
    c.address,
    loc.location_sk
FROM silver.silver_customers c
LEFT JOIN gold.dim_location loc ON c.city_id = loc.city_id
WHERE c.customer_id IS NOT NULL
ORDER BY c.customer_id;

WITH last_load AS (
    SELECT COALESCE(MAX(last_loaded_sales_id), 0) AS max_id
    FROM gold.load_control
)
INSERT INTO gold.fact_sales (
    sales_id,
    product_sk,
    customer_sk,
    shop_sk,
    employee_sk,
    date_sk,
    location_sk,
    total_revenue,
    discount_amount,
    net_revenue,
    quantity,
    profit,
    margin
)
SELECT
    s.sales_id,
    p.product_sk,
    c.customer_sk,
    sh.shop_sk,
    e.employee_sk,
    (EXTRACT(YEAR FROM s.sales_timestamp::DATE) * 10000 +
     EXTRACT(MONTH FROM s.sales_timestamp::DATE) * 100 +
     EXTRACT(DAY FROM s.sales_timestamp::DATE))::INTEGER AS date_sk,
    loc.location_sk,
    s.total_price,
    s.total_price * (s.discount / 100.0) AS discount_amount,
    s.total_price - (s.total_price * (s.discount / 100.0)) AS net_revenue,
    s.quantity,
    NULL AS profit,
    NULL AS margin
FROM silver.silver_sales s
JOIN gold.dim_product p ON s.product_id = p.product_id
JOIN gold.dim_customer c ON s.customer_id = c.customer_id
JOIN gold.dim_shop sh ON s.shop_id = sh.shop_id
JOIN gold.dim_employee e ON s.employee_id = e.employee_id AND e.is_current = TRUE
JOIN gold.dim_location loc ON sh.location_sk = loc.location_sk
WHERE s.sales_id > (SELECT max_id FROM last_load);

UPDATE gold.load_control
SET
    last_loaded_sales_id = (SELECT COALESCE(MAX(sales_id), 0) FROM gold.fact_sales),
    last_load_timestamp = NOW();
SELECT 'dim_date' AS table_name, COUNT(*) AS rows FROM gold.dim_date
UNION ALL
SELECT 'dim_location', COUNT(*) FROM gold.dim_location
UNION ALL
SELECT 'dim_category', COUNT(*) FROM gold.dim_category
UNION ALL
SELECT 'dim_product', COUNT(*) FROM gold.dim_product
UNION ALL
SELECT 'dim_shop', COUNT(*) FROM gold.dim_shop
UNION ALL
SELECT 'dim_employee', COUNT(*) FROM gold.dim_employee
UNION ALL
SELECT 'dim_customer', COUNT(*) FROM gold.dim_customer
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM gold.fact_sales;

SELECT 'last_loaded_sales_id' AS info, last_loaded_sales_id, last_load_timestamp
FROM gold.load_control;

COMMIT;