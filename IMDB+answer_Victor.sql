USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/
show tables;
-- director_mapping, genre, movie, names, ratings, role_mapping
desc director_mapping;
desc genre;
desc movie;
-- id (PRI), title, year, date_published, duration, country, worlwide_gross_income, languages, production_company
desc names;
desc ratings;
desc role_mapping;


-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT count(1) "no. of rows" from director_mapping;
-- 3867
SELECT count(1) "no. of rows" from genre;
-- 14662
SELECT count(1) "no. of rows" from movie;
-- 7997
SELECT count(1) "no. of rows" from names;
-- 25735
SELECT count(1) "no. of rows" from ratings;
-- 7997
SELECT count(1) "no. of rows" from role_mapping;
-- 15615


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT * from movie WHERE 
title is null OR year is null OR 
date_published is null OR duration is null OR
country is null OR worlwide_gross_income is null OR
languages is null OR production_company is null;
-- We can see the country, worlwide_gross_income, languages and production_company have null data

-- Recall movie have 7997 rows
SELECT COUNT(1) from movie WHERE country is null;
-- country have 20 nulls
SELECT COUNT(1) from movie WHERE worlwide_gross_income is null;
-- worlwide_gross_income have 3724 nulls
SELECT COUNT(1) from movie WHERE languages is null;
-- languages have 194 nulls
SELECT COUNT(1) from movie WHERE production_company is null;
-- production_company have 528 nulls



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
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
-- Type your code below:

-- By year
SELECT year, count(1) "number of movies" from movie group by year;
/*
year	number of movies
2017	3052
2018	2944
2019	2001
*/

-- Month wise
SELECT extract(month from date_published) "month_num", 
count(1) "number of movies" from movie group by month_num
ORDER BY month_num asc;
/*
month_num	number of movies
1			804
2			640
3			824       (The highest)
4			680
5			625
6			580
7			493
8			678
9			809
10			801
11			625
12			438		(The Lowest)
*/

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for 2019.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT count(1) 'The number of movies in 2019 from USA or India' 
from movie where year = 2019 AND country LIKE "%USA%" OR country LIKE"%India%";
-- The number of movies in 2019 from USA or India = 1818

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre from genre;
/*
Drama
Fantasy
Thriller
Comedy
Horror
Family
Romance
Adventure
Action
Sci-Fi
Crime
Mystery
Others
*/

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

select g.genre, count(1) 'no. of movies' from genre as g
INNER JOIN movie as m
ON g.movie_id = m.id
group by g.genre
order by count(1) DESC;

/*
Drama	4285	(The highest)
Comedy	2412
Thriller	1484
Action	1289
Horror	1208
Romance	906
Crime	813
Adventure	591
Mystery	555
Sci-Fi	375
Fantasy	342
Family	302
Others	100
*/

-- To show the top one
select g.genre, count(1) 'no. of movies' from genre as g
INNER JOIN movie as m
ON g.movie_id = m.id
group by g.genre
order by count(1) DESC
LIMIT 1;


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:
select count(movie_id) "no. of movies have only ine genre" from(
select movie_id, count(genre) 'count' 
from genre group by movie_id having count=1) As sub;
-- no. of movies have only ine genre = 3289

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
-- Type your code below:
select g.genre, cast(AVG(m.duration) as decimal(10, 2)) 'avg_duration' FROM genre as g
INNER JOIN movie as m
ON g.movie_id = m.id
group by g.genre
ORDER BY avg_duration DESC;

/*
genre	avg_duration
Action	112.88
Romance	109.53
Crime	107.05
Drama	106.77
Fantasy	105.14
Comedy	102.62
Adventure	101.87
Mystery	101.80
Thriller	101.58
Family	100.97
Others	100.16
Sci-Fi	97.94
Horror	92.72
*/

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

select * from (
select g.genre, count(1) 'movie_count',
dense_rank() over (order by count(1) DESC) "genre_rank" from genre as g
INNER JOIN movie as m
ON g.movie_id = m.id
group by g.genre) As sub
WHERE genre = 'Thriller';

