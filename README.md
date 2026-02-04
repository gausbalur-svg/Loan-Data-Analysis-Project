# Loan-Data-Analysis-Project

## Project Overview
This project focuses on loan application data cleaning, transformation, and exploratory data analysis (EDA) using SQL. 
The goal is to prepare raw loan datasets for analysis, handle missing values, and extract meaningful business insights related to loan approvals,
applicant demographics, and financial patterns.

## Purpose of Presentation
- The purpose of this project presentation is to:
- Showcase SQL data cleaning techniques for handling missing values, inconsistent data, and type conversions.
- Demonstrate how EDA queries can uncover actionable insights for financial decision-making.
- Provide a structured analysis that helps stakeholders understand loan approval trends across demographics, income groups, and property areas.
- Highlight the importance of credit history and financial behavior in loan approvals, beyond just income levels.
- Serve as a portfolio-ready project that illustrates practical SQL skills, business intelligence thinking, and data storytelling.

## Data Preparation & Cleaning
* **Created tables (card_1, card_2) with applicant and loan details.**

    * Standardized Dependents column:

    * Converted '3+' values to 4.

    * Changed data type from text to int.

    * Replaced NULL values with 0.
*  **Handled missing values:**

   * Filled self_employed with 'No'.

   * Replaced missing credit_history with 0.

   * Imputed missing loanamount and loan_amount_term using average values.

   * Updated loan_status based on applicant income thresholds.

   * Removed incomplete records with missing critical fields (loan_id, gender, married).
 
## 📊 Exploratory Data Analysis (EDA)

 **Key business questions addressed:**

* Loan Approval by Demographics

``select * from card_2;``

Compared approval rates across Gender, Education, and Marital Status.

`SELECT 	Gender ,Education , married,
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
`
**Impact of Credit History**

* Measured how credit history influences loan approval rates.

  ``SELECT credit_history,
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
``

**Income vs Loan Amount**

* Grouped applicants into Lower, Middle, Higher Income categories.

`SELECT 
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
`

* Analyzed whether higher-income applicants receive larger loans.

  `SELECT 
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
` 

**Property Area Analysis**

* Identified which property areas have the highest loan approval rates.

 ``
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
``


**Loan-to-Income Ratio**

* Calculated average loan-to-income ratio for approved loans.

  `select
	round(avg(loanamount::numeric/nullif(applicantincome,0)),2) as avg_loan_ratio,
	avg(loanamount) as avg_loanamount
	from card_2
	where loan_status ='Y';
`

**Top Applicants**

 * Listed top 10 highest-income applicants not approved.

`
select loan_id,credit_history,
 		applicantincome 
		 from card_2
where  loan_status ='N'
order by applicantincome desc limit 10
`
Listed top 10 applicants with the highest loan amounts approved.

`
select loan_id,credit_history,
		Gender ,
		Education ,
		married,
 		applicantincome 
		 from card_2
where  loan_status ='Y'
order by applicantincome desc limit 10
`

**Loan Term Analysis**

* Counted approved applicants with loan terms < 180 days, grouped by property area.

`
SELECT 
 	property_area,
 	COUNT(*) AS TOTAL_APPLICANTS
FROM CARD_2
where loan_amount_term < 180 and loan_status ='Y'
group by 1;
`
**Gender-Based Loan Requests**

* Compared average loan amounts requested by male vs female applicants.

`SELECT 
	gender,
	round(avg(loanamount),2) as avg_loanamount
from card_2
group by 1;
`
**High-Income Non-Approvals**

* Listed top 5 highest-income applicants who were not approved, including income, loan amount, and education.

`
SELECT 
	loan_id,
	applicantincome,
	loanamount,
	education 
from card_2
where loan_status ='N'
order by applicantincome desc limit 5
`

