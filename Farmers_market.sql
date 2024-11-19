use farmers_market;
show tables;
-- 1.	Get all the products available in the market 
select product_name from product;

-- 2.	List down 10 rows of vendor booth assignments, displaying the market date, vendor ID, and booth number from the vendor_booth_assignments table. 
select * from vendor_booth_assignments limit 10;

-- 3. In the customer purchases, we have quantity and cost per qty separate, query the total amount that the customer has paid along with date, customer id, vendor_id, qty, cost per qty and the total amt.? 
select * from customer_purchases;
SELECT market_date,customer_id,vendor_id,quantity,cost_to_customer_per_qty,
	(quantity*cost_to_customer_per_qty) AS total_amount
    FROM customer_purchases;
    
-- 4. Merge each customer’s name into a single column that contains the first name, then a space, and then the last name. 
select * from customer;
select concat(customer_first_name," ",customer_last_name) as Customer_Name from customer;

-- 5. Extract all the product names that are part of product category 1. 
select product_name from product where product_category_id = 1;

-- 6. How many products where for sale on each market date 
select * from customer_purchases;
select market_date,count(product_id) as total_sales from customer_purchases group by market_date;

-- 7. Print a report of everything customer_id 4 has ever purchased at the farmer’s market, sorted by market date, vendor ID, and product ID. 
select * from customer_purchases;
select customer_id,product_id,vendor_id,market_date from customer_purchases where customer_id = 4;

-- 8. Get all the product info for products with id between 3 and 8 (not inclusive) or product with id 10. 
select * from product;
select * from product where product_id between 4 and 7 or product_id = 10;

-- 9. Details of all the purchases made by customer_id 4 at vendor_id 7, along with the total_amt.
select * from customer_purchases;
select customer_id,vendor_id,sum(cost_to_customer_per_qty) from customer_purchases where customer_id = 4 and vendor_id = 7  ;

-- 10. Find the customer detail with the first name of “carlos” or the last name of “diaz” 
select * from customer where customer_first_name = 'carlos' or customer_last_name = 'diaz';

-- 11. Find the booth assignments for vendor 7 for any market date that occurred between april 3, 2019, and may 16, 2019 
select * from vendor_booth_assignments;
select * from vendor_booth_assignments where vendor_id = 7 
and market_date between '2019-04-03' and '2019-05-16'; 

-- 12. Return a list of customers with selected last names - [diaz, edwards and wilson]. 
select * from customer where customer_last_name in ('diaz','edwards','wilson');

-- 13. Analyze purchases made at the farmer’s market on days when it rained.
select * from customer_purchases where market_date IN(select market_date from market_date_info where  market_rain_flag=1);

-- 14. Return all products without sizes. 
select * from product where product_size is null or product_size = (" ");

-- 15. You want to get data about a customer you knew as “jerry,” but you aren’t sure if he was listed in the database as “jerry” or “jeremy” or “jeremiah.”  How would you get the data from this partial string? 
SELECT customer_id,CONCAT(customer_first_name," ",customer_last_name) AS FULL_NAME ,customer_zip from customer
WHERE customer_first_name  LIKE 'Jer%' ;

-- 16. We want to merge each customer’s name into a single column that contains the first name, then a space, and then the last name in upper case. 
select upper(concat(customer_first_name," ",customer_last_name))as Full_Name from customer;

-- 17. Find out what booths vendor 2 was assigned to on or before (less than or equal to) april 20, 2019
select booth_number,market_date from vendor_booth_assignments where vendor_id=2 and market_date<="2019-04-20";

-- 18. Find out which vendors primarily sell fresh produce and which don’t. 
select * from booth;
select * ,case when vendor_type like "%fresh%" THEN 'Sells Fresh Produce'
ELSE 'Do Not Sell Fresh Produce' 
end as fresh_or_not from vendor;

