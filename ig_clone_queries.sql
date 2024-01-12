-- General Exploration
SELECT * FROM users ORDER BY created_at; -- 2016 to 2017 users

-- Q1: 5 Oldest Users
SELECT * 
FROM users
ORDER BY created_at
LIMIT 5;

-- Q2: Day of the week most users register on? High traffic days
SELECT 
	DAYNAME(created_at) AS day_of_week,
	COUNT(*) AS per_day_user_reg_count
FROM users
GROUP BY day_of_week WITH ROLLUP
ORDER BY per_day_user_reg_count DESC;

-- Q3: Who are our inactive users (users with bo photos posted)
CREATE OR REPLACE VIEW inactive_users AS 
	SELECT 
		username,
        COUNT(photos.user_id) AS photos_posted
	FROM users
    LEFT JOIN photos on users.id=photos.user_id
    GROUP BY username
    HAVING photos_posted=0; -- Alt 1, counting
    
CREATE OR REPLACE VIEW inactive_users_null AS 
	SELECT 
		username
	FROM users
    LEFT JOIN photos on users.id=photos.user_id
    WHERE photos.id IS NULL; -- Alt 2, null values Error Code: 1054. Unknown column 'photo.id' in 'where clause'

    
SELECT * FROM inactive_users; -- list of inactive users, Alt1
SELECT * FROM inactive_users_null; -- list of inactive users, Alt2

SELECT COUNT(*) FROM inactive_users; -- 26 users

-- Q4: What photo has the most number of likes
SELECT
	(SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS avg; -- Alt 1: Direct average

SELECT
	AVG(photo_count)
FROM (
	SELECT
		COUNT(id) AS photo_count -- makes this a column
	FROM photos
    GROUP BY user_id
    ) AS table_photo_count; -- Alt 2: average of average number of photos per user
    
-- Q5: Top 5 most commonly used hashtags
SELECT
	tag_name,
    COUNT(tag_id) AS tag_use
FROM tags
JOIN photo_tags ON photo_tags.tag_id=tags.id
GROUP BY tag_name
ORDER BY tag_use DESC
LIMIT 5;

-- Q6: Find bots: Users who have liked every single photo
SELECT
	username,
    COUNT(user_id) AS like_count
FROM users
JOIN likes ON likes.user_id=users.id
GROUP BY user_id
HAVING like_count=(SELECT COUNT(*) FROM photos AS total_photos);




