create database telecom_churn;
use  telecom_churn;
show tables;
rename table sales_combined to sales;
select * from sales;
select * from customer_churn;
select count(*) from customer_churn;


create view churn_rate as 
SELECT Churn, COUNT(*) AS total, 
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_churn), 2) AS pct
FROM customer_churn
GROUP BY Churn;

show  full tables 
where table_type = 'VIEW';
select * from churn_rate;

SELECT COUNT(*) FROM CUSTOMER_CHURN 
WHERE SeniorCitizen = 1;


ALTER  TABLE CUSTOMER_CHURN 
MODIFY SENIORCITIZEN VARCHAR(10);
SET SQL_SAFE_UPDATES = 0;
UPDATE CUSTOMER_CHURN
SET SENIORCITIZEN ='YES' 
WHERE SENIORCITIZEN ='1';

SELECT * FROM CUSTOMER_CHURN;


SELECT INTERNETSERVICE,COUNT(ONLINESECURITY) FROM CUSTOMER_CHURN
WHERE ONLINESECURITY = 'NO'
GROUP BY INTERNETSERVICE;


SELECT INTERNETSERVICE,COUNT(CUSTOMERID) FROM CUSTOMER_CHURN 
WHERE CHURN='YES'
GROUP BY INTERNETSERVICE;

-- REVENUE
CREATE VIEW CHURN_REVENUE AS 
SELECT Churn,
       COUNT(*) AS customers,
       ROUND(SUM(MonthlyCharges), 2) AS monthly_revenue,
       ROUND(SUM(MonthlyCharges) * 12, 2) AS annualized_revenue
FROM customer_churn
GROUP BY Churn;

CREATE VIEW CHURN_BY_CONTRACT AS
SELECT Contract,
       COUNT(*) AS total,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
       ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

CREATE VIEW TENURE AS 
SELECT 
  CASE 
    WHEN tenure <= 6 THEN '0-6 months'
    WHEN tenure <= 12 THEN '7-12 months'
    WHEN tenure <= 24 THEN '13-24 months'
    ELSE '24+ months'
  END AS tenure_bucket,
  COUNT(*) AS total,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY tenure_bucket
ORDER BY MIN(tenure);


CREATE VIEW CHURN_BY_INTERNETSERVICE AS 
SELECT InternetService,
       COUNT(*) AS total,
       SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
       ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY InternetService
ORDER BY churn_rate_pct DESC;


CREATE VIEW CHURN_BYSUPPORT AS
SELECT OnlineSecurity, TechSupport,
       COUNT(*) AS total,
       ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY OnlineSecurity, TechSupport
ORDER BY churn_rate_pct DESC;


CREATE VIEW AVG_MONTHLY_CHARGE_TENURE_BY_CHURN AS
SELECT Churn,
       ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge,
       ROUND(AVG(tenure), 2) AS avg_tenure
FROM customer_churn
GROUP BY Churn;

CREATE VIEW CHURN_BY_PAYMENT_METHOD AS
SELECT PaymentMethod,
       COUNT(*) AS total,
       ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customer_churn
GROUP BY PaymentMethod
ORDER BY churn_rate_pct DESC;

show tables;

select * from customer_churn;
desc customer_churn;
alter table customer_churn
modify totalcharges double;
CREATE VIEW TOTAL_REVENUE AS 
select
 sum(totalcharges) as totalREVENUE from customer_churn;
 
 
 SHOW FULL TABLES 
 WHERE TABLE_TYPE = 'VIEW';
 
 SELECT * FROM TOTAL_REVENUE;
 
 select * from customer_churn where trim(totalcharges)='';
 
 select * from customer_churn where tenure ='0';
 set sql_safe_updates=0;
 update customer_churn set totalcharges ='0'
 where trim(totalcharges)='';
 set sql_safe_updates =1;
 
 select * from customer_churn;
 select count(*) from customer_churn 
 where tenure='66';
 
 show databases;
 
 show tables;
 
 describe customer_churn;
 
select * from customer_churn; 


-- question 1
select  
contract, count(case when churn ="Yes" then 1 end)*100/count(*) as
churned_rate
from customer_churn
group by contract;