/*
genre		movie_count	genre_rank
Thriller	1484		3
*/

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

select MIN(avg_rating) 'min_avg_rating', MAX(avg_rating) 'max_avg_rating',
MIN(total_votes) 'min_total_votes', MAX(total_votes) 'max_total_votes',
MIN(median_rating) 'min_median_rating', MAX(median_rating) 'max_median_rating' from ratings;

/*
min_avg_rating	max_avg_rating	min_total_votes	max_total_votes	min_median_rating	min_median_rating
1.0				10.0				100				725138				1					10
*/

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
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too
-- DENSE_RANK
select m.title, sub.avg_rating, sub.movie_rank from movie as m
JOIN (
select movie_id, avg_rating, 
dense_rank() over(order by avg_rating desc) "movie_rank" from ratings) as sub
ON m.id = sub.movie_id
where movie_rank <= 10;

/*
title	avg_rating	movie_rank
Kirket	10.0	1
Love in Kilnerry	10.0	1
Gini Helida Kathe	9.8	2
Runam	9.7	3
Fan	9.6	4
Android Kunjappan Version 5.25	9.6	4
Safe	9.5	5
The Brighton Miracle	9.5	5
Yeh Suhaagraat Impossible	9.5	5
Shibu	9.4	6
Our Little Haven	9.4	6
Zana	9.4	6
Family of Thakurganj	9.4	6
Ananthu V/S Nusrath	9.4	6
Wheels	9.3	7
Eghantham	9.3	7
Turnover	9.2	8
Digbhayam	9.2	8
Tõde ja õigus	9.2	8
Ekvtime: Man of God	9.2	8
Leera the Soulmate	9.2	8
AA BB KK	9.2	8
Peranbu	9.2	8
Dokyala Shot	9.2	8
Ardaas Karaan	9.2	8
Oththa Seruppu Size 7	9.1	9
Adutha Chodyam	9.1	9
The Colour of Darkness	9.1	9
Aloko Udapadi	9.1	9
C/o Kancharapalem	9.1	9
Nagarkirtan	9.1	9
Jelita Sejuba: Mencintai Kesatria Negara	9.1	9
Kuasha jakhon	9.1	9
Shindisi	9.0	10
Officer Arjun Singh IPS	9.0	10
Oskars Amerika	9.0	10
Delaware Shore	9.0	10
Abstruse	9.0	10
National Theatre Live: Angels in America Part Two - Perestroika	9.0	10
Innocent	9.0	10
*/

-- RANK
select m.title, sub.avg_rating, sub.movie_rank from movie as m
JOIN (
select movie_id, avg_rating, 
rank() over(order by avg_rating desc) "movie_rank" from ratings) as sub
ON m.id = sub.movie_id
where movie_rank <= 10;

/*
title	avg_rating	movie_rank
Kirket	10.0	1
Love in Kilnerry	10.0	1
Gini Helida Kathe	9.8	3
Runam	9.7	4
Fan	9.6	5
Android Kunjappan Version 5.25	9.6	5
Safe	9.5	7
The Brighton Miracle	9.5	7
Yeh Suhaagraat Impossible	9.5	7
Shibu	9.4	10
Our Little Haven	9.4	10
Zana	9.4	10
Family of Thakurganj	9.4	10
Ananthu V/S Nusrath	9.4	10
*/

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
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
-- Type your code below:
-- Order by is good to have
select median_rating, count(1) 'movie_count'
from ratings
group by median_rating
ORDER BY median_rating;

/*
median_rating	movie_count
1				94
2				119
3				283
4				479
5				985
6				1975
7				2257
8				1030
9				429
10				346
*/


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

select m.production_company, count(1) "movie_count", 
dense_rank() over(ORDER BY COUNT(1) DESC) "prod_company_rank" FROM movie as m
JOIN( 
select movie_id from ratings where avg_rating > 8) As sub
ON m.id = sub.movie_id
WHERE m.production_company is not null
GROUP BY m.production_company;

/*
production_company	movie_count	prod_company_rank
Dream Warrior Pictures	3			1
National Theatre Live	3			1
*/

