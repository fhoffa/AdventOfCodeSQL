create or replace temp table forest as
select index i, value v
from table(flatten(split(
'..##.......
#...#...#..
.#....#..#.
..#.#...#.#
.#...##..#.
..#.##.....
.#.#.#....#
.#........#
#.##...#...
#...##....#
.#..#...#.#'
, '\n')));

create or replace temp table jumps as
select 1 r, 1 d, 1 id
union all select 3,1,2
union all select 5,1,3
union all select 7,1,4
union all select 1,2,5;
     
select exp(sum(ln(r))) from (   
select id, count_if('#'=substr(v, 1+(r*i/d)%len(v), 1)) r
from forest
join jumps
where i>0
and i%d=0
group by id
);
