CREATE SCHEMA IF NOT EXISTS gold;

CREATE TABLE gold.dim_date (
    date_sk        INTEGER PRIMARY KEY,
    full_date      DATE NOT NULL,
    day_of_week    integer,
    week_num       INTEGER,
    month_num      INTEGER,
    month_name     VARCHAR(20),
    quarter_num    INTEGER,
    year_num       INTEGER
);


CREATE TABLE gold.dim_location (
    location_sk    SERIAL PRIMARY KEY,
    country_id     INTEGER NOT NULL,
    country_name   VARCHAR(100),
    country_code   VARCHAR(3),
    city_id        integer,
    city_name      VARCHAR(100),
    zipcode        INTEGER,
    CONSTRAINT uq_location_city UNIQUE (city_id, country_id)
);


CREATE TABLE gold.dim_category (
    category_sk    SERIAL PRIMARY KEY,
    category_id    INTEGER NOT NULL,
    category_name  VARCHAR(100),
    CONSTRAINT uq_category_id UNIQUE (category_id)
);

CREATE TABLE gold.dim_product (
    product_sk      SERIAL PRIMARY KEY,
    product_id      INTEGER NOT NULL,
    product_name    VARCHAR(100),
    price           NUMERIC(10,2),
    category_sk     INTEGER, 
    class           VARCHAR(1),
    modify_timestamp TIMESTAMP,
    resistant       BOOLEAN,
    is_allergic     BOOLEAN,
    vitality_days   INTEGER,
    CONSTRAINT uq_product_id UNIQUE (product_id)
);


CREATE TABLE gold.dim_shop (
    shop_sk         SERIAL PRIMARY KEY,
    shop_id         INTEGER NOT NULL,
    address         VARCHAR(200),
    location_sk     INTEGER, 
    CONSTRAINT uq_shop_id UNIQUE (shop_id)
);


CREATE TABLE gold.dim_employee (
    employee_sk     SERIAL PRIMARY KEY,
    employee_id     INTEGER NOT NULL,
    first_name      VARCHAR(50),
    middle_name     VARCHAR(50),
    last_name       VARCHAR(50),
    birth_date      DATE,
    gender          VARCHAR(1),
    hire_date       DATE,
    shop_sk         INTEGER, 
    valid_from_dt   DATE NOT NULL DEFAULT '1900-01-01',
    valid_to_dt     DATE NOT NULL DEFAULT '9999-12-31',
    is_current      BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_hire_after_birth CHECK (hire_date > birth_date),
    CONSTRAINT chk_valid_dates CHECK (valid_from_dt < valid_to_dt)
);


CREATE TABLE gold.dim_customer (
    customer_sk     SERIAL PRIMARY KEY,
    customer_id     INTEGER NOT NULL,
    first_name      VARCHAR(50),
    middle_initial  VARCHAR(1),
    last_name       VARCHAR(50),
    address         VARCHAR(100),
    location_sk     INTEGER, 
    CONSTRAINT uq_customer_id UNIQUE (customer_id)
);


CREATE TABLE gold.fact_sales (
    sales_sk          BIGSERIAL PRIMARY KEY,
    sales_id          INTEGER NOT NULL,
    product_sk        INTEGER NOT NULL REFERENCES gold.dim_product(product_sk),
    customer_sk       INTEGER NOT NULL REFERENCES gold.dim_customer(customer_sk),
    shop_sk           INTEGER NOT NULL REFERENCES gold.dim_shop(shop_sk),
    employee_sk       INTEGER NOT NULL REFERENCES gold.dim_employee(employee_sk),
    date_sk           INTEGER NOT NULL REFERENCES gold.dim_date(date_sk),
    location_sk       INTEGER NOT NULL REFERENCES gold.dim_location(location_sk),
    total_revenue     NUMERIC(10,2) NOT NULL CHECK (total_revenue >= 0),
    discount_amount   NUMERIC(10,2) DEFAULT 0,
    net_revenue       NUMERIC(10,2) NOT NULL,
    quantity          INTEGER NOT NULL CHECK (quantity > 0),
    profit            NUMERIC(10,2),  
    margin            NUMERIC(5,2),     
    CONSTRAINT uq_sales_id UNIQUE (sales_id)  
);