USE sql_store;

SELECT 
	first_name, 
	last_name, 
	points, 
    points*(1/100) AS 'discount factor'
FROM customers
WHERE customer_id>2
ORDER BY first_name;

SELECT DISTINCT state
FROM customers;

SELECT *
FROM customers
-- WHERE points>3000
-- AND state <> 'TX'
WHERE NOT (birth_date > '1990-01-01' -- order of ops = AND,OR can use () to override
OR points > 1000)
AND state='va';

SELECT *
FROM customers
WHERE state NOT IN ('VA','FL');

SELECT *
FROM customers
WHERE points BETWEEN 1000 AND 3000;

SELECT *
FROM customers
-- WHERE last_name LIKE '%b%' -- % means that number of characters before or after do not matter
WHERE last_name LIKE 'b____y' -- _ means that number of characters should exist before or after character 'y'
;

SELECT *
FROM customers
-- WHERE last_name REGEXP 'field$|mac|rose'  -- ^ to represent beginning of string, $ to represent end, | for multiple patterns, logical or
WHERE last_name REGEXP '[gim]e[a-v]' -- [] characters should have them before e 
;

SELECT *
FROM customers
-- WHERE phone IS NULL
WHERE phone IS NOT NULL
;

SELECT *
FROM customers
ORDER BY state , first_name DESC
;

SELECT *
FROM customers
-- LIMIT 3
LIMIT 6, 3 -- 6 is the offset, so skip 6
;

SELECT o.customer_id, order_id ,first_name, last_name
FROM orders as o
INNER JOIN customers as c
ON o.customer_id = c.customer_id
;

SELECT order_id, p.product_id, quantity, oi.unit_price
FROM order_items oi
INNER JOIN products p 
ON oi.product_id=p.product_id
;


select *
from order_items oi
inner join sql_inventory.products p -- to use tables from oter schemas
on oi.product_id=p.product_id
;

-- self join
USE sql_hr;
select 
	e.employee_id,
	e.first_name,
	m.first_name as manager
from employees e
join employees m
on e.reports_to=m.employee_id
;

use sql_store;
select 
	o.order_id,
    o.order_date,
    c.first_name,
    c.last_name,
    os.name as status
from orders o
join customers c
	on o.customer_id=c.customer_id
join order_statuses os
	on o.status=os.order_status_id
order by o.order_id
;



