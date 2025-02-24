# MySQL Data Cleaning & EDA: Layoffs Dataset

## Part 1: Cleaning
### Project Overview:
This project focuses on **cleaning and standardizing** a dataset containing information on company layoffs. The dataset includes details such as company names, locations, industries, funding, and layoff statistics. The goal is to ensure data quality by removing duplicates, handling missing values, standardizing formats, and improving overall data integrity.

### Skills Demonstrated
- **Data Cleaning in SQL**: Removing duplicates, handling null values, and standardizing data.
- **CTE (Common Table Expressions)**: Using `WITH` statements for duplicate detection.
- **Window Functions**: Applying `ROW_NUMBER()` to identify and remove duplicate records.
- **String Manipulation**: Cleaning white spaces, correcting inconsistent values.
- **Data Type Conversion**: Converting text-based dates to `DATE` format.
- **Database Optimization**: Removing unnecessary columns for efficiency.

### Key Steps
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

### Potential Next Steps
- Perform Exploratory Data Analysis (EDA) on the cleaned dataset. (ALREADY DONE, LINK: https://github.com/nshafikh/MySQL-Layoffs-EDA)
- Create visualizations to analyze layoff trends.
- Apply machine learning to predict layoffs based on company attributes.

## Part 2: EDA
### Project Overview:
This project is a **follow-up** to the **data cleaning** project for the layoffs dataset. The goal here is to conduct **Exploratory Data Analysis (EDA)** to uncover insights about company layoffs, trends, industries most impacted, and more. Various SQL queries were used to explore the dataset, generate summary statistics, and identify key patterns.

### Skills Demonstrated:
- **Exploratory Data Analysis (EDA) in SQL**: Running complex queries to analyze trends and patterns.
- **Aggregation and Summarization**: Using `SUM()`, `COUNT()`, and `MAX()` to aggregate and summarize data.
- **Window Functions**: Applying `SUM() OVER` for cumulative totals and comparisons.
- **Data Grouping**: Grouping by industry, location, and company to understand broader trends.
- **Filtering**: Identifying companies with the highest layoffs, funding, and trends by year.

### Key Steps:

#### 1. Data Exploration
- Examined the dataset for rows with missing or null values.
- Investigated companies with the highest layoffs and those that went under.

#### 2. Aggregated Data
- Aggregated layoffs by year, country, and industry.
- Identified trends in layoffs across different stages and funding levels.

#### 3. Time-Based Analysis
- Performed analysis of layoffs over time, including monthly rolling sums.
- Focused on the impact of COVID-19 lockdowns and trends from 2020–2023.

#### 4. Insights and Trends
- Identified key industries and countries hit hardest by layoffs.
- Highlighted specific companies and industries with significant layoffs during the pandemic.

### Key Findings:
- The **largest layoffs** occurred in the tech industry, particularly among major players like **Amazon** and **Google**.
- Layoffs peaked **in January 2023**, with over **84,000 employees** let go.
- The **Bay Area** and the **West Coast** were the most affected regions in the U.S.
- Several companies, especially in **education**, **healthcare**, and **finance**, experienced major layoffs in 2022–2023.

### Potential Next Steps:
- Create **visualizations** to enhance the analysis and communicate insights.
- **Predict** layoffs using machine learning based on company characteristics.
- Investigate **other features** in the dataset, such as funding stages and industries, to explore correlations.

