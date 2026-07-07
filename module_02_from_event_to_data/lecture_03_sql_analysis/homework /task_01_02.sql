INSERT INTO products VALUES (506, 'milk', 2.5, 7, 'A', '2026-07-06 12:19:39', 'No', 'No', 30);
INSERT INTO products VALUES (507, 'milk_2', 3, 7, 'A', '2026-07-07 12:19:39', 'No', 'No', 30);

SELECT product_name 
FROM products 
WHERE is_allergic = 'Yes' AND resistant = 'Yes';


UPDATE products
SET is_allergic = 'Yes'
WHERE product_name = 'Bananas Family Pack';


SELECT is_allergic, product_name
FROM products 
WHERE product_name = 'Bananas Family Pack';

DELETE FROM products 
WHERE product_name = 'milk_2';

SELECT product_name
FROM products 
WHERE product_name = 'milk_2';


SELECT * FROM products;