-- It's ok if RANK() or DENSE_RANK() is used too
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
-- Type your code below:


select g.genre, count(1) 'movie_count' from genre as g
INNER JOIN (
select m.id from movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
WHERE year = 2017 AND 
extract(MONTH FROM date_published)=3 AND country LIKE "%USA%" AND
r.total_votes > 1000) AS sub
ON g.movie_id = sub.id
GROUP BY g.genre;


/*
genre	movie_count
Action	8
Comedy	9
Crime	6
Drama	24
Sci-Fi	7
Fantasy	3
Mystery	4
Romance	4
Thriller	8
Adventure	3
Horror	6
Family	1
*/

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
-- Type your code below:

select sub.title, sub.avg_rating, g.genre from genre as g
INNER JOIN (
select m.id, m.title, r.avg_rating from ratings as r
INNER JOIN movie as m
ON r.movie_id = m.id
WHERE r.avg_rating > 8 AND m.title LIKE "The%") AS sub
ON g.movie_id = sub.id;

/*
title					avg_rating	genre
The Blue Elephant 2		8.8	Drama
The Blue Elephant 2		8.8	Horror
The Blue Elephant 2		8.8	Mystery
The Brighton Miracle	9.5	Drama
The Irishman			8.7	Crime
The Irishman			8.7	Drama
The Colour of Darkness	9.1	Drama
Theeran Adhigaaram Ondru	8.3	Action
Theeran Adhigaaram Ondru	8.3	Crime
Theeran Adhigaaram Ondru	8.3	Thriller
The Mystery of Godliness: The Sequel	8.5	Drama
The Gambinos	8.4	Crime
The Gambinos	8.4	Drama
The King and I	8.2	Drama
The King and I	8.2	Romance
*/

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select Count(1) 'movie_counts' from movie as m 
INNER JOIN ratings as r
ON m.id = r.movie_id
where m.date_published between "2018-04-01" and "2019-04-01" AND
median_rating = 8;

/*
movie_counts
361
*/

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

select SUM(r.total_votes) 'Total Votes of Italy' from movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
where m.country LIKE "%Italy%";
/*
Total Votes of Italy
703024
*/

select SUM(r.total_votes) 'Total Votes of Germany' from movie as m
INNER JOIN ratings as r
ON m.id = r.movie_id
where m.country LIKE "%German%";
/*
Total Votes of Germany
2026223
*/
-- So, Germany > Italy
-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select count(1) - count(id) "name_nulls", 
count(1) - count(height) "height_nulls", 
count(1) - count(date_of_birth) "date_of_birth_nulls", 
count(1) - count(known_for_movies) "known_for_movies_nulls" from names;
/*+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|		17335		|	      13431		  |	   15226	    	 |
+---------------+-------------------+---------------------+----------------------+*/

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select * from director_mapping;

select g.genre from genre AS g
INNER JOIN ratings AS r
ON g.movie_id = r.movie_id
WHERE r.avg_rating > 8
GROUP BY g.genre
ORDER BY count(1) DESC
LIMIT 3
;
-- The top three genre is Drama, Action, Comedy
select * from director_mapping;
select n.name 'director_name', count(1) 'movie_count' from director_mapping as dm
INNER JOIN
(select g.movie_id from genre as g
inner join ratings as r
where g., genre in ('Drama', 'Action', 'Comedy') AND
r.avg_rating > 8) As sub
ON dm.movie_id = sub.movie_id
INNER JOIN  and names as n
ON dm.name_id = n.id
GROUP BY n.name
ORDER BY movie_count DESC;

