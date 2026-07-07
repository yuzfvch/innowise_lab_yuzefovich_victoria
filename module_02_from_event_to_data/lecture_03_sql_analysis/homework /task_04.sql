SELECT 
	product_name, SUM(s.total_price) AS total_revenue, AVG(s.total_price) AS avg_sale 
FROM 
	products p
JOIN 
	sales s ON s.product_id = p.product_id 
GROUP BY 
	product_name 
HAVING SUM(s.total_price) > 400000.00
ORDER BY SUM(s.total_price) DESC 
LIMIT 10;