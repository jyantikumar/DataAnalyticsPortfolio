use messy_retail_db;

-- ============================== Cleaning Table creation and inserting data ==============================
create table customers_cleaning
like customers;
Insert into customers_cleaning
Select * from customers;


create table employees_cleaning
like employees;
Insert into employees_cleaning
Select * from employees;

create table inventory_cleaning
like inventory;
Insert into inventory_cleaning
Select * from inventory;

create table order_items_cleaning
like order_items;
Insert into order_items_cleaning
select * from order_items;

create table orders_cleaning
like orders;
Insert into orders_cleaning
Select * from orders;

create table payments_cleaning
like payments;
Insert into payments_cleaning
Select * from payments;

create table products_cleaning
like products;
Insert into products_cleaning
Select * from products;

create table shipping_cleaning
like shipping;
Insert into shipping_cleaning
Select * from shipping;

create table stores_cleaning
like stores;
insert into stores_cleaning
Select * from stores;

create table suppliers_cleaning
like suppliers; 
Insert into suppliers_cleaning
Select * from suppliers;

-- ============================================ Viewing tables =========
Select * from customers_cleaning;
Select * from employees_cleaning;
Select * from inventory_cleaning;
Select * from order_items_cleaning;
Select * from orders_cleaning;
Select * from payments_cleaning;
Select * from products_cleaning;
Select * from shipping_cleaning;
Select * from stores_cleaning;
Select * from suppliers_cleaning;

-- Duplicates removal
with cus_dupes as(
	Select *, row_number() over(
		partition by FirstName, LastName,EmailAddress,PhoneNUmber,AddressLine,City,State,Zip,status, created_date
    ) as row_num from customers_cleaning
)
Delete c
from customers_cleaning as c
join cus_dupes as cd
on cd.customerid=c.customerid
where cd.row_num>1;

with emp_dupes as(
	Select *, row_number() over(
		partition by first_name, last_name,email,phone,hire_date,position,storeId,manager_id
    ) as emp_row_num from employees_cleaning
)
Delete ec
from employees_cleaning as ec
join emp_dupes as ed 
on ed.employeeID=ec.employeeid
where emp_row_num>1;

with inv_dupes as(
	Select *, row_number() over(
		partition by storeid,qty,last_updated
    ) as inv_row_num from inventory_cleaning
) 
Select * from inv_dupes where inv_row_num>1;

Select * from order_items_cleaning;

with oic_dupes as(
	Select *, row_number() over(
		partition by productid, quantity,unitprice,discount
    ) as oi_row_num from order_items_cleaning
)
Delete oic
from order_items_cleaning as oic
join oic_dupes as od 
on od.orderitemid=oic.orderitemid where oi_row_num>1;

Select * from orders;

with order_dupes as (
	Select *, row_number() over(
		partition by customerid, orderdate, orderstatus, totalamount, store_id, employee_id
    ) as order_row_num from orders_cleaning
) Select * from order_dupes where order_row_num>1;

Select * from payments_cleaning;
with payment_dupes as (
	Select *, row_number() over(
		partition by orderid, payment_date, amount, payment_method, paymentstatus
    ) as payment_row_num from payments_cleaning
) Select * from payment_dupes where payment_row_num>1 ;
Select * from products_cleaning;

with prod_dupes as (
	Select *, row_number() over(
		partition by productname, sku, descr, category, brand, supplierId, price, cost, productdescription
    ) as prod_rows from products_cleaning
) Select * from prod_dupes where prod_rows>1;

Select * from shipping_cleaning;
with shipping_dupes as(
	Select *, row_number() over(
		Partition by  orderid,ship_date,delivery_date,carrier,tracking_number,shipping_cost,shipstatus
    ) as s_num_row from shipping_cleaning
) Select * from shipping_dupes where s_num_row>1;

Select * from stores;
with stores_dupes as (
	Select *, row_number() over(
		partition by storename, address, city, state, zip, phone, managerid
    ) as store_rownum from stores_cleaning
) 
Select * from stores_dupes where store_rownum>1;

Select * from suppliers_cleaning;
with suppliers_dupe as (
	Select *, row_number() over(
		Partition by supplier_name, contactname, phone, email, address, city, state, zipcode
    ) as suppliers_rownum from suppliers_cleaning
) Select * from suppliers_dupe where suppliers_rownum>1;

-- =============== Standardization =======================
Select * from customers_cleaning;
Update customers_cleaning
set FirstName=trim(firstname),
	lastname=trim(lastname),
    emailaddress=trim(emailaddress),
    phonenumber=trim(phonenumber),
    addressline=trim(addressline),
    city=trim(city),
    state=trim(state),
    zip=trim(zip),
    status=trim(status);

update customers_cleaning
set firstname=
	concat(
		upper(substr(firstname,1,1)),
        lower(substring(firstname,2))
        ),
	lastname=
	concat(
		upper(substr(lastname,1,1)),
        lower(substring(lastname,2))
        ),
	state=upper(state),
    city=
	concat(
		upper(substr(city,1,1)),
        lower(substring(city,2))
        ),
	state=upper(state),
    status=upper(status);
Update customers_cleaning
set status="INACTIVE"
where status like 'I%';
Update customers_cleaning
set status="ACTIVE"
where status like 'A%';

Update customers_Cleaning
set city="Sanantonio"
where city="San Antonio";
Select distinct city from customers_cleaning;

Update customers_cleaning
set city="San Jose"
where city like '%ose';

Update customers_cleaning
set city="Boston"
where city like '%ston%';

Update customers_cleaning
set city="Phoenix"
where city like '%ix%';

Update customers_cleaning
set city="San Antonio"
where city like '%tonio%';

Update customers_cleaning
set city="Philadelphia"
where city like '%delphia%' or city like '%delpha';

Update customers_cleaning
set city="Los Angeles"
where city like 'Los%';

Update customers_cleaning
set city="Chicago"
where city like 'chi%';

Update customers_cleaning
set city="San Diego"
where city like '%diego%';

Update customers_cleaning
set city="Dallas"
where city like 'Dal%';

Update customers_cleaning
set city="San Jose"
where city like '%San joe%';

Update customers_cleaning
set city="San Diego"
where city like '%San D%';

update customers_cleaning
set city="Charlotte"
where city like 'char%';

 Update customers_cleaning
 set city="Austin"
  where city like '%in';
  Update customers_cleaning
 set city="Austin"
  where city like 'Austn';
  
  Update customers_cleaning 
  set city="Boston"
  where city="Bostn";
  Update customers_cleaning
  set city="Charlotte"
  where city like '%lotte';
Update customers_cleaning
set city="Chicago"
where city like '%cago';
Update customers_cleaning
set city="Columbus"
where city like '%bus';
Update customers_cleaning
set city="Denver"
where city like '%ver';
Update customers_cleaning
set city="Denver"
where city="Dener";
update customers_cleaning
set city="Dallas"
where city like '%las';
update customers_cleaning
set city="New York"
where city like 'new%' or city like '%ork';
update customers_cleaning 
set city="Jacksonville"
where city like'Jackson%';
Update customers_cleaning
set city="Houston"
where city like '%son';
update customers_cleaning
set city="Las Vegas"
where city like 'Las%' or city like '%vegas';
update customers_cleaning
set city="Nashville"
where city like 'Nash%';
Update customers_cleaning
set city="Portland"
where city like 'po%' and city like '%land';
update customers_cleaning
set city="Seattle"
where city like '%tle' or city like '%tte';

Update customers_cleaning
set phonenumber=replace(phonenumber,".","-");
Select phonenumber from customers_cleaning where phonenumber like '(%';
Select * from customers_cleaning;

