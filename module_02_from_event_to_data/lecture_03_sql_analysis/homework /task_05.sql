SELECT 
	e.first_name, e.last_name, sh.address, s.total_price AS max_amount 
FROM customers c
JOIN 
	sales s ON s.customer_id = c.customer_id 
JOIN 
	employees e ON e.employee_id = s.employee_id
JOIN 
	shops sh ON e.shop_id = sh.shop_id
WHERE 
	s.total_price = (SELECT max(total_price)
					FROM sales)
	
					
