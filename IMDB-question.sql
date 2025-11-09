USE imdb;


/* Now that I have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, I will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
SELECT COUNT(*) AS no_of_rows_in_movie FROM movie ;
SELECT COUNT(*) AS no_of_rows_in_ratings FROM ratings ;
SELECT COUNT(*) AS no_of_rows_in_names FROM names ;
SELECT COUNT(*) AS no_of_rows_in_genre FROM genre;
SELECT COUNT(*) AS no_of_rows_in_role_mapping FROM role_mapping;
SELECT COUNT(*) AS no_of_rows_in_director_mapping FROM director_mapping;

-- There are 7997 rows in movie table
-- There are 7997 rows in ratings table
-- There are 25735 rows in names table
-- There are 15615 rows in genre table
-- There are 14662 rows in role_mapping table
-- There are 3867 rows in director_mapping table


-- Q2. Which columns in the movie table have null values?

SELECT
	SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_nulls,
	SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_nulls,
    SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_nulls,
	SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_nulls,
    SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_nulls,
    SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_nulls,
    SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_nulls
FROM
	movie;

-- Columns with null values are : country, world_wide_gross, languages, production_comany

-- Now as I can see four columns of the movie table has null values. Let's look at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT
	year AS Year,
    count(id) AS number_of_movies
FROM
	movie
GROUP BY
	Year ;

-- Number of movies released in each year are- 2017: 3052, 2018: 2944, 2019: 2001

SELECT 
	MONTH(date_published) AS month_num,
    COUNT(*) AS number_of_movies
FROM
	movie
GROUP BY
	month_num
ORDER BY
	month_num ;

-- Highest number of movies are released in 2017 and in march


/*The highest number of movies is produced in the month of March.
So, now that I have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??

SELECT
	COUNT(id) AS number_of_movies
FROM
	movie
WHERE
	(LOWER(country) LIKE '%india%'
          OR LOWER(country) LIKE "%usa%")
    AND
    year = 2019;


-- There are total 1059 movies produced in USA or India


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
SELECT DISTINCT genre
FROM genre;

-- The distinct genres are : 'Drama','Fantasy','Thriller','Comedy','Horror','Family','Romance','Adventure','Action','Sci-Fi','Crime','Mystery','Others'


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t we want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
SELECT
	genre,
    COUNT(*) AS number_of_movies
FROM
	genre g
INNER JOIN
	movie m
    ON
    g.movie_id = m.id
GROUP BY
	genre
ORDER BY
	number_of_movies DESC LIMIT 1;

-- Drama genre has the highest number of movie released with 4285 movies released.


/* So, based on the insight that I just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
SELECT COUNT(*) AS number_of_movies_with_one_genre
FROM
(
	SELECT id, COUNT(genre) AS number_of_genre FROM movie m 
	INNER JOIN genre g ON m.id = g.movie_id
	GROUP BY id, title
	HAVING number_of_genre = 1
) AS movies_with_one_genre;

-- There are total of 3289 movies having only one genre


/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT
	genre,
    AVG(duration) AS avg_duration
FROM
	movie m
INNER JOIN
	genre g
    ON
    g.movie_id = m.id
GROUP BY
	genre
ORDER BY
	avg_duration DESC;

-- Highest average duration are of Action genre


/* Now I know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/

WITH number_of_movies_per_genre AS
(
	SELECT
		genre,
		COUNT(id) AS number_of_movies,
		RANK() OVER (ORDER BY COUNT(id) DESC) AS genre_rank
	FROM
		genre g
	INNER JOIN
		movie m
		ON
		g.movie_id = m.id
	GROUP BY
		genre
)
SELECT *
FROM number_of_movies_per_genre
WHERE
	genre_rank = 3;
    
-- Thriller genre have a rank of 3 with a total of 1484 movies.


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, I analysed the movies and genres tables. 
 In this segment, I will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/


-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|max_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/

SELECT 
    MIN(avg_rating) AS min_avg_rating,
    MAX(avg_rating) AS max_avg_rating,
    MIN(total_votes) AS min_total_votes,
    MAX(total_votes) AS max_total_votes,
    MIN(median_rating) AS min_median_rating,
    MAX(median_rating) AS max_median_rating
FROM ratings;

-- min_avg_rating | max_avg_rating | min_total_votes max_total_votes, min_median_rating, max_median_rating
-- 		1.0,	  |		 10.0,	   |	 100, 			725138,			 	1,					 10

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/

SELECT * FROM (
	SELECT
		title,
		avg_rating,
		DENSE_RANK() OVER (ORDER BY avg_rating DESC) AS movie_rank
	FROM
		movie m
	INNER JOIN
		ratings r
		ON
		m.id = r.movie_id
) AS highest_rated_movies
WHERE
	movie_rank<=10;

-- Kirket and Love in Kilnerry are at the 1st Rank with with an average raing of 10.0. 


/*
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT
	median_rating,
    COUNT(movie_id) as movie_count
FROM ratings
GROUP BY
	median_rating
ORDER BY
	movie_count DESC;

/* Movies with a median rating of 7 are highest in number. 


Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/

WITH top_production_company AS
(
	SELECT
		production_company,
		COUNT(id) AS movie_count,
		RANK() OVER (ORDER BY COUNT(id) DESC) AS prod_company_rank
	FROM
		movie m
	INNER JOIN
		ratings r 
		ON m.id = r.movie_id
	WHERE
		avg_rating > 8
		AND
		production_company IS NOT NULL
	GROUP BY
		production_company
)
SELECT
	*
FROM
	top_production_company
WHERE
	prod_company_rank = 1 ;

-- Answer can be Dream Warrior Pictures or National Theatre Live or both


-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */

