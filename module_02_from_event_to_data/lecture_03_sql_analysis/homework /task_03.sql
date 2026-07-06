SELECT 
	country_name, count(shop_id) AS shops_count 
FROM 
	countries c 
JOIN 
	cities ON cities.country_id = c.country_id 
JOIN 
	shops sh ON sh.city_id = cities.city_id 
GROUP BY 
	country_name
ORDER BY shops_count DESC;