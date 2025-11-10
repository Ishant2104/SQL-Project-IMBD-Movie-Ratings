# IMDB Movie Data Analysis for RSVP Movies

## Overview

This project is a comprehensive SQL-based analysis of an IMDB dataset. The primary objective is to analyze movie data to derive actionable insights for a fictional movie studio, **RSVP Movies**, helping them make data-driven decisions for their next film project.

The analysis focuses on identifying trends related to:
* Top-performing genres
* Successful directors and actors
* Movie performance metrics (ratings, duration, etc.)
* Specific insights into the Indian film industry

---

## Problem Statement

RSVP Movies wants to start a new project and needs to understand the current movie landscape. This analysis answers key business questions to provide a strategic recommendation on what kind of film they should produce.

Key questions explored:
1.  What are the most produced and highest-rated genres?
2.  Which production companies have the most successful track record?
3.  Who are the top-rated actors and directors that audiences love?
4.  What is the ideal movie duration?
5.  What are the specific trends within the Indian film market (e.g., top actors, actresses)?

---

## Tools & Technologies

* **Database:** MySQL
* **Language:** SQL
* **Data Source:** IMDB data (originally provided as an Excel file)

---

## Project Workflow

This project was executed in two main phases, with all scripts included in this repository.

### 1. Database Creation & Data Loading

The file `Database Creation.sql` handles the complete setup of the `imdb` database.

* **Schema Design:** A relational database schema was designed with 6 tables to hold the data:
    * `movie`
    * `genre`
    * `ratings`
    * `names` (for actors, directors, etc.)
    * `director_mapping`
    * `role_mapping`
* **Data Insertion:** The script contains all `INSERT` statements to populate the tables with the provided dataset.
<img width="1149" height="758" alt="image" src="https://github.com/user-attachments/assets/f7af0ab8-37b0-4f86-bf3f-bb42da1490f7" />



### 2. Data Analysis & Insight Generation

The file `IMDB-question.sql` contains all SQL queries used for the analysis. The queries are structured to build a comprehensive picture of the movie industry.

The analysis includes:
* **Segment 1 (Data Exploration):** Finding the number of rows in each table and identifying columns with NULL values.
* **Segment 2 (Movie Analysis):**
    * Ranking genres by movie count and average rating.
    * Analyzing movie counts by month of release.
    * Calculating average movie durations for different genres.
* **Segment 3 (Business Insights):**
    * Identifying top production companies.
    * Segmenting movies into "Hit" or "Superhit" categories based on ratings.
    * Ranking top directors and actors (both male and female) based on average movie ratings.
* **Segment 4 (Indian Market Focus):**
    * Drilling down into the Indian market to find the top actors, actresses, and genres.

---

## Key Insights & Recommendations

The SQL analysis (found in `IMDB-question.sql`) provides several key recommendations for RSVP Movies:

* **Top Genres:** Drama, Action and Thriller
* **Talent:**
*  Top Directors - James Mangold, Joe Russo, Anthony Russo
* Top actors - Vijay Sethupathi and Fahadh Faasil
* Top actresses in Hindi - Taapsee Pannu, Kriti Sanon, and Shraddha Kapoor
* Production Company - Star Cinema and Twentieth Century Fox led among multilingual, highrated films


---

## How to Use This Repository

To replicate this analysis:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/Ishant2104/SQL-Project-IMBD-Movie-Ratings.git
    ```
2.  **Set up the Database:**
    * Open your SQL database management tool (e.g., MySQL Workbench, DBeaver).
    * Run the entire `Database Creation.sql` script. This will create the `imdb` database and populate it with data.
3.  **Run the Analysis:**
    * Open a new query tab.
    * Run the queries in `IMDB-question.sql` one by one (or all at once) against the `imdb` database to see the results.
