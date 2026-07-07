SELECT 
	sh.shop_id, sh.address, cities.city_name, countries.country_name
FROM 
	shops sh 
JOIN 
	cities ON  sh.city_id = cities.city_id 
JOIN 
	countries ON cities.country_id = countries.country_id
WHERE countries.country_name = 'Poland';




SELECT 
	transaction_number, p.product_name, total_price, customer_id, sales_timestamp
FROM 
	sales s 
JOIN 
	products p ON s.product_id = p.product_id
WHERE 
	total_price > 1500 AND p.class  = 'A'
ORDER BY 
	s.transaction_number
LIMIT 10;



