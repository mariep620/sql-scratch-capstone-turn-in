--- 1.1 Quiz Funnel, cont. ---

SELECT *
FROM survey
LIMIT 10;

--- 1.2 What is the number of responses to each question? ---

SELECT question, COUNT(DISTINCT user_id) as 'total responses'
FROM survey
GROUP BY 1;

--- 1.3 What are the completion rates of the questions? ---
Performed in Excel with data from previous query:
question			total responses	percent completed this question
1. What are you looking for?	500		100.00%
2. What's your fit?		475		95.00%
3. Which shapes do you like?	380		80.00%
4. Which colors do you like?	361		95.00%
5. When was your last eye exam?	270		74.79%

--- 2.1 Home Try-On Tables ---

SELECT *
FROM quiz
LIMIT 5;
SELECT *
FROM home_try_on
LIMIT 5;
SELECT *
FROM purchase
LIMIT 5;

--- 2.2 Home Try-On Funnel, cont. ---

SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
LIMIT 10;

--- 2.3 Home Try-On Conversion Rates ---

WITH funnels AS (SELECT DISTINCT q.user_id,
   h.user_id IS NOT NULL AS 'is_home_try_on',
   h.number_of_pairs,
   p.user_id IS NOT NULL AS 'is_purchase'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id)  
SELECT count (*) as 'Num_Quiz', 
sum(is_home_try_on) as 'Num_Home_Try_On',
sum(is_purchase) as 'Num_Purchase',
1.0 * SUM(is_home_try_on) / COUNT(user_id) as 'Quiz_to_Tryon',
1.0 * SUM(is_purchase) / SUM(is_home_try_on) as 'Tryon_to_Purchase'
from funnels;

--- 2.4 What users like vs. what they purchase ---

SELECT DISTINCT q.user_id, q.color AS 'Quiz Color', p.color 'Purchase Color'
FROM quiz q
LEFT JOIN home_try_on h
   ON q.user_id = h.user_id
LEFT JOIN purchase p
   ON p.user_id = q.user_id
   WHERE p.color IS NOT NULL and q.color like 'black'
   limit 20;
