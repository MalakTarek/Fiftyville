-- Keep a log of any SQL queries you execute as you solve the mystery.
--info
--Month 7
--Day 28
-- Humphrey Street
-- time 10:15 am
-- 3 interviews
-- check security footage within 10 minutes
--thief withdrew money (check atm)
--ACCOMPLICE  was called (less than a minute on 28/7) and booked flight ticket for 29/7
--Crime Description
 SELECT description
 FROM crime_scene_reports
 WHERE month =7 AND day=28 AND street='Humphrey Street';
--Theft of the CS50 duck took place at 10:15am at the Humphrey Street bakery.
--Interviews were conducted today with three witnesses who were present at the time – each of their interview transcripts mentions the bakery.
--Witnesses Interviews
SELECT *
FROM interviews
Where transcript like "%bakery%";
--
--| 161 | Ruth    | 2023 | 7     | 28  | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
--| 162 | Eugene  | 2023 | 7     | 28  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
--| 163 | Raymond | 2023 | 7     | 28  | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
--Atm transaction

Select *
From atm_transactions
Where month=7 AND day =28 And atm_location = "Leggett Street" And transaction_type ="withdraw";
--+-----+----------------+------+-------+-----+----------------+------------------+--------+
--| id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
--+-----+----------------+------+-------+-----+----------------+------------------+--------+
--| 246 | 28500762       | 2023 | 7     | 28  | Leggett Street | withdraw         | 48     |
--| 264 | 28296815       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
--| 266 | 76054385       | 2023 | 7     | 28  | Leggett Street | withdraw         | 60     |
--| 267 | 49610011       | 2023 | 7     | 28  | Leggett Street | withdraw         | 50     |
--| 269 | 16153065       | 2023 | 7     | 28  | Leggett Street | withdraw         | 80     |
--| 288 | 25506511       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
--| 313 | 81061156       | 2023 | 7     | 28  | Leggett Street | withdraw         | 30     |
--| 336 | 26013199       | 2023 | 7     | 28  | Leggett Street | withdraw         | 35     |
--+-----+----------------+------+-------+-----+----------------+------------------+--------+
Select *
from bakery_security_logs
Where month =7 and day =28 and hour =10 and minute BETWEEN 5 AND 25 and activity ='exit';
--+-----+------+-------+-----+------+--------+----------+---------------+
--| id  | year | month | day | hour | minute | activity | license_plate |
--+-----+------+-------+-----+------+--------+----------+---------------+
--| 260 | 2023 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
--| 261 | 2023 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
--| 262 | 2023 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
--| 263 | 2023 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
--| 264 | 2023 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
--| 265 | 2023 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
--| 266 | 2023 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
--| 267 | 2023 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
--+-----+------+-------+-----+------+--------+----------+---------------+
-- store liscense plate info
CREATE TABLE  suspects_license_plates AS
SELECT license_plate
FROM bakery_security_logs
WHERE month = 7
  AND day = 28
  AND hour = 10
  AND minute BETWEEN 5 AND 25
  AND activity = 'exit';
--store account numbers
CREATE TABLE  suspects_account_numbers AS
Select account_number
From atm_transactions
Where month=7 AND day =28 And atm_location = "Leggett Street" And transaction_type ="withdraw";
--get suspects ids from liscence plates
SELECT bank_accounts.person_id
FROM bank_accounts
JOIN suspects_account_numbers ON bank_accounts.account_number = suspects_account_numbers.account_number;
--store the results
CREATE TABLE  suspects_ids AS
SELECT bank_accounts.person_id
FROM bank_accounts
JOIN suspects_account_numbers ON bank_accounts.account_number = suspects_account_numbers.account_number;

--Narrowing the suspects
Select p.*
FROM people as p , suspects_ids as s_id , suspects_license_plates as s_lp
Where p.id = s_id.person_id And p.license_plate = s_lp.license_plate;
--4 current suspects
--+--------+-------+----------------+-----------------+---------------+
--|   id   | name  |  phone_number  | passport_number | license_plate |
--+--------+-------+----------------+-----------------+---------------+
--| 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       |
--| 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       |
--| 396669 | Iman  | (829) 555-5269 | 7049073643      | L93JTIZ       |
--| 467400 | Luca  | (389) 555-5198 | 8496433585      | 4328GD8       |
--+--------+-------+----------------+-----------------+---------------+
--
CREATE TABLE  current_suspects AS
Select p.*
FROM people as p , suspects_ids as s_id , suspects_license_plates as s_lp
Where p.id = s_id.person_id And p.license_plate = s_lp.license_plate;

--
Select pc.*
From phone_calls as pc , current_suspects as cs
Where caller = cs.phone_number and  year= 2023 and month =7 and day =28 and duration<60;
--suspect is either bruce (233)or diana!(255)
Create Table suspectscalls as
Select pc.*
From phone_calls as pc , current_suspects as cs
Where caller = cs.phone_number and  year= 2023 and month =7 and day =28 and duration<60;
--get id of origin airport
select id
from airports
where city = "Fiftyville";
-- id =8
--find out what flights were avaliable on that day
select *
from flights
where year =2023 and month =7 and day =29 and  origin_airport_id =8;
-- possible destinations id = 6,11,4,1,9
Create Table Possibleflights AS
select *
from flights
where year =2023 and month =7 and day =29 and  origin_airport_id =8;

create table final2suspects as
select p.*
from people as p , suspectscalls as sc
where sc.caller =p.phone_number;

Select p.* ,pf.*,fs.name
from passengers as p , final2suspects as fs , Possibleflights as pf
where p.passport_number = fs.passport_number and p.flight_id = pf.id;
--Its bruce since 36 is the earlier flight 18
--finding where he escaped to
select *
from airports
where id =4;
--he escaped to New York City!!
--finding ACCOMPLICE

SELECT name
FROM people
WHERE phone_number = (SELECT receiver
FROM suspectscalls
where id =233);
 --It's Robin!!!
