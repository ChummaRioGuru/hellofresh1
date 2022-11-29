select * from student_list;
select * from student_response;
select * from correct_answer;
select * from question_paper_code;

with cte as (
select sl.roll_number, sl.student_name, sl.class, sl.section, sl.school_name,
sum(case when pc.subject = 'Math' and sr.option_marked = ca.correct_option and sr.option_marked <> 'e' then 1 else 0 end) as Math_correct,
sum(case when pc.subject = 'Math' and sr.option_marked != ca.correct_option and sr.option_marked <> 'e' then 1 else 0 end) as Math_wrong,
sum(case when pc.subject = 'Math' and sr.option_marked <> 'e' then 1 else 0 end) as Math_yet_to_learn,
sum(case when pc.subject = 'Science' and sr.option_marked = ca.correct_option and sr.option_marked <> 'e' then 1 else 0 end) Science_correct,
sum(case when pc.subject = 'Science' and sr.option_marked != ca.correct_option and sr.option_marked <> 'e' then 1 else 0 end) Science_wrong,
sum(case when pc.subject = 'Science' and sr.option_marked <> 'e' then 1 else 0 end) Science_yet_to_learn,
sum(case when pc.subject = 'Math' then 1 else 0 end) as total_math_score,
sum(case when pc.subject = 'Science' then 1 else 0 end) as total_Science_score
from student_list sl
Join student_response sr on sl.roll_number = sr.roll_number
join correct_answer ca on sr.question_number = ca.question_number and sr.question_paper_code = ca.question_paper_code
join question_paper_code pc on ca.question_paper_code = pc.paper_code
group by sl.roll_number, sl.student_name, sl.class, sl.section, sl.school_name)
select roll_number, student_name, class, section,school_name,Math_correct,Math_wrong,Math_yet_to_learn,Math_correct as Math_score,
round((Math_correct::decimal/total_math_score::decimal)*100,2) as Math_percentage,
Science_correct,Science_wrong,Science_yet_to_learn,Science_correct as Science_Score,round((Science_correct::decimal/total_Science_score::decimal)*100,2) as Science_percentage
from cte;
