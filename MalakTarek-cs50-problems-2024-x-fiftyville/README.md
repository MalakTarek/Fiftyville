# Fiftyville Mystery Solution

This repository contains my solution to the "A Mystery in Fiftyville" problem from CS50x 2023. The goal of the problem is to use SQL queries to solve the mystery of the stolen CS50 Duck by identifying the thief, the city they escaped to, and their accomplice.

## Project Description

The town of Fiftyville has provided a SQLite database (`fiftyville.db`) containing records from around the time of the theft. Using SQL queries, we analyze the data to uncover the details of the crime.

### Objectives
1. Identify the thief.
2. Determine the city to which the thief escaped.
3. Identify the thief’s accomplice who helped them escape.

## Files in This Repository

- `log.sql`: A log of all SQL queries executed to solve the mystery, with comments explaining the thought process and the purpose of each query.
- `answers.txt`: A file containing the final answers — the names of the thief, the escape city, and the accomplice.

## My Solution

I started by examining the `crime_scene_reports` table to find the report corresponding to the theft on Humphrey Street on July 28, 2021. From there, I followed leads by querying other tables to track the movements and connections of suspects.

Here are some key steps in my approach:
- Querying `crime_scene_reports` to find the initial crime report.
- Investigating `flights` to track the thief's escape route.
- Analyzing `people` and `phone_calls` to identify connections between suspects and uncover the accomplice.


## Conclusion

By methodically querying the database and analyzing the data, I identified the thief, their escape city, and their accomplice. The process involved careful examination of various tables and understanding the relationships between different pieces of data.

## Acknowledgements
 Special thanks to the CS50 team for creating this engaging and educational challenge.


