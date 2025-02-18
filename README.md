# MySQL Data Cleaning: Layoffs Dataset

## Project Overview:
This project focuses on **cleaning and standardizing** a dataset containing information on company layoffs. The dataset includes details such as company names, locations, industries, funding, and layoff statistics. The goal is to ensure data quality by removing duplicates, handling missing values, standardizing formats, and improving overall data integrity.

## Skills Demonstrated
- **Data Cleaning in SQL**: Removing duplicates, handling null values, and standardizing data.
- **CTE (Common Table Expressions)**: Using `WITH` statements for duplicate detection.
- **Window Functions**: Applying `ROW_NUMBER()` to identify and remove duplicate records.
- **String Manipulation**: Cleaning white spaces, correcting inconsistent values.
- **Data Type Conversion**: Converting text-based dates to `DATE` format.
- **Database Optimization**: Removing unnecessary columns for efficiency.

## Key Steps
1. **Remove Duplicates**
   - Identified duplicates using `ROW_NUMBER()`.
   - Adjusted criteria to preserve meaningful duplicate records.
   - Deleted redundant entries.
2. **Standardize Data**
   - Trimmed white spaces in text fields.
   - Unified industry names (e.g., consolidating different "Crypto" variations).
   - Standardized country names (e.g., fixing "United States.").
3. **Handle NULL or Blank Values**
   - Replaced blank industry values with `NULL`.
   - Used self-joins to fill missing industries where possible.
   - Removed records with insufficient data.
4. **Optimize Database Structure**
   - Converted date strings into `DATE` type.
   - Dropped unnecessary helper columns.

## Potential Next Steps
- Perform Exploratory Data Analysis (EDA) on the cleaned dataset. (ALREADY DONE, LINK: https://github.com/nshafikh/MySQL-Layoffs-EDA)
- Create visualizations to analyze layoff trends.
- Apply machine learning to predict layoffs based on company attributes.
