/* NETFLIX REVIEWS ANALYSIS PROJECT
Author: Oyefejo Olaseni Ifeoluwa
Goal: Identify technical friction points to improve user retention.
*/

USE netflix_reviews;

-- Data Cleaning
ALTER TABLE data MODIFY COLUMN datetime DATETIME;
ALTER TABLE data MODIFY COLUMN unique_ref_id VARCHAR(255) NOT NULL;
ALTER TABLE data ADD PRIMARY KEY (unique_ref_id);

-- The "Bridge" View (The Central Station for Power BI)
CREATE OR REPLACE VIEW v_bridge_versions AS
SELECT 
    app_version,
    COUNT(*) AS reviews,
    AVG(rating) AS avg_rating
FROM data
WHERE app_version IS NOT NULL
GROUP BY app_version;

-- 1. Exploratory Data Analysis (EDA)
-- Check volume trends by year to see dataset growth
SELECT 
	year(datetime) as Year,
    count(datetime) as Reviews
FROM data
GROUP BY Year
ORDER BY Year DESC;

-- 2. Business Question: Top 10 Categories driving the lowest ratings? 
SELECT
	category,
    count(category) as reviews
FROM data
WHERE rating < 4
GROUP BY category
ORDER BY reviews DESC
LIMIT 10;


-- 3. Business Question: Which app versions have the highest failure rate?
-- Identifies if specific updates caused a spike in negative sentiment
CREATE OR REPLACE VIEW v_app_stability AS
SELECT 
    app_version,
    COUNT(*) AS Total_reviews,
    SUM(CASE WHEN rating < 4 THEN 1 ELSE 0 END) AS Low_rate,
    ROUND(SUM(CASE WHEN rating < 4 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS Failure_rate_pct
FROM data
WHERE App_version IS NOT NULL
GROUP BY App_version
ORDER BY App_version DESC
LIMIT 10;

-- 4. Business Question: What is the #1 complaint for the latest versions?
CREATE OR REPLACE VIEW v_top_complaints AS
WITH CategoryRank AS (
	SELECT 
		app_version,
        category,
        COUNT(*) as issue_count,
        ROW_NUMBER() OVER(PARTITION BY app_version ORDER BY COUNT(*) DESC) as rnk
    FROM data
    WHERE rating <= 3 
	AND app_version IS NOT NULL
    GROUP BY app_version, category
)
SELECT 
    app_version,
    category AS primary_complaint,
    issue_count
FROM CategoryRank
WHERE rnk = 1
ORDER BY app_version DESC
LIMIT 10;

-- 5. Trend Analysis: Monthly Rating Momentum
-- Tracks MoM (Month-over-Month) performance
SELECT 
    DATE_FORMAT(datetime, '%Y-%m') AS review_month,
    ROUND(AVG(rating), 2) AS avg_rating,
    ROUND(LAG(AVG(rating)) OVER (ORDER BY DATE_FORMAT(datetime, '%Y-%m')), 2) AS prev_month_avg,
    ROUND(AVG(rating) - LAG(AVG(rating)) OVER (ORDER BY DATE_FORMAT(datetime, '%Y-%m')), 2) AS rating_delta
FROM data
GROUP BY review_month
ORDER BY review_month DESC;

-- 6. Qualitative Insight: High-Impact Negative Feedback
-- Finds reviews that many other users agreed with (High Thumbs Up)
SELECT 
    category,
    review,
    thumbs_up_count,
    rating
FROM data
WHERE rating <= 3 
ORDER BY thumbs_up_count DESC
LIMIT 10;