-- question 2
select customerid,monthlycharges from customer_churn
where churn ="Yes"
order by  monthlycharges desc
limit 10;

-- question 3
 select contract ,
 case
when tenure <12 then '<12'
else '12+'
end as tenure_group ,
count(case when churn ="Yes" then 1 end )*100/count(*) as churn_rate from customer_churn
 group by contract,
  case
when tenure <12 then '<12'
else '12+'
end ;

select contract ,
count(case when churn='Yes'then 1 end) *100/count(*) as churn_rate from customer_churn
group by contract 
having churn_rate > 20;


SELECT
    CASE
        WHEN tenure < 12 THEN '<12 months'
        ELSE '12+ months'
    END AS tenure_group,
    AVG(monthlycharges) AS avg_monthly_charges,
    COUNT(*) AS customers,
    COUNT(CASE WHEN churn = 'Yes' THEN 1 END) * 100.0 / COUNT(*) AS churn_rate
FROM customer_churn
WHERE contract = 'Month-to-month'
GROUP BY
    CASE
        WHEN tenure < 12 THEN '<12 months'
        ELSE '12+ months'
    END;

select paymentmethod,
count(case when churn= 'Yes' then 1 end )*100.0/count(*) as churn_rate from customer_churn
group by paymentmethod
order by churn_rate desc 
limit 3;

select * from customer_churn;
select contract ,
count(customerid) as customers,
count(case when churn ='Yes' then 1 end )*100 / count(*) as churn_rate from customer_churn
group by contract
having count(case when churn ='Yes' then 1 end )*100 / count(*) > 20 and   customers> 500;



select customerid,monthlycharges
  from customer_churn
where churn = 'No'
and monthlycharges > (select avg(monthlycharges)from customer_churn);


with rank_cust as (
select customerid,contract,monthlycharges,
row_number() over( partition by contract 
order by monthlycharges desc ) as rank_num
from customer_churn)
select customerid,contract,monthlycharges,rank_num  from rank_cust
where rank_num <= 3 ;

 

select contract,paymentmethod,
count(case  when churn='Yes' then 1 end)*100/ count(*) as churn_rate  
from customer_churn
group by  contract,paymentmethod
order by churn_rate desc;


select contract,paymentmethod,
count(case  when churn='Yes' then 1 end)*100/ count(*) as churn_rate  
from customer_churn
group by  contract,paymentmethod
having count(*) >= 100
order by churn_rate desc
limit 3;


select 
case when monthlycharges < 50 then 'less50'
when monthlycharges between 50 and 100 then '50-100'
when monthlycharges >100 then 'more100'
end as charges_group,
count(case when churn ='Yes' then 1 end )*100/count(*) as churn_rate from customer_churn
group by charges_group;


select contract,
avg(monthlycharges) as avg_charges ,
count(case when churn ='Yes' then 1 end )*100 /count(*) as churn_rate from customer_churn
where tenure < 12
group by contract;


select contract,
avg(monthlycharges) as avg_charges from customer_churn 
where churn = 'Yes'
group by contract
order by avg_charges desc;


select internetservice,
sum(monthlycharges) as totalcharges
from customer_churn
where churn ='No'
group by internetservice;


select contract ,
avg(monthlycharges*tenure) as avg_total
from customer_churn 
where churn = 'Yes'
group by contract
having avg_total > 2000;


select internetservice,
count(*) as customers,
count(case when churn ='Yes' then 1 end)*100 / count(*) as churn_rate from customer_churn
group by internetservice
having count(*) >= 500
order by churn_rate desc;

select contract,internetservice,
count(*) as customers,
count(case when churn ='Yes' then 1 end)*100/count(*) as churn_rate
from customer_churn
group by contract,internetservice
having count(*) >=100
order by churn_rate desc 
limit 3;


select customerid,contract,monthlycharges from customer_churn c
where monthlycharges > (select avg(monthlycharges) from customer_churn
where contract = c.contract)
order by monthlycharges desc;

-- approach2
SELECT
    c.customerid,
    c.contract,
    c.monthlycharges
FROM customer_churn c
JOIN (
    SELECT
        contract,
        AVG(monthlycharges) AS avg_charges
    FROM customer_churn
    GROUP BY contract
) a
ON c.contract = a.contract
WHERE c.monthlycharges > a.avg_charges
ORDER BY c.monthlycharges DESC;


