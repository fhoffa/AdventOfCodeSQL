select index i, value v
from table(flatten(split(
'F10
N3
F7
R90
F11','\n')));

-- select abs(posy)+abs(posx)
-- from (
select sum(y+y2) over(order by i) posy, sum(x+x2) over (order by i) posx, * 
from (
    select *, sin(radians(ang))::int*(move) y2, cos(radians(ang))::int*(move) x2
    from (
        select *
            , sum(-a) over(order by i) ang
        from (
            select i, v
                , case d when 'N' then n when 'S' then -n else 0 end y
                , case d when 'E' then n when 'W' then -n else 0 end x 
                , case d when 'R' then n when 'L' then -n else 0 end a
                , case d when 'F' then n else 0 end move
            from (
                select i, v, substr(v, 1,1) d, substr(v,2)::number n
                from advent12_1_1
            )
        )
    )
)
-- )
