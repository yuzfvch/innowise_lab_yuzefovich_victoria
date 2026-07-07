SELECT
    sales_id, products.product_name, shops.address
FROM
    sales as s
JOIN
    products ON s.product_id = products.product_id
JOIN
    employees ON s.employee_id = employees.employee_id
JOIN
    shops ON employees.shop_id = shops.shop_id
ORDER BY sales_id
LIMIT 10;