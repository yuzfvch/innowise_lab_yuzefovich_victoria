WITH shop_aggregates AS (
	SELECT sh.shop_id, 
		cnt.country_name,  
		sh.address,
		COUNT(s.sales_id) AS total_sales_count, 
		SUM(s.total_price) AS total_sales_amount
	FROM 
		sales s
	JOIN 
		employees e ON e.employee_id = s.employee_id 
	JOIN 
		shops sh ON sh.shop_id = e.shop_id 
	JOIN 
		cities c ON c.city_id = sh.city_id 
	JOIN 
		countries cnt ON cnt.country_id = c.country_id
	GROUP BY sh.shop_id, sh.address, cnt.country_name
	HAVING COUNT(sales_id) >= 2
)
SELECT country_name,
	shop_id,
	address AS shop_address,
	total_sales_count, 
	total_sales_amount,
	SUM(total_sales_amount) OVER (PARTITION BY country_name) AS country_total,
	total_sales_amount / SUM(total_sales_amount) OVER (PARTITION BY country_name) AS country_sales_share,
	RANK() OVER (PARTITION BY country_name ORDER BY total_sales_amount DESC) AS rank_in_country,
    SUM(total_sales_amount) OVER (PARTITION BY country_name ORDER BY total_sales_amount DESC ROWS UNBOUNDED PRECEDING) AS country_running_total
 FROM shop_aggregates 
 ORDER BY country_name, rank_in_country;