/*
director_name		movie_count
Steven Soderbergh	1494
Pandiraj	1245
Jesse V. Johnson	1245
Yûichi Fukuda	1245
Tigmanshu Dhulia	1245
Siddique	1245
Ksshitij Chaudhary	1245
Maruthi Dasari	1245
Sundar C.	1245
Jean-Claude La Marre	996
Kalyaan	996
Cédric Klapisch	996
Sharif Arafah	996
James Mangold	996   <------
Jena Serbu	996
Onur Ünlü	996
Noah Baumbach	996
S. Craig Zahler	996
Hayato Kawai	996
Olivier Nakache	996
Éric Toledano	996
Miguel Arteta	996
Hanung Bramantyo	996
Sathyan Anthikad	996
Hatef Alimardani	996
Sam Liu	996
A.L. Vijay	996
Ody C. Harahap	996
Yong-hwa Kim	996
Simerjit Singh	996
Michael J. Gallagher	996
Azfar Jafri	996
*/

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select * from ratings;
select n.name 'actor_name', count(1) 'movie_count' from role_mapping as rm
JOIN ratings as r
ON rm.movie_id = r.movie_id
JOIN names as n
ON rm.name_id = n.id
where r.median_rating >= 8 AND
rm.category = "actor"
GROUP BY n.name
ORDER BY count(1) DESC;

/*
actor_name	movie_count
Mammootty	8
Mohanlal	5
*/

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
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
-- Type your code below:

select production_company, sum(total_votes) 'vote_count',
dense_rank() over (ORDER BY sum(total_votes) DESC) "prod_comp_rank"
from movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
GROUP BY production_company
;

/*
production_company		vote_count	prod_comp_rank
Marvel Studios			2656967		1
Twentieth Century Fox	2411163		2
Warner Bros.			2396057		3
*/

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select sub.name "actor_name", sum(r.total_votes) "total_votes", count(1) "movie_count", 
sum(r.avg_rating*r.total_votes)/sum(r.total_votes) "actor_avg_rating",
dense_rank() over(order by sum(r.avg_rating*r.total_votes)/sum(CASE when r.avg_rating is not null then r.total_votes else 0 end) DESC) "actor_rank" from role_mapping AS rm
INNER JOIN (
select rm.name_id, n.name from role_mapping AS rm
INNER JOIN names AS n
ON rm.name_id = n.id
INNER JOIN movie AS m
ON rm.movie_id = m.id
where m.country LIKE "%India%" AND
rm.category = 'actor'
GROUP BY n.name
HAVING count(1) >= 5) AS sub
ON rm.name_id = sub.name_id
INNER JOIN ratings as r
ON rm.movie_id = r.movie_id
group by sub.name;
select * from ratings;

/*
actor_name			total_votes	movie_count	actor_avg_rating	actor_rank
Vijay Sethupathi	23114		5			8.41673				1
Fahadh Faasil		13557		5			7.98604				2
Yogi Babu			8500		11			7.83018				3
Joju George			3926		5			7.57967				4
Ammy Virk			2504		6			7.55383				5
Dileesh Pothan		6235		5			7.52133				6
Kunchacko Boban		5628		6			7.48351				7
Pankaj Tripathi		40728		5			7.43706				8
Rajkummar Rao		42560		6			7.36701				9
Dulquer Salmaan		17666		5			7.30087				10
Amit Sadh			13355		5			7.21306				11
Tovino Thomas		11596		8			7.14540				12
Mammootty			12613		8			7.04208				13
Nassar				4016		5			7.03312				14
Karamjit Anmol		1970		6			6.90863				15
Hareesh Kanaran		3196		5			6.57747				16
Naseeruddin Shah	12604		5			6.53622				17
Anandraj			2750		6			6.53571				18
Mohanlal			17622		7			6.46746				19
Aju Varghese		2237		5			6.43375				20
Siddique			5953		7			6.42565				21
Prakash Raj			8548		6			6.37126				22
Jimmy Sheirgill		3826		6			6.28772				23
Mahesh Achanta		2716		6			6.21141				24
Biju Menon			1916		5			6.21091				25
Suraj Venjaramoodu	4284		6			6.18625				26
Abir Chatterjee		1413		5			5.80078				27
Sunny Deol			4594		5			5.70509				28
Radha Ravi			1483		5			5.70223				29
Prabhu Deva			2044		5			5.68014				30
Atul Sharma			9604		5			4.78024				31
*/

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
select * from movie;

