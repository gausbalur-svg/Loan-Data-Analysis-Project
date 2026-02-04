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
