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

select a.v*b.v*c.v r
from expenses a, expenses b, expenses c
where a.i>b.i and b.i>c.i
having a.v+b.v+c.v=2020;
