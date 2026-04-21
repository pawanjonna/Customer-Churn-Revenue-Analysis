create database customer_churn_and_revenue_analysis;
use customer_churn_and_revenue_analysis;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE plans (
    plan_id INT PRIMARY KEY,
    plan_name VARCHAR(50),
    price DECIMAL(10,2),
    duration_months INT
);

CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    plan_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (plan_id) REFERENCES plans(plan_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    subscription_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id)
);

INSERT INTO customers VALUES
(1,'Pawan','Hyderabad','2023-01-10'),
(2,'Ravi','Chennai','2023-02-05'),
(3,'Sneha','Bangalore','2023-02-20'),
(4,'Kiran','Delhi','2023-03-15'),
(5,'Anjali','Mumbai','2023-04-01'),
(6,'Vikram','Hyderabad','2023-04-10');

INSERT INTO plans VALUES
(101,'Basic',499,1),
(102,'Standard',1299,3),
(103,'Premium',4499,12);

INSERT INTO subscriptions VALUES
(201,1,103,'2023-01-15','2024-01-15'),
(202,2,101,'2023-02-10','2023-03-10'),
(203,3,102,'2023-02-25','2023-05-25'),
(204,4,101,'2023-03-20','2023-04-20'),
(205,5,103,'2023-04-05','2024-04-05'),
(206,6,102,'2023-04-15','2023-07-15');

INSERT INTO payments VALUES
(301,201,4499,'2023-01-15'),
(302,202,499,'2023-02-10'),
(303,203,1299,'2023-02-25'),
(304,204,499,'2023-03-20'),
(305,205,4499,'2023-04-05'),
(306,206,1299,'2023-04-15');

-- Q1.Display full customers table?
select * from customers;

-- Q2.Show customers from Hyderabad?
select customer_id,name,city from customers where city ='Hyderabad';

-- Q3.List all available subscription plans
select plan_name,price from plans;

-- Q4.count no of customers?
select count(*) from customers;

-- Q5.Show customers who signed up after March 2023?
select name,signup_date from customers where signup_date > '2023-01-01';

-- Q6.Find the most expensive plan
select plan_id,plan_name,price from plans order by price desc limit 1;

-- Q7.Show distinct cities where customers live
select distinct(city) from customers;

-- Q8.Show customer names with their subscription plans
select c.name,p.plan_id,p.plan_name,s.subscription_id from plans p join subscriptions s on p.plan_id = s.plan_id join customers c on s.customer_id = c.customer_id;

-- Q9.Find total revenue generated
SELECT SUM(amount) AS total_revenue FROM payments;

-- Q10.Find total number of subscriptions per plan
SELECT p.plan_name, COUNT(*) AS total_subscriptions
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name;

-- Q11.Show how many customers are in each city
select count(*) as customers,city from customers group by city;

-- Q12.Find average plan price
select avg(price) as average_price from plans;

-- Q13.how payment details with customer names
select c.name,p.payment_id,p.amount,p.payment_date from customers c join subscriptions s on c.customer_id = s.customer_id 
join payments p on s.subscription_id = p.subscription_id;

-- Q14.Find customers who purchased Premium plan
Select c.name,p.plan_name,s.subscription_id from customers c join subscriptions s on c.customer_id = s.customer_id 
join plans p on s.plan_id = p.plan_id where p.plan_name = 'premium';

-- Q15.Find active customers
SELECT *
FROM subscriptions
WHERE end_date > CURRENT_DATE;

-- 16. Find churned customers
SELECT *
FROM subscriptions
WHERE end_date < CURRENT_DATE;

-- 17. Find total revenue per plan
SELECT p.plan_name, SUM(pay.amount) AS revenue
FROM payments pay
JOIN subscriptions s ON pay.subscription_id = s.subscription_id
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name;

-- 18. Find customer who spent the most money
SELECT c.name, SUM(pay.amount) AS total_spent
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN payments pay ON s.subscription_id = pay.subscription_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

-- 19. Find most popular subscription plan
SELECT p.plan_name, COUNT(*) AS total_users
FROM subscriptions s
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY p.plan_name
ORDER BY total_users DESC
LIMIT 1;

-- 20. Find average subscription duration
SELECT AVG(DATEDIFF(end_date, start_date)) AS avg_days
FROM subscriptions;

-- 22. Customer Lifetime Value (CLV)
SELECT c.name, SUM(pay.amount) AS lifetime_value
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN payments pay ON s.subscription_id = pay.subscription_id
GROUP BY c.name;

-- 23. Revenue Growth Trend
SELECT DATE_FORMAT(payment_date, '%Y-%m') AS month,
       SUM(amount) AS revenue
FROM payments
GROUP BY month;

-- 24. Find customers with multiple subscriptions
SELECT customer_id, COUNT(*) AS total_subscriptions
FROM subscriptions
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 26. Rank customers based on spending
SELECT c.name,
       SUM(pay.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS rank_position
FROM customers c
JOIN subscriptions s ON c.customer_id = s.customer_id
JOIN payments pay ON s.subscription_id = pay.subscription_id
GROUP BY c.name;