-- 19. Calculate the total quantity purchased by each customer per market_date. 
SELECT market_date,customer_id,SUM(quantity) AS total_quantity
FROM customer_purchases GROUP BY customer_id, market_date; 

-- 20. How many different kinds of products were purchased by each customer 10 in each market date 
select market_date,count(Distinct product_id) as product_count from customer_purchases where customer_id=10 Group by market_date;

-- 21	List all the products and their product categories
select p.product_name,pc.product_category_name from product_category pc inner join product p on pc.product_category_id = p.product_category_id ;

-- 22.	Get all the Customers who have purchased nothing from the market yet.
SELECT customer_id FROM customer 
except 
select customer_id from customer_purchases;

-- 23.	List all the customers and their associated purchases
select c.customer_id,c.customer_first_name,cp.product_id from customer c left join customer_purchases cp 
on c.customer_id = cp.customer_id 
group by c.customer_id,c.customer_first_name,cp.product_id;

-- 24.	Write a query that returns a list of all customers who did not purchase on March 2, 2019
select customer_id from customer
except 
select customer_id from customer_purchases where market_date = '2019-03-02';

-- 25.	filter out vendors who brought at least 10 items to the farmer’s market over the time period - 2019-05-02 and 2019-05-16
select cp.market_date,v.vendor_id from customer_purchases cp right join vendor v 
on cp.vendor_id = v.vendor_id where cp.market_date 
between '2019-05-02' and '2019-05-16' 
group by v.vendor_id,cp.market_date HAVING count(cp.product_id)>=10;

-- 26.	Show details about all farmer’s market booths and every vendor booth assignment for every market date
SELECT b.booth_number,b.booth_type,vba.market_date,v.vendor_id,v.vendor_name,v.vendor_type
FROM booth as b
LEFT JOIN vendor_booth_assignments as vba  ON b.booth_number=vba.booth_number
LEFT JOIN vendor as v on v.vendor_id=vba.vendor_id
order by vba.market_date,b.booth_number;


-- 27.	find out how much this customer had spent at each vendor, regardless of date? (Include customer_first_name, customer_last_name, customer_id, vendor_name, vendor_id, price)
select c.customer_first_name,c.customer_last_name,c.customer_id,v.vendor_id,v.vendor_name,cp.quantity*cost_to_customer_per_qty as total_spend 
from customer as c left join customer_purchases as cp 
on c.customer_id=cp.customer_id
left join vendor as v on cp.vendor_id=v.vendor_id;

-- 28.	get the lowest and highest prices within each product category include (product_category_name, product_category_id, lowest price, highest _price)
select pc.product_category_name,p.product_category_id,max(cp.cost_to_customer_per_qty*cp.quantity) max_price,min(cp.cost_to_customer_per_qty*cp.quantity)  lowest_price
from product_category pc left join product p 
on pc.product_category_id = p.product_category_id
left join customer_purchases as cp on cp.product_id = p.product_id 
group by  pc.product_category_name,p.product_category_id;

-- 29.	Count how many products were for sale on each market date, or how many different products each vendor offered.
SELECT cp.market_date, COUNT(DISTINCT p.product_id) AS products_for_sale
FROM customer_purchases as cp
left join product as p on  cp.product_id=p.product_id
group by cp.market_date;

SELECT v.vendor_id,v.vendor_name, COUNT(DISTINCT cp.product_id) AS different_products_offered
FROM customer_purchases as cp
right join  vendor as v ON v.vendor_id = cp.vendor_id
GROUP BY v.vendor_id,v.vendor_name;

-- 30.	In addition to the count of different products per vendor, we also want the average original price of a product per vendor?
select v.vendor_id,v.vendor_name,count(DISTINCT vi.product_id) as count_of_different_product,avg(vi.original_price) as average_price
from vendor as v left join vendor_inventory as vi on v.vendor_id=vi.vendor_id GROUP BY v.vendor_id,v.vendor_name;