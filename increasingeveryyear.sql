with cte as(
select *,
(case when amount < lead(amount,1,amount+1) over(partition by brand order by year) then 1 else 0 end) as flag
from brands)
select * from brands where brand not in ( select brand from cte where flag = 0)