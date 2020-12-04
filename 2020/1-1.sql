create or replace temp table expenses as 
select index i, value::int v
from table(flatten(SPLIT(
'1721
979
366
299
675
1456'
, '\n')));

select a.v*b.v r
from expenses a, expenses b
where a.i>b.i
having a.v+b.v=2020;
