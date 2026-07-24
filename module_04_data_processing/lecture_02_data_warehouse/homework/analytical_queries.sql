-- Топ-10 клиентов по общей сумме net_revenue
SELECT
    c.first_name || ' ' || c.last_name AS customer_name,
    SUM(fs.net_revenue) AS total_spent,
    COUNT(fs.sales_sk) AS order_count,
    AVG(fs.net_revenue) AS avg_check
FROM gold.fact_sales fs
JOIN gold.dim_customer c ON fs.customer_sk = c.customer_sk
GROUP BY c.customer_sk, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;

-- Топ-10 товаров по общему количеству проданных единиц
SELECT
    p.product_name,
    SUM(fs.quantity) AS total_quantity,
    SUM(fs.net_revenue) AS revenue,
    ROUND(AVG(fs.net_revenue / NULLIF(fs.quantity, 0)), 2) AS avg_price
FROM gold.fact_sales fs
JOIN gold.dim_product p ON fs.product_sk = p.product_sk
GROUP BY p.product_sk, p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- Средний чек по магазинам и по городам
SELECT
    sh.address AS shop_address,
    loc.city_name,
    COUNT(fs.sales_sk) AS transactions,
    ROUND(AVG(fs.net_revenue), 2) AS avg_check,
    SUM(fs.net_revenue) AS total_revenue
FROM gold.fact_sales fs
JOIN gold.dim_shop sh ON fs.shop_sk = sh.shop_sk
JOIN gold.dim_location loc ON sh.location_sk = loc.location_sk
GROUP BY sh.shop_sk, sh.address, loc.city_name
ORDER BY avg_check DESC;

-- Суммарная выручка по месяцам и категориям
SELECT
    d.year_num,
    d.month_name,
    cat.category_name,
    SUM(fs.net_revenue) AS total_net_revenue,
    COUNT(fs.sales_sk) AS transaction_count
FROM gold.fact_sales fs
JOIN gold.dim_date d ON fs.date_sk = d.date_sk
JOIN gold.dim_product p ON fs.product_sk = p.product_sk
JOIN gold.dim_category cat ON p.category_sk = cat.category_sk
GROUP BY d.year_num, d.month_name, cat.category_name
ORDER BY d.year_num, d.month_num, total_net_revenue DESC;