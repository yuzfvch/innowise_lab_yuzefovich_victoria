UPDATE products 
SET price = price + price * 0.1
WHERE category_id = (SELECT category_id FROM categories WHERE category_name = 'Fruits');


DELETE FROM employees  
WHERE employee_id NOT IN (
	SELECT DISTINCT employee_id
	FROM sales
	WHERE employee_id IS NOT null
);

BEGIN;
	INSERT INTO employees VALUES (321, 'Carla', 'T', 'Franklin', '1989-11-04', 'F', 21, 53, '2019-08-16');
	INSERT INTO 
		sales (employee_id, customer_id, product_id, quantity, discount, total_price, sales_timestamp, transaction_number) 
	VALUES 
		(321, 9148, 47, 1, 0.09, 43.76, '2023-11-19 18:22:40', 'T00002591550');
		
END;