select count(*) as customers ,
count(case when churn = 'Yes' then 1 end ) *100/ count(*) as churn_rate,
case when tenure < 6 then '<6' 
when tenure between 6 and 12 then '6-12'
when tenure between 13 and 24 then '13-24'
else '24+' end as tenure_group   from customer_churn 
group by tenure_group 
order by churn_rate desc;


select paymentmethod,
avg(monthlycharges) as avg_charges,
count(*) as customers,
count(case when churn ='Yes' then  1 end )*100 / count(*) as churn_rate from customer_churn
group by paymentmethod
having count(*) >= 300
order by churn_rate desc;


with ranked_customers as ( select customerid,contract,monthlycharges, row_number() over (
partition by  contract 
order by monthlycharges desc ) as rn from customer_churn )
 select customerid, contract, monthlycharges from ranked_customers 
 where rn =1;
 
 
with ranked_customers as ( select customerid,internetservice , monthlycharges,
row_number() over ( partition by internetservice 
order by monthlycharges desc ) as rn from customer_churn)
select customerid,internetservice, monthlycharges from ranked_customers 
where rn <=2 ; 


with overall as (
select count(case when churn = 'Yes' then 1 end )*100/ count(*)  as overall_churnrate from customer_churn),
segment as(
select contract ,internetservice,
count(case when churn = 'Yes' then 1 end )*100/count(*) as churnrate from customer_churn 
group by contract,internetservice)
select s.contract,
s.internetservice,
s.churnrate,
o.overall_churnrate,
s.churnrate - o.overall_churnrate as difference from segment s 
cross join overall o 
order by difference desc;


select customerid, totalcharges
from customer_churn 
where churn =  'No'
having totalcharges> (
 select avg(totalcharges) from customer_churn 
 where churn = 'No')
 order by totalcharges desc;


select contract, 
COUNT(CASE WHEN churn = 'Yes' THEN 1 END) as churn_cust,
count(*) as total_cust,
count( case when churn = 'Yes' then 1 end )*100/count(*)as churn_percentage  from customer_churn
group by contract 
order by churn_percentage desc;  

select churn,
count(*),
avg(tenure) from customer_churn 
group by churn;

select contract,
count(*) as customers,
 count(*) *100/ (select count(*) from customer_churn ) as cust_percentage
 from customer_churn
 group by contract 
 order by  cust_percentage desc;


with ranked_cust as (select customerid,contract,totalcharges,
dense_rank()  over (partition by contract 
order by totalcharges desc ) as rnk from customer_churn)
select customerid,contract,totalcharges from ranked_cust 
where rnk <=3;


select contract,
count(*) as customers,
count(case when  Churn ='Yes' then 1 end ) as churned_cust,
count(case when churn ='Yes' then 1 end )*100/count(*) as churn_rate,
avg(monthlycharges) as avg_charges,
avg(tenure) as avg_tenure 
from customer_churn 
group by contract
order by churn_rate desc;


select contract,
count(*) as customers ,
count(case when churn='Yes' then 1 end )*100/count(*) as churn_rate
from customer_churn
group by contract 
having count(*) >= 500
order by churn_rate desc
limit 1;


select contract,churn,
count(*) as customers,
avg(monthlycharges)  as avg_charges
from customer_churn
group by contract,churn;


select contract,internetservice,
count(*) as customers,
avg(monthlycharges) as avg_charges
from customer_churn
group by contract,internetservice
having count(*) >= 200
order by avg_charges desc
limit 2;


select contract,
count(*) as customers,
count(case when churn = 'Yes' then 1 end ) as churned_cust,
count(case when churn ='Yes' then 1 end )*100 /count(*) as churn_rate,
avg (case when churn ='Yes' then monthlycharges end) as avg_churn_charges,
avg(case when churn ='Yes' then tenure end) as avg_churn_tenure
from customer_churn
group by contract 
order by churn_rate desc;


with ranked_cust as(
select customerid,contract,
monthlycharges ,
row_number() over( partition by contract
order by monthlycharges desc ) as rnk from  customer_churn)
select customerid,contract,monthlycharges from ranked_cust 
where rnk = 2;

