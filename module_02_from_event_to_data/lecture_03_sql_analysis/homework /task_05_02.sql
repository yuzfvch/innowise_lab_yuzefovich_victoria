CREATE OR REPLACE FUNCTION AvgSalesPerEmployee(p_employee_id INTEGER)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    avg_sale NUMERIC;
BEGIN
    SELECT AVG(total_price)
    INTO avg_sale
    FROM sales
    WHERE employee_id = p_employee_id;

    RETURN avg_sale;
END;
$$;

SELECT AvgSalesPerEmployee(123);

CREATE OR REPLACE VIEW FullStatShops AS
SELECT 
	sh.shop_id, 
	sh.shop_address, 
	count(s.sales_id) AS total_sales_count,
	sum(s.total_price) AS total_sales_amount 
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
JOIN shops sh ON sh.shop_id = e.shop_id 
GROUP BY sh.shop_id, sh.shop_address;

SELECT * FROM FullStatShops;