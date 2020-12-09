create or replace temp table encodings1 as
select index i, value::int v
from table(flatten(split(
'35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576','\n')));

select v
from (
    select aa.i, aa.v, bb.ai
    from encodings1 aa
    left join (
        select a.i ai, a.v, b.i, b.v, c.i, c.v
        from encodings1 a
        join encodings1 b
        on b.i between a.i-5 and a.i-1
        join encodings1 c
        on c.i between a.i-5 and a.i-1 and c.i>b.i
        where a.v=b.v+c.v
    ) bb
    on aa.i = bb.ai
    where aa.i>(5-1) -- preamble
)
where ai is null
order by i
limit 1;
