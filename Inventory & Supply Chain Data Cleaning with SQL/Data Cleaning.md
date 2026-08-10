---
tags:
  - sql
  - practice
  - ex6
date: 2026-07-06
---
```sql



-- Data Cleaning

-- ====================== Customer table
-- Duplicate table
create table customer_cleaning
like customers;

insert into customer_cleaning
select * from customers;

-- Identify duplicate values
with dupe as (
	Select *, row_number() over(
	partition by customer_id, first_name, last_name, email, phone, customer_type, signup_date
	)  as row_num from customer_cleaning
)
Select * from dupe where row_num>1;

Update customer_cleaning
set customer_id=trim(customer_id),
	first_name=trim(first_name),
    last_name=trim(last_name),
    email=trim(email),
    phone=trim(phone),
    city=trim(city),
    customer_type=trim(customer_type),
    signup_date=trim(signup_date);

Select * from customer_cleaning;
update customer_cleaning
set email=null where email="" or email="NULL";

-- update customer_cleaning
-- set phone=replace(phone,'+63','');


update customer_cleaning
set phone=null where phone="" or phone="NULL";

update customer_cleaning
set phone=substr(phone,2) where phone like '0%';


update customer_cleaning
set phone=replace(phone,'-','')
 where phone like '9%';


Select phone from customer_cleaning where phone not like '9%' and phone is not null and phone!="null";
Select phone from customer_cleaning;

Select phone from customer_cleaning where phone like '+63%';

update customer_cleaning
set phone=replace(phone,'+63','') where phone like '+63%';

update customer_cleaning
set phone=replace(phone,' ','');

update customer_cleaning
set phone=NULL
where phone="" or phone="NULL";

Select distinct city from customer_cleaning;
Select distinct customer_type from customer_cleaning;

update customer_cleaning
set customer_type=upper(customer_type);

update customer_cleaning
set signup_date=replace(signup_date,'/','-');


SELECT signup_date,
CASE
    WHEN signup_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(signup_date, '%Y-%m-%d')

    WHEN signup_date REGEXP '^[A-Za-z]{3} [0-9]{1,2}, [0-9]{4}$'
        THEN STR_TO_DATE(signup_date, '%b %d, %Y')

    WHEN signup_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
         AND CAST(LEFT(signup_date,2) AS UNSIGNED) > 12
        THEN STR_TO_DATE(signup_date, '%d-%m-%Y')

    WHEN signup_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN STR_TO_DATE(signup_date, '%m-%d-%Y')
END AS cleaned_date
FROM customer_cleaning;

UPDATE customer_cleaning
SET signup_date =
CASE
    WHEN signup_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(signup_date, '%Y-%m-%d')

    WHEN signup_date REGEXP '^[A-Za-z]{3} [0-9]{1,2}, [0-9]{4}$'
        THEN STR_TO_DATE(signup_date, '%b %d, %Y')

    WHEN signup_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
         AND CAST(LEFT(signup_date,2) AS UNSIGNED) > 12
        THEN STR_TO_DATE(signup_date, '%d-%m-%Y')

    WHEN signup_date REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN STR_TO_DATE(signup_date, '%m-%d-%Y')

    ELSE signup_date
END;

alter table customer_cleaning
modify column signup_date date;

Select * from customer_cleaning;

-- ====================== INVENTORY
create table inv_cleaning
like inventory;

insert into inv_cleaning
select * from inventory;

with dupe as (
	Select *, row_number() over(
	partition by inventory_id, warehouse_id, product_id, stock_quantity, last_stock_update
	)  as row_num from inv_cleaning
)
Select * from dupe where row_num>1;


SELECT last_stock_update,
CASE
    WHEN last_stock_update REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(last_stock_update, '%Y-%m-%d')

    WHEN last_stock_update REGEXP '^[A-Za-z]{3} [0-9]{1,2}, [0-9]{4}$'
        THEN STR_TO_DATE(last_stock_update, '%b %d, %Y')

    WHEN last_stock_update REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
         AND CAST(LEFT(last_stock_update,2) AS UNSIGNED) > 12
        THEN STR_TO_DATE(last_stock_update, '%d-%m-%Y')

    WHEN last_stock_update REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN STR_TO_DATE(last_stock_update, '%m-%d-%Y')
END AS cleaned_date
FROM inv_cleaning;

UPDATE inv_cleaning
SET last_stock_update =
CASE
    WHEN last_stock_update REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
        THEN STR_TO_DATE(last_stock_update, '%Y-%m-%d')

    WHEN last_stock_update REGEXP '^[A-Za-z]{3} [0-9]{1,2}, [0-9]{4}$'
        THEN STR_TO_DATE(last_stock_update, '%b %d, %Y')

    WHEN last_stock_update REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
         AND CAST(LEFT(last_stock_update,2) AS UNSIGNED) > 12
        THEN STR_TO_DATE(last_stock_update, '%d-%m-%Y')

    WHEN last_stock_update REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$'
        THEN STR_TO_DATE(last_stock_update, '%m-%d-%Y')

    ELSE last_stock_update
END;


Update inv_cleaning
set inventory_id=trim(inventory_id),
	warehouse_id=trim(warehouse_id),
    product_id=trim(product_id),
    stock_quantity=trim(stock_quantity),
    last_stock_update=trim(last_stock_update);

Select * from inv_cleaning
where warehouse_id="" or warehouse_id="NULL";

Select * from inv_cleaning
where product_id="" or product_id="NULL";

Select * from inv_cleaning
where stock_quantity=null or stock_quantity="";

Select * from inv_cleaning
where last_stock_update="" or last_stock_update="NULL";

alter table inv_cleaning
modify column last_stock_update date;

Select  * from inv_cleaning;

update inv_cleaning
set stock_quantity=Null where stock_quantity="" or stock_quantity="NULL";

-- ============================ products table
create table prod_cleaning
like products;

insert into prod_cleaning
select * from products;


Select * from prod_cleaning;

with dupe as (
	Select *, row_number() over(
	partition by product_id, supplier_id, category, unit_cost, selling_price, reorder_level, product_status
	)  as row_num from prod_cleaning
)
Select * from dupe where row_num>1;

Update prod_cleaning
set 
	product_id=trim(product_id),
	supplier_id=trim(supplier_id),
    product_name=trim(product_name),
    category=trim(category),
    unit_cost=trim(unit_cost),
    selling_price=trim(selling_price),
    reorder_level=trim(reorder_level),
    product_status=trim(product_status);
    
Select * from prod_cleaning
where product_name="NULL" or product_name=""
	or category="NULL" or category=""
    or unit_cost="NULL" or unit_cost=""
or selling_price="NULL" or selling_price=""
or reorder_level="NULL" or reorder_level=""
or product_status="NULL" or product_status="";

Update prod_cleaning
set product_name=null,
	category=null,
    product_status=null,
    reorder_level=null
    where product_id=60;
    
Update prod_cleaning
set unit_cost=null
    where product_id=45;
    
Update prod_cleaning
 set selling_price=replace(selling_price,'₱','');

Update prod_cleaning
 set selling_price=replace(selling_price,',','');
 
Update prod_cleaning
 set unit_cost=replace(unit_cost,'$','');

Update prod_cleaning
 set unit_cost=replace(unit_cost,',','');
 
 update prod_cleaning
 set category=upper(category);
 
 Select distinct category from prod_cleaning;
 
 Select * from prod_cleaning;
 
 alter table prod_cleaning
 modify column unit_cost decimal(10,2);
 
  alter table prod_cleaning
 modify column selling_price decimal(10,2);
 
 Update prod_cleaning
 set product_status= upper(product_status);
 
 select distinct product_status from prod_cleaning;
 
 -- ======================= SALES TABLE
 -- Duplicate table
create table sales_cleaning
like sales;

insert into sales_cleaning
select * from sales;
 
 Select * from sales_cleaning;
 
 with dupe as (
	Select *, row_number() over(
	partition by sale_id, sale_date, customer_id, product_id, warehouse_id, quantity, payment_method, sale_status, sales_rep
	)  as row_num from sales_cleaning
)
Select * from dupe where row_num>1;

Update sales_cleaning
set sale_id=trim(sale_id),
	sale_date=trim(sale_date),
    customer_id=trim(customer_id),
    product_id=trim(product_id),
    warehouse_id=trim(warehouse_id),
    quantity=trim(quantity),
    payment_method=trim(payment_method),
    sale_status=trim(sale_status),
    sales_rep=trim(sales_rep);
    
Select sale_date, date_format(sale_date,'%Y-%m-%d') from sales_cleaning where sale_date!=date_format(sale_date,'%Y-%m-%d');

alter table sales_cleaning
modify column sale_date date;

Select * from sales_cleaning;

Update sales_cleaning
set payment_method=upper(payment_method);
    
Update sales_cleaning
set sale_status=upper(sale_status);

Select distinct sale_status from sales_cleaning;

-- ================ Suppliers table
create table sup_cleaning
like suppliers;

insert into sup_cleaning
select * from suppliers;


 with dupe as (
	Select *, row_number() over(
	partition by supplier_name, contact_name, email, phone, city, supplier_status
	)  as row_num from sup_cleaning
)
Select * from dupe where row_num>1;

Select * from sup_cleaning;

Update sup_cleaning
set 
	supplier_id=trim(supplier_id),
    supplier_name=trim(supplier_name),
    contact_name=trim(contact_name),
    email=trim(email),
    phone=trim(phone),
    city=trim(city),
    supplier_status=trim(supplier_status);
    
Select * from sup_cleaning
where email="" or email="NUll"
	or phone="" or phone="NUll"
    or city="" or city="NUll"
    or supplier_status="" or supplier_status="NUll";

Update sup_cleaning
set phone=null
where phone="NULL" or phone='';


Update sup_cleaning
set email=null
where email="NULL" or email='';

Select phone from sup_cleaning where phone like '+63%';
Select phone from sup_cleaning where phone like '0%';

SELECT
    phone AS original_phone,
    CASE
        WHEN phone LIKE '+63%' THEN REPLACE(phone, '+63', '')
        WHEN phone LIKE '0%' THEN SUBSTRING(phone, 2)
        ELSE phone
    END AS cleaned_phone
FROM sup_cleaning;


Update sup_cleaning
set phone=
	case
		when phone like '+63%' then replace(phone,'+63','')
       when phone like '%-%' then replace(phone,'-','')
			when phone like '% %' then replace(phone,' ','')
	end;

Update sup_cleaning
set phone=replace(phone,' ','');
Update sup_cleaning
set phone=replace(phone,'-','');
Update sup_cleaning
set phone=substr(phone,2) where phone like '0%' ;

Select * from sup_cleaning;

update sup_cleaning
set supplier_status=upper(supplier_status);

-- Warehouse
create table wh_cleaning
like warehouses;

Insert into wh_cleaning
select * from warehouses;

Select * from wh_cleaning;

Update wh_cleaning
set warehouse_id=trim(warehouse_id),
	warehouse_name=trim(warehouse_name),
    city=trim(city),
    warehouse_manager=trim(warehouse_manager);
    

```