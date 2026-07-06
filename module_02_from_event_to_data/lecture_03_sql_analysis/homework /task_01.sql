
select s.sales_id, p.product_name, sh.address as shop_address
from sales s
 join products p on s.product_id = p.product_id 
 join employees e on s.employee_id = e.employee_id 
 join shops sh on e.shop_id = sh.shop_id