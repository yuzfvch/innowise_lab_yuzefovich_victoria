WITH monthly_revenue AS (
    SELECT 
        DATE_TRUNC('month', s.sales_timestamp::timestamp) AS sale_month,
        SUM(s.total_price) AS monthly_revenue
    FROM sales s
    JOIN employees e ON s.employee_id = e.employee_id
    JOIN shops sh ON e.shop_id = sh.shop_id
    JOIN cities c ON sh.city_id = c.city_id
    JOIN countries cnt ON c.country_id = cnt.country_id
    WHERE cnt.country_name = 'Germany'
      AND s.sales_timestamp IS NOT NULL
      AND s.sales_timestamp <> ''
    GROUP BY sale_month
)
SELECT 
    sale_month,
    monthly_revenue,
    COALESCE(LAG(monthly_revenue) OVER (ORDER BY sale_month), 0) AS previous_month_revenue,
    monthly_revenue - COALESCE(LAG(monthly_revenue) OVER (ORDER BY sale_month), 0) AS revenue_diff_vs_previous
FROM monthly_revenue
ORDER BY sale_month;