SELECT e.employee_id,
	e.first_name,
	count(s.sales_id) AS total_sales_count
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id 
GROUP BY e.employee_id, e.first_name
HAVING count(s.sales_id) > 1000;

UPDATE products p
SET "class" = 'A'
WHERE category_id IN (SELECT p.category_id
						FROM products p
						JOIN sales s ON s.product_id = p.product_id
						GROUP BY category_id
						HAVING sum(s.total_price) > 5000
);

UPDATE products p 
SET modify_timestamp = NOW()
WHERE p.modify_timestamp IS NULL;
