create or replace temp table boarding_passes as
select index i, value v
from table(flatten(split(
'BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL', '\n')));

-- todo: simplify to binary
select max(rown*8+seat)
from (
    select x[0]::int*64+x[1]::int*32+x[2]::int*16+x[3]::int*8+x[4]::int*4+x[5]::int*2+x[6]::int*1 rown
      , x[7]::int*4+x[8]::int*2+x[9]::int*1 seat
    from (
        select split(regexp_replace(regexp_replace(v, '[FL]', '0,'), '[BR]', '1,'), ',') x
        from boarding_passes2
    )
);

-- todo: simplify to binary
select rown*8+seat id, id-lag(id) over(order by id) skip, id-1 answer
from (
    select x[0]::int*64+x[1]::int*32+x[2]::int*16+x[3]::int*8+x[4]::int*4+x[5]::int*2+x[6]::int*1 rown
      , x[7]::int*4+x[8]::int*2+x[9]::int*1 seat
    from (
        select split(regexp_replace(regexp_replace(v, '[FL]', '0,'), '[BR]', '1,'), ',') x
    from boarding_passes2
    )
)
qualify skip=2
;
