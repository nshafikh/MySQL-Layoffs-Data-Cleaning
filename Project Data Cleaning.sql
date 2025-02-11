-- Data Cleaning

SELECT *
FROM layoffs;

-- 1. Remove duplicates
-- 2. Standardize the data
-- 3. Null or blank values
-- 4. Remove any columns

-- Creates empty table with same columns as raw table
CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

-- Populates staging table with data from raw table
INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

SELECT * 
FROM layoffs_staging;

-- 1. Remove duplicates
-- ----------------------------------------------------------------
-- Pinpoint duplicates
WITH duplicate_cte AS
(
SELECT company,
	location,
	industry, 
	stage,
	country,
    `date`,
	ROW_NUMBER() OVER(PARTITION BY company,
					  location,
					  industry, 
                      stage,
                      `date`,
                      country) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Check example: Better.com
SELECT *
FROM layoffs_staging
WHERE company = 'Better.com';
-- Stage is Unknown, let's look at different stages

-- Unique stages
SELECT DISTINCT stage
FROM layoffs_staging;
-- Only one unknown stage type

-- Let's change 'Unknown' to null
UPDATE layoffs_staging
SET stage = NULL 
WHERE stage LIKE 'unknown';

-- Unique stages
SELECT DISTINCT stage
FROM layoffs_staging;
-- Unknown is now NULL

-- Check duplicate examples again
WITH duplicate_cte AS
(
SELECT company,
	location,
	country,
	industry, 
	stage,
    `date`,
	ROW_NUMBER() OVER(PARTITION BY company,
					  location,
					  industry, 
                      stage,
                      `date`,
                      country) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Select example company: StockX
SELECT *
FROM layoffs_staging
WHERE company LIKE 'stockx';
-- Looks like there were two separate layoffs on the same day in different departments of the company?
-- Original approach was to remove the duplicate, but we may lose valuable data 
-- Can't combine rows with certainty because the percentage laid off value can't be determined (unsure of chronological order of layoffs)

-- Change duplicate criteria: include total and percentage laid off, and funds raised values as well
WITH duplicate_cte AS
(
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company,
					  location,
					  industry, 
                      total_laid_off,
                      percentage_laid_off,
                      `date`,
                      stage,
                      country,
                      funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- Select example company: Cazoo
SELECT *
FROM layoffs_staging
WHERE company LIKE 'cazoo';
-- Duplicate row, let's make another staging table and delete these

CREATE TABLE `layoffs_staging_2` (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO
layoffs_staging_2
SELECT *,
	ROW_NUMBER() OVER(PARTITION BY company,
					  location,
					  industry, 
                      total_laid_off,
                      percentage_laid_off,
                      `date`,
                      stage,
                      country,
                      funds_raised_millions) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging_2
WHERE row_num>1;

DELETE
FROM layoffs_staging_2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging_2
WHERE row_num > 1;

-- 2. Standardizing Data
-- -------------------------------------------------------------------

-- Remove leading and trailing white spaces
UPDATE layoffs_staging_2
SET company = TRIM(company);
-- NOTE: We don't need to worry with this dataset, but might be good to do some standardization before removing duplicates
	-- Would have helped us find the 'Unknown' stage type as well as company names with issues

-- Review columns and see what needs to be standardized

-- Industry
SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY industry;
-- Redundant instances of Crypto with different names
-- NOTE: Nulls and white spaces as well, but we will handle those later
-- Would be a good idea to handle these sooner as well
    
-- Handle Crypto redundancies
UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';
	    
-- Location
SELECT DISTINCT location
FROM layoffs_staging_2
ORDER BY location;
-- Looks good
    
-- Country
SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY 1;
-- United States and United States
    
-- Clean United States 
UPDATE layoffs_staging_2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'united states%';

-- Change date from string to date
UPDATE layoffs_staging_2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date` FROM layoffs_staging_2;

ALTER TABLE layoffs_staging_2
MODIFY COLUMN `date` DATE;

-- 3. Null or blank values
-- ------------------------------------------------------------

-- Checking where total and percentage laid off are null
-- These will be removed in step 4 (not deleting rows yet)
SELECT *
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Industry
SELECT *
FROM layoffs_staging_2
WHERE industry IS NULL
	OR industry = '';
    
-- Airbnb is blank
SELECT *
FROM layoffs_staging_2
WHERE company = 'Airbnb';
-- We can see that Airbnb is a travel company based on their private equity stage
    
-- Let's first set blanks to null in industry
UPDATE layoffs_staging_2
SET industry = NULL
WHERE industry = '';
    
-- Let's see if we can do this for all companies
SELECT *
FROM layoffs_staging_2 l1
JOIN layoffs_staging_2 l2
ON l1.company = l2.company and l1.location = l2.location
WHERE l1.industry IS NULL
	AND l2.industry IS NOT NULL;
    
-- Update
UPDATE layoffs_staging_2 l1
	JOIN layoffs_staging_2 l2
    ON l1.company = l2.company and l1.location = l2.location
SET l1.industry = l2.industry
WHERE l1.industry IS NULL
	AND l2.industry IS NOT NULL;

-- Bally's is still null, let's check if another instance is there
SELECT *
FROM layoffs_staging_2
WHERE company LIKE '%Bally%';
-- No other Bally's
    
-- We can't really handle nulls anymore
-- Values are unknown and can't assume or derive

-- Even though there are reasons not to delete...
-- We will delete rows with empty laid off values in both columns
DELETE
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
	AND percentage_laid_off IS NULL;
    
    
-- 4. Remove any unnecessary columns
-- ----------------------------------------------------------------

ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;

SELECT * FROM layoffs_staging_2;

