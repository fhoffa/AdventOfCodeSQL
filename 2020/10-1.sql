create or replace temp table adapters1 as
select index i, value::int v
from table(flatten(split(
'28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3','\n')));

select max(iff(vv=1,c,0)) * max(iff(vv=3,c,0)) r
from (
    select vv, count(*) c
    from (
        select v, v-lag(v) over(order by v) vv
        from (
            select v 
            from adapters1
            union all select 0
            union all select max(v)+3 from adapters1
        )
    )
    group by 1
);
