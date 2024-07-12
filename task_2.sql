-- Create a temporary table to hold the data
CREATE TEMPORARY TABLE temp_data (
    itemid INT,
    category VARCHAR(50),
    date DATE,
    price DECIMAL(10, 2),
    sold INT,
    stock INT,
    priority VARCHAR(50)
);

-- Insert the given data into the temporary table
INSERT INTO temp_data (itemid, category, date, price, sold, stock, priority) VALUES
(23, NULL, '2021-08-01', 5000, 5, 95, 'High'),
(23, 'medior', '2021-08-02', 5000, 6, 94, NULL),
(23, 'medior', '2021-08-03', NULL, NULL, NULL, 'High'),
(55, 'lower', '2021-09-10', NULL, 12, 88, 'High'),
(55, 'lower', '2021-09-11', 1000, 22, 78, 'High'),
(55, NULL, '2021-09-12', 1000, NULL, NULL, 'High'),
(10, 'upper', '2021-08-15', NULL, 32, 68, 'Low'),
(10, 'upper', '2021-08-16', 3000, 32, 68, NULL);


-- Update category for items where it is NULL
UPDATE temp_data t1
SET category = (
    SELECT MAX(category)
    FROM temp_data t2
    WHERE t1.itemid = t2.itemid AND t2.category IS NOT NULL
)
WHERE t1.category IS NULL;

-- Update priority for items where it is NULL
UPDATE temp_data t1
SET priority = (
    SELECT MAX(priority)
    FROM temp_data t2
    WHERE t1.itemid = t2.itemid AND t2.priority IS NOT NULL
)
WHERE t1.priority IS NULL;

-- Update sold values for items where it is NULL
UPDATE temp_data t1
SET sold = (
    SELECT t2.sold
    FROM temp_data t2
    WHERE t1.itemid = t2.itemid AND t2.date < t1.date
    ORDER BY t2.date DESC
    LIMIT 1
)
WHERE t1.sold IS NULL;

-- Update stock values for items where it is NULL
UPDATE temp_data t1
SET stock = (
    SELECT t2.stock
    FROM temp_data t2
    WHERE t1.itemid = t2.itemid AND t2.date < t1.date
    ORDER BY t2.date DESC
    LIMIT 1
)
WHERE t1.stock IS NULL;

-- Select the updated data
SELECT * FROM temp_data ORDER BY itemid ASC, date ASC;