select sub.name "actress_name", sum(r.total_votes) "total_votes", count(1) "movie_count", 
sum(r.avg_rating*r.total_votes)/sum(r.total_votes) "actress_avg_rating",
dense_rank() over(order by sum(r.avg_rating*r.total_votes)/sum(CASE when r.avg_rating is not null then r.total_votes else 0 end) DESC) "actress_rank" from role_mapping AS rm
INNER JOIN (
select rm.name_id, n.name from role_mapping AS rm
INNER JOIN names AS n
ON rm.name_id = n.id
INNER JOIN movie AS m
ON rm.movie_id = m.id
where m.country LIKE "%India%" AND
rm.category = 'actress' AND
m.languages = 'Hindi'
GROUP BY n.name
HAVING count(1) >= 3) AS sub
ON rm.name_id = sub.name_id
INNER JOIN ratings as r
ON rm.movie_id = r.movie_id
group by sub.name;
select * from ratings;

/*
actress_name	total_votes	movie_count	actress_avg_rating	actress_rank
Taapsee Pannu	18895		5			7.70008				1
Divya Dutta		8579		3			6.88440				2
Kriti Kharbanda	2681		4			4.67497				3
Sonakshi Sinha	4025		4			4.18124				4
*/

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:


select m.title, g.genre, 
r.avg_rating, 
CASE 
	WHEN r.avg_rating > 8 THEN 'Superhit'
    WHEN r.avg_rating between 7 and 8 THEN "Hit"
    WHEN r.avg_rating between 5 and 7 THEN "One-time-watch"
    ELSE "Flop"
END AS "category"
from genre as g
JOIN movie AS m
ON g.movie_id = m.id
JOIN ratings AS r
ON g.movie_id = r.movie_id
where genre = 'Thriller';


/*
title						genre		avg_rating	category
xXx: Return of Xander Cage	Thriller	5.2			One-time-watch
Infection: The Invasion Begins	Thriller	2.3		Flop
Truth	Thriller	7.3	Hit
Kidnap	Thriller	5.9	One-time-watch
Mute	Thriller	5.4	One-time-watch
Halloween	Thriller	6.6	One-time-watch
	.			.		.		.
	.			.		.		.
	.			.		.		.
*/


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

select * from genre;
select g.genre, CAST(avg(m.duration) AS decimal(10,2)) "avg_duration",
CAST(SUM(avg(m.duration)) OVER (ORDER BY g.genre) AS decimal(10,2)) "running_total_duration",
CAST(SUM(avg(m.duration)) OVER (ORDER BY g.genre) / COUNT(1) OVER (ORDER BY g.genre) AS decimal(10,2)) "moving_avg_duration" 
from movie AS m
INNER JOIN genre AS g
ON m.id = g.movie_id
GROUP BY genre;

/*
genre	avg_duration	running_total_duration	moving_avg_duration
Action	112.88	112.88	112.88
Adventure	101.87	214.75	107.38
Comedy	102.62	317.38	105.79
Crime	107.05	424.43	106.11
Drama	106.77	531.20	106.24
Family	100.97	632.17	105.36
Fantasy	105.14	737.31	105.33
Horror	92.72	830.03	103.75
Mystery	101.80	931.83	103.54
Others	100.16	1031.99	103.20
Romance	109.53	1141.53	103.78
Sci-Fi	97.94	1239.47	103.29
Thriller	101.58	1341.05	103.16
*/

-- Round is good to have and not a must have; Same thing applies to sorting


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
-- Type your code below:

-- Top 3 Genres based on most number of movies
select genre, count(1) "movies_counts" from genre 
group by genre ORDER BY count(1) DESC LIMIT 3;
-- Drama, Comedy, Thriller
select * from (
select genre, year, movie_name, worldwide_gross_income,
dense_rank() over(PARTITION BY genre, year ORDER BY income_in_usd DESC) "movie_rank" from 
(select g.genre, m.year, m.title "movie_name", 
m.worlwide_gross_income "worldwide_gross_income",
CASE
	WHEN SUBSTRING(m.worlwide_gross_income,1, 1) = "$" THEN CAST(SUBSTRING(m.worlwide_gross_income,3) AS decimal(15,0))
    WHEN SUBSTRING(m.worlwide_gross_income,1, 1) = "I" THEN CAST(SUBSTRING(m.worlwide_gross_income,5)*0.014 AS decimal(15,0))
END AS income_in_usd
from genre AS g
INNER JOIN movie AS m
ON g.movie_id = m.id
WHERE genre in ("Drama", "Comedy", "Thriller")) AS sub) As susub
WHERE movie_rank <= 5;