SELECT
	genre,
    COUNT(g.movie_id) AS movie_count
FROM
	genre g
INNER JOIN
	movie m
    ON
	g.movie_id = m.id
INNER JOIN
	ratings r
    ON
    g.movie_id = r.movie_id
WHERE
	country LIKE "%USA%"
    AND
    MONTH(date_published) = 3 AND YEAR(date_published) = 2017
    AND
    total_votes > 1000
GROUP BY
	genre
ORDER BY
	movie_count DESC;

/* Answer: movies released in each genre during March 2017 in the USA had more than 1,000 votes:

Drama : 24 , Comedy: 9, Action: 8, Thriller: 8, Sci-Fi: 7, Crime: 6, Horror: 6, Mystery: 4, Romance: 4, Fantasy: 3, Adventure: 3, Family: 1


-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/

SELECT
	title,
	avg_rating,
    genre
FROM
	genre g
INNER JOIN
	movie m
    ON
	g.movie_id = m.id
INNER JOIN
	ratings r
    ON
    g.movie_id = r.movie_id
WHERE
	LOWER(title) LIKE ("the%")
    AND
    avg_rating > 8
ORDER BY
	avg_rating DESC;


-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?

SELECT
	median_rating,
    COUNT(m.id) as num_of_movies
FROM
	movie m
INNER JOIN
	ratings r
    ON
	m.id = r.movie_id
WHERE
	date_published BETWEEN '2018-04-01' AND '2019-04-01'
    AND
    median_rating = 8;

 -- There are 361 movies with the median rating of 8 and released between 1 April 2018 and 1 April 2019. 

-- Q17. Do German movies get more votes than Italian movies?

SELECT
	languages, 
    SUM(total_votes) as total_votes
FROM
	movie m
INNER JOIN
	ratings r
    ON
	m.id = r.movie_id
WHERE
	languages LIKE "%German%" OR country LIKE "%Italian%" 
GROUP BY
	languages;

-- Answer is Yes

/* Now that I have analysed the movies, genres and ratings tables, let me now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

SELECT
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls,
	SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls
FROM
	names;


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
WITH top_three_genres AS 
(
	SELECT
		genre,
		COUNT(m.id) AS num_of_movies
	FROM
		movie m
	INNER JOIN
		genre g
		ON m.id = g.movie_id
	INNER JOIN
		ratings r
		ON m.id = r.movie_id
	WHERE
		avg_rating > 8
	GROUP BY
		genre 
	ORDER BY
		num_of_movies DESC
	LIMIT 3
)
SELECT
	name AS director_name,
    COUNT(m.id) AS movie_count
FROM
	movie m
INNER JOIN
	director_mapping d
		ON m.id = d.movie_id
INNER JOIN
	names n
		ON d.name_id = n.id
INNER JOIN
	ratings r
	ON m.id = r.movie_id
INNER JOIN genre g
	ON m.id = g.movie_id
INNER JOIN
	top_three_genres tg
		ON g.genre = tg.genre
WHERE
    r.avg_rating > 8
GROUP BY
	director_name
ORDER BY
	movie_count DESC LIMIT 3;

-- Top three directors in the top 3 genres are: James Mangold with 4 movies, Joe Russo with 3 movies and Anthony Russo with 3 movies

/* James Mangold can be hired as the director for RSVP's next project.
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
SELECT
	name AS actor_name,
    COUNT(r.movie_id) AS movie_count
FROM
	role_mapping rp
INNER JOIN
	ratings r
		ON rp.movie_id = r.movie_id
INNER JOIN
	names n
		ON rp.name_id = n.id
WHERE
    median_rating >= 8
    AND
    category = "ACTOR"
GROUP BY
	actor_name
ORDER BY
	movie_count DESC LIMIT 2;

-- The top 2 actors with a medain rating of >= 8 are : 1.Mammootty with 8 movies,  2.Mohanlal with 5 movies.


/* 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
SELECT
	production_company,
	SUM(total_votes) AS vote_count,
    RANK() OVER (ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM
	movie m 
INNER JOIN
	ratings r
		ON m.id = r.movie_id
GROUP BY
	production_company
LIMIT 3;

-- Top three production houses on the basis of total votes are: 1. Marvel Studios
-- 																2. Twentieth Century Fox 
-- 																3. Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
SELECT
	name AS actor_name,
	SUM(total_votes) as total_votes,
	COUNT(rm.movie_id) AS movie_count,
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) as actor_avg_rating,
	DENSE_RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actor_rank
FROM
	role_mapping rm
INNER JOIN
	names n
	ON rm.name_id = n.id
INNER JOIN
	movie m
		ON rm.movie_id = m.id
INNER JOIN
	ratings r
	ON m.id = r.movie_id
WHERE
	UPPER(country) LIKE "%INDIA%"
	AND
	category LIKE "%ACTOR%"
GROUP BY
	actor_name
HAVING
	movie_count>=5 ;

-- The top three actors are: 1. Vijay Sethupathi
-- 							 2. Fahadh Faasil
-- 							 3. Yogi Babu				

-- Top actor is Vijay Sethupathi


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
SELECT
	name AS actress_name,
	SUM(total_votes) as total_votes,
	COUNT(rm.movie_id) AS movie_count,
	ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) as actress_avg_rating,
	DENSE_RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actress_rank
FROM
	role_mapping rm
INNER JOIN
	names n
	ON rm.name_id = n.id
INNER JOIN
	movie m
		ON rm.movie_id = m.id
INNER JOIN
	ratings r
	ON m.id = r.movie_id
WHERE
	UPPER(country) LIKE "%INDIA%"
	AND
	UPPER(languages) LIKE "%HINDI%"
	AND
	UPPER(category) LIKE "%ACTRESS%"
GROUP BY
	actress_name
HAVING
	movie_count>=3 LIMIT 5;

-- Top five actresses in Hindi movies released in India based on their average ratings are:  Taapsee Pannu, Kriti Sanon, Divya Dutta, Shraddha Kapoor, Kriti Kharbanda

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  
			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/
SELECT
	title as movie_name,
    CASE
		WHEN avg_rating > 8 THEN 'Superhit'
        WHEN avg_rating BETWEEN 7 AND 8 THEN 'Hit'
		WHEN avg_rating BETWEEN 5 AND 7 THEN "One-time-watch"
		WHEN avg_rating <5 THEN 'Flop'
	END AS movie_category
FROM
	movie m
INNER JOIN
	ratings r
		ON m.id = r.movie_id
INNER JOIN
	genre g
		ON m.id = g.movie_id
WHERE
	total_votes >= 25000
	AND
    LOWER(genre) LIKE "%thriller%"
ORDER BY
	avg_rating DESC ;

-- There are 4 superhit movies with atleast 25000 votes. That are : Joker, Andhadhun, Ah-ga-ssi and Contratiempo.


/* Until now, we have analysed various tables of the data set. 
Now, we will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
SELECT
	genre,
    ROUND(AVG(duration),2) AS avg_duration,
    SUM(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS  running_total_duration,
    AVG(ROUND(AVG(duration),2)) OVER (ORDER BY genre ROWS BETWEEN 10 PRECEDING AND CURRENT ROW) AS  moving_avg_duration
FROM
	movie m
INNER JOIN
	genre g
		ON m.id = g.movie_id
GROUP BY
	genre 
ORDER BY
	genre;
    
-- Output table is as: 

-- genre	|	avg_duration |	running_total_duration	|	moving_avg_duration
-- Action		112.88			112.88						112.880000
-- Adventure	101.87			214.75						107.375000
-- Comedy		102.62			317.37						105.790000
-- Crime		107.05			424.42						106.105000
-- Drama		106.77			531.19						106.238000
-- Family		100.97			632.16						105.360000
-- Fantasy		105.14			737.30						105.328571
-- Horror		92.72			830.02						103.752500
-- Mystery		101.80			931.82						103.535556
-- Others		100.16			1031.98						103.198000
-- Romance		109.53			1141.51						103.773636
-- Sci-Fi		97.94			1239.45						102.415455
-- Thriller		101.58			1341.03						102.389091


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Top 3 Genres based on most number of movies
WITH top_3_genre AS
(
	SELECT
		genre
	FROM
		genre
	GROUP BY
		genre
	ORDER BY
		count(movie_id) DESC LIMIT 3
),
top_movies AS
(
	SELECT
		g.genre,
		year,
		title as movie_name,
		CONCAT("$",CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR','$'),'$','') AS decimal(10))) AS worlwide_gross_income ,
		DENSE_RANK()
			OVER (PARTITION BY genre, year ORDER BY CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) DESC) as movie_rank
	FROM
		movie m
	INNER JOIN
		genre g
			ON m.id = g.movie_id
	INNER JOIN 
		top_3_genre tg
			ON g.genre = tg.genre
ORDER BY
		genre, year
)
SELECT * FROM top_movies
WHERE
	movie_rank<= 5;


-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/

WITH top_multilingual_prod_comp AS 
(
	SELECT
		production_company,
		COUNT(id) AS movie_count
	FROM
		movie m
	INNER JOIN
		ratings r
			ON m.id = r.movie_id
	WHERE
		median_rating >=8
		AND
		languages  LIKE "%,%"
		AND
		production_company IS NOT NULL
	GROUP BY
		production_company
)
SELECT *,
		DENSE_RANK() OVER(ORDER BY movie_count DESC) AS prod_comp_rank
FROM
	top_multilingual_prod_comp
LIMIT 2

-- Top two production companies are : Star Cinema with 7 movies and Twentieth Century Fox with 4 movies.

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

WITH top_actress AS
(
	SELECT
		n.name AS actress_name,
		SUM(total_votes) AS total_votes,
		Count(r.movie_id) AS movie_count,
		Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
	FROM
		movie m
	INNER JOIN
		ratings r
           ON m.id=r.movie_id
	INNER JOIN
		role_mapping AS rm
           ON m.id = rm.movie_id
	INNER JOIN names AS n
		ON rm.name_id = n.id
	INNER JOIN genre AS g
		ON g.movie_id = m.id
	WHERE      category = 'ACTRESS'
		AND        avg_rating>8
		AND genre = "Drama"
	GROUP BY
		name )
SELECT   *,
         Rank() OVER(ORDER BY actress_avg_rating DESC, total_votes DESC, actress_name ASC) AS actress_rank
FROM     top_actress LIMIT 3;
        
    
-- The top 3 actress in Drama genre with movie's avg_rating > 8 are: 1. Sangeetha Bhat, 2. Adriana Matoshi, 3. Fatmire Sahiti


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/

WITH top_directors AS
(
SELECT 
	n.id as director_id,
    n.name as director_name,
	COUNT(m.id) AS movie_count,
    RANK() OVER (ORDER BY COUNT(m.id) DESC) as director_rank
FROM
	names AS n
		INNER JOIN
	director_mapping AS d
		ON n.id=d.name_id
			INNER JOIN
        movie AS m
			ON d.movie_id = m.id
GROUP BY n.id
),
movie_summary AS
(
SELECT
	n.id as director_id,
    n.name as director_name,
    m.id AS movie_id,
    m.date_published,
	r.avg_rating,
    r.total_votes,
    m.duration,
    LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published) AS next_date_published,
    DATEDIFF(LEAD(date_published) OVER (PARTITION BY n.id ORDER BY m.date_published),date_published) AS inter_movie_days
FROM
	names AS n
INNER JOIN
	director_mapping AS d
		ON n.id=d.name_id
INNER JOIN
	movie AS m
		ON d.movie_id = m.id
INNER JOIN
	ratings AS r
		ON m.id=r.movie_id
WHERE
	n.id IN (SELECT director_id FROM top_directors WHERE director_rank<=9)
)
SELECT 
	director_id,
	director_name,
	COUNT(DISTINCT movie_id) as number_of_movies,
	ROUND(AVG(inter_movie_days),0) AS avg_inter_movie_days,
	ROUND(
	SUM(avg_rating*total_votes)/SUM(total_votes),2) AS avg_rating,
    SUM(total_votes) AS total_votes,
    MIN(avg_rating) AS min_rating,
    MAX(avg_rating) AS max_rating,
    SUM(duration) AS total_duration
FROM 
	movie_summary
GROUP BY
	director_id
ORDER BY
	number_of_movies DESC, avg_rating DESC;
    
-- The top 9 directors are : A.L. Vijay, Andrew Jones, Steven Soderbergh,
-- Sam Liu, Sion Sono, Jesse V. Johnson, Justin Price, Chris Stokes nad Özgür Bakar