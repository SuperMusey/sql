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

select *
from order_items oi
join order_item_notes oin
	on oi.order_id=oin.order_Id
	and oi.product_id=oin.product_id
;

-- implicit join (not suggested)
select *
from orders o, customers c
where o.customer_id = c.customer_id
;

select 
	c.customer_id,
    c.first_name,
    o.order_id,
    sh.name as shipper
from customers c
left join orders o -- can use left/right outer join
	on c.customer_id=o.customer_id
left join shippers sh
	on o.shipper_id=sh.shipper_id
order by c.customer_id
;

-- self outer join
use sql_hr;
select 
	e.employee_id,
    e.first_name,
    m.first_name as manager
from employees e
left join employees m
	on e.reports_to=m.employee_id
;

use sql_store;
select 
	o.order_id,
    c.first_name,
    sh.name as shipper
from orders o
join customers c
	using (customer_id) -- simplify ON if column names are the same
left join shippers sh
	using (shipper_id)
;

select *
from order_items oi
join order_item_notes oin
	using (order_id,product_id)
;

select 
	o.order_id,
    c.first_name
from orders o
natural join customers c -- automatically joins on a guess by the software (not recommended)
;

select 
	c.first_name as customer,
    p.name as product
from customers c
cross join products p -- combine every customer with every product
order by c.first_name
;

select 
	order_id,
    order_date,
    'Active' as status
from orders 
where order_date >= '2019-01-01'
union -- combine queries
select 
	order_id,
    order_date,
    'Archive' as status
from orders 
where order_date < '2019-01-01'
;

insert into customers (first_name, last_name, birth_date, address, city, state) 
-- if not specifying column can use default in values to use default value if set 
values ('John',
	'Smith',
	'1990-01-01',
    '521 Cooper Road',
    'Raleigh',
    'NC')
;

insert into shippers (name)
values ('Shipper1'),('Shipper2') -- insert multiple rows 
;

-- inserting hierarchical data
insert into orders (customer_id, order_date, status)
values (1,'2019-01-02',1)
;
insert into order_items
values (LAST_INSERT_ID(), 1, 1, 2.95),
(LAST_INSERT_ID(), 2, 1, 1.55)
;
select LAST_INSERT_ID() -- inbuilt func
;

create table orders_archive as -- copy of table
select * from orders
;

insert into orders_archive
select * -- select is a subquery here
from orders
where order_date < '2019-01-01'
;

use sql_invoicing;
update invoices
set payment_total = 10, payment_date = '2019-03-01'
where invoice_id=1
;

update invoices
set payment_total = invoice_total * 0.5, 
	payment_date = due_date
where invoice_id=3 -- make general statement for updating multiple rows
;

update invoices
set payment_total = invoice_total * 0.5, 
	payment_date = due_date
where client_id in (3,4)
;

update invoices
set payment_total = invoice_total * 0.5, 
	payment_date = due_date
where client_id IN -- subquery
	(select client_id 
	from clients
	where name='Myworks')
;

delete from invoices
where client_id=
	(select client_id
	from clients
	where name='Myworks')
;