/*
genre	year	movie_name	worldwide_gross_income	movie_rank
Comedy	2017	Despicable Me 3	$ 1034799409	1
Comedy	2017	Jumanji: Welcome to the Jungle	$ 962102237	2
Comedy	2017	Guardians of the Galaxy Vol. 2	$ 863756051	3
*/

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
-- Type your code below:

select production_company, count(1) "movie_count", 
dense_rank() over (ORDER BY count(1) DESC) "prod_comp_rank" from movie AS m
INNER JOIN ratings AS r
ON m.id = r.movie_id
where m.languages LIKE "%, %" AND
r.median_rating >= 8 AND
production_company is not null
GROUP BY production_company;

/*
production_company	movie_count	prod_comp_rank
Star Cinema	7	1
Twentieth Century Fox	4	2
*/

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

select name "actress_name", sum(total_votes) "total_votes",
count(1) "movie_count", 
sum(r.avg_rating*r.total_votes)/sum(r.total_votes) "actress_avg_rating",
dense_rank() over(order by sum(r.avg_rating*r.total_votes)/sum(CASE when r.avg_rating is not null then r.total_votes else 0 end) DESC) "actress_rank"
from role_mapping AS rm
INNER JOIN ratings AS r
ON rm.movie_id = r.movie_id
INNER JOIN names AS n
ON rm.name_id = n.id
INNER JOIN genre AS g
ON rm.movie_id = g.movie_id
WHERE r.avg_rating > 8 AND
g.genre = 'Drama' AND
rm.category = 'actress'
group by name;

/*
actress_name	total_votes	movie_count	actress_avg_rating	actress_rank
Sangeetha Bhat	1010	1	9.60000	1
Fatmire Sahiti	3932	1	9.40000	2
Adriana Matoshi	3932	1	9.40000	2
Mahie Gill	897	1	9.40000	2
Pranati Rai Prakash	897	1	9.40000	2
Anupama Kumar	645	1	9.30000	3
Neeraja	645	1	9.30000	3
*/



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
-- Type you code below:

select sub.name_id "director_id", 
n.name "director_name", count(1) "number_of_movies", 
avg(sub.inter_movie_days) "avg_inter_movie_days",
avg(r.avg_rating) "avg_rating", sum(r.total_votes) "total_votes", 
min(r.avg_rating) "min_rating", max(r.avg_rating) "max_rating", sum(sub.duration) "total_duration"
from (
select movie_id, name_id, title, date_published, duration,
date_published - Lead (date_published, 1) OVER ( Partition by name_id Order by date_published DESC) "inter_movie_days"
FROM director_mapping AS dm
JOIN movie as m
ON dm.movie_id = m.id) AS sub
INNER JOIN names AS n
ON sub.name_id = n.id
INNER JOIN ratings AS r
ON sub.movie_id = r.movie_id
GROUP BY name_id
ORDER BY count(1) DESC;

/*
director_id	director_name	number_of_movies	avg_inter_movie_days	avg_rating	total_votes	min_rating	max_rating	total_duration
nm1777967	A.L. Vijay	5	4977.0000	5.42000	1754	3.7	6.9	613
nm2096009	Andrew Jones	5	5025.5000	3.02000	1989	2.7	3.2	432
nm0001752	Steven Soderbergh	4	6700.6667	6.47500	171684	6.2	7.0	401
nm0425364	Jesse V. Johnson	4	6838.6667	5.45000	14778	4.2	6.5	383
	.			.				.		.			.		.	.	.	.
	.			.				.		.			.		.	.	.	.
	.			.				.		.			.		.	.	.	.
*/