use telecom_churn;

select case when tenure < 6 then '<6'
when tenure between 6 and 12 then'6-12'
when tenure between 13 and 24 then '13-24'
else '25+' end as tenure_group,
count(*) as customers,
count(case when churn ='Yes' then 1 end ) as churned_cust,
count(case when churn ='Yes' then 1 end )*100/count(*) as churn_rate
 from customer_churn 
group by tenure_group 
order by churn_rate desc ;

with ranked_cust as (
select customerid,
totalcharges,
contract,
 dense_rank() over (partition by contract 
 order by totalcharges desc) as rnk from customer_churn )
 
 select contract,
 customerid,
 totalcharges,rnk  from ranked_cust 
 where rnk <= 3;


select internetservice,
count(*) as customers,
count(case when churn='Yes' then 1 end) as churned_cust,
count(case when churn='Yes' then 1 end)*100/count(*) as churn_rate,
avg(case when churn='Yes' then monthlycharges end) as churn_monthly_charges ,
avg(case when churn='Yes' then tenure end) as churn_tenure from customer_churn
group by internetservice
having customers >= 500 
order by churn_rate desc ;


select contract,
count(*) as customers,
count(case when churn ='Yes' then 1 end )as churn_cust, 
avg(case when churn ='Yes'  then totalcharges end ) as avg_churn_charges
from customer_churn
group by contract 
having churn_cust >= 200
order by avg_churn_charges desc
limit 1; 



select paymentmethod,
count(*) as customers,
count(case when churn ='Yes' then 1 end )as churn_cust,
count(case when churn ='Yes' then 1 end)*100/count(*) as churn_rate, 
avg(monthlycharges) as avgcharges,
avg(tenure) as avgtenure
from customer_churn
group by paymentmethod
having count(*) >= 300
order by churn_rate desc
limit 2;


with high_cust as (select customerid,contract,totalcharges,
 dense_rank() over( partition by contract 
 order by totalcharges desc ) as rnk from customer_churn)
 select contract,customerid,totalcharges,rnk
from high_cust 
where rnk = 1;
 
with avg_charges as (
select customerid, contract,monthlycharges,avg(monthlycharges) over( partition by contract) as contract_avg_charges
from customer_churn)
select customerid,contract,monthlycharges,contract_avg_charges,
monthlycharges-contract_avg_charges as difference 
from avg_charges 
where monthlycharges > contract_avg_charges
order by difference desc;


with overall_churn as ( select
count(case when churn='Yes' then 1 end) *100 / count(*) as overall_churn_rate from customer_churn),
contract_churn as( select contract,
count(case when churn='Yes' then 1 end) *100 / count(*) as contract_churn_rate
from customer_churn
group by contract)
select c.contract,
o.overall_churn_rate,
c.contract_churn_rate,
c.contract_churn_rate - o.overall_churn_rate as difference from contract_churn c 
cross join overall_churn o
order by difference desc;


select contract,internetservice,
count(*) as customers,
count(case when churn ='Yes' then 1 end) as churned_cust,
count(case when churn='Yes' then 1 end )*100/count(*) as churn_rate,
avg(monthlycharges) as avg_charges ,
avg(tenure) as avg_tenure  from customer_churn
group by contract,internetservice
having count(*) >= 100
order by churn_rate desc 
limit 5;

with ranked_cust as(
select customerid,
internetservice,
monthlycharges,
dense_rank() over(partition by internetservice order by monthlycharges desc) as rnk from customer_churn)
select customerid,internetservice,monthlycharges,rnk from ranked_cust 
where rnk = 3;


select paymentmethod,
count(*) as customers,
count(case when churn ='Yes' then 1 end ) as churn_cust ,
count(case when churn ='Yes' then 1 end)*100.0/count(*) as churn_rate
from customer_churn
group by paymentmethod
having count(*) >= 300
order by churn_rate desc;


with ranked_cust as (
select customerid,
contract,
totalcharges,
row_number() over (partition by contract order by totalcharges desc) as rnk from customer_churn)
select contract,customerid ,rnk,
totalcharges from ranked_cust where  rnk =2 ;

























































































