


CREATE TABLE card_2(
Loan_ID	text,
Gender	varchar(50),
Married	varchar(50),
Dependents	text,
Education	varchar(50),
Self_Employed	varchar(50),
ApplicantIncome	int,
CoapplicantIncome	numeric(10,2),
LoanAmount	int,
Loan_Amount_Term	int,
Credit_History	int,
Property_Area	varchar(50),
Loan_Status	varchar(50)

);
drop table card_2 ;

select * from card_1;
select * from card_2;
-- cleaning the data 

update card_1
set dependents = 4
where dependents = '3+'


alter table  card_1
alter  column dependents type int
using dependents:: integer;

update card_1
set dependents = 0
where dependents is null;
--NULL values


update card_2
set dependents =4
where dependents ='3+'

alter table card_2
alter column dependents type int
using dependents :: integer;

SELECT *
FROM card_2
WHERE loan_id IS NULL
   OR gender IS NULL
   OR married IS NULL
   OR dependents IS NULL
   OR education IS NULL
   OR self_employed IS NULL
   OR applicantincome IS NULL
   OR coapplicantincome IS NULL
   OR loanamount IS NULL
   OR loan_amount_term IS NULL
   OR credit_history IS NULL
   OR property_area IS NULL
   OR loan_status IS NULL;

   --null value 
   update card_2
  set self_employed = 'No'
  where self_employed is null

   update card_2
  set dependents = 0
  where dependents is null
   update card_2
  set credit_history = 0
  where dependents is null ;


  

UPDATE card_2
SET loan_status = sub.status
FROM (
    SELECT 
        loan_id,
        CASE 
            WHEN loan_status::numeric <= (SELECT AVG(applicantincome) FROM card_2) THEN 'Y'
            ELSE 'N'
        END AS status
    FROM card_2
) sub
WHERE card_2.loan_id = sub.loan_id
  AND card_2.loan_status IS NULL;


update card_2
set loanamount = sub.avg_amount
from (
	select avg(loanamount) as avg_amount
	from card_2) sub
where card_2.loanamount is null;

update card_2
	set loan_amount_term  = sub.avg_term
	from 
		(select avg(loan_amount_term) as avg_term
		from card_2) sub
where card_2.loan_amount_term is null;

UPDATE card_2
SET credit_history = CASE
    WHEN loan_status = 'N' THEN 0
    WHEN loan_status = 'Y' THEN 1
END
WHERE credit_history IS NULL;

DELETE FROM card_2
WHERE loan_id IS NULL
   OR gender IS NULL
   OR married IS NULL;

 --EDA 


-- Count total records in each table

select count(*) from card_2;

-- Check mismatched ApplicantIncome vs CoapplicantIncome types
select loan_id, applicantincome,coapplicantincome
from card_2
where applicantincome<>coapplicantincome;

select loan_id, applicantincome,coapplicantincome
from card_1
where applicantincome>coapplicantincome
order by applicantincome desc ;

--Count distinct IDs in each table

select count(distinct loan_id ) from card_2;



-- 				BUSINESS RPOBLEM
		
--Q1.Which demographic groups (Gender, Education, Marital Status)
--have the highest loan approval rates?
SELECT 	Gender ,Education , married,
	COUNT(*) AS TOTAL_APPLICANT,
	 SUM(CASE
		 	WHEN loan_status = 'Y' then 1
			 else 0 
			 end) as Approved ,
	
	round(100.0*sum(case 
	when loan_status = 'Y' then 1 
	else 0 
	end)/count(*),2) as approval_rate
	from card_2
group by Gender ,Education , married
order by approval_rate ;

--Q2. How much does credit history influence loan approval?
 SELECT credit_history,
 	 COUNT(*) AS total_applicants, 
	  sum(
			case
			 when loan_status ='Y' then 1 
			 else 0 end) AS approval,
	round(100.0*sum(case
			when loan_status ='Y' then 1
			else 0 end)/count(*),2) AS approval_rate
FROM card_2
group by credit_history 
order by approval_rate;

--Q3 Do higher-income applicants get larger loans?

SELECT 
 	CASE 
	 	WHEN applicantincome <2000 then 'Lower Income'
		WHEN applicantincome  BETWEEN 2000 AND 5000 THEN 'Middle Income'
		ELSE 'Higher Income'
		END as income_group,
		round(avg(loanamount),3) as avg_loan,
		round(avg(applicantincome),2) as avg_income
from card_2
group by income_group 
order  by avg_loan desc;



--Q4.Which property areas have the highest loan approvals?
select  property_area,
	count(*) as total_applicants,
	sum( case 
		when loan_status = 'Y' then 1 
		else 0 end) as approve,
		round(100.0*sum(case 
			when loan_status = 'Y' then 1
			else 0 end)/count(*),2) as approval_rate
from card_2
group by 1
order by 3;
	
--Q5.What is the average loan-to-income ratio for approved loans?

select
	round(avg(loanamount::numeric/nullif(applicantincome,0)),2) as avg_loan_ratio,
	avg(loanamount) as avg_loanamount
	from card_2
	where loan_status ='Y';

-- Q6. find the 10  income of applicants at not get the approval of loan 
 select loan_id,credit_history,
 		applicantincome 
		 from card_2
where  loan_status ='N'
order by applicantincome desc limit 10
--Who are the top 10 applicants with the highest loan amounts approved?
select loan_id,credit_history,
		Gender ,
		Education ,
		married,
 		applicantincome 
		 from card_2
where  loan_status ='Y'
order by applicantincome desc limit 10

--Q7. Identify how many applicants with a loan term of less than 180 days were approved for a loan. 
--Group the results by property area.

SELECT 
 	property_area,
 	COUNT(*) AS TOTAL_APPLICANTS
FROM CARD_2
where loan_amount_term < 180 and loan_status ='Y'
group by 1;

 --Q8.Calculate the average loan amount for male vs female applicants.
 --Which gender tends to request higher loans?

SELECT 
	gender,
	round(avg(loanamount),2) as avg_loanamount
from card_2
group by 1;

--Q9.List the top 5 highest-income applicants who were not approved for a loan.
--Include their income, loan amount, and education.
SELECT 
	loan_id,
	applicantincome,
	loanamount,
	education 
from card_2
where loan_status ='N'
order by applicantincome desc limit 5
	
