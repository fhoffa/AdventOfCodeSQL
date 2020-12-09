set v=127;
set i=(
    select i
    from encodings1
    where v=$v
);

select min(v)+max(v)
from encodings1 a
  , (select i from encodings1 where i between 0 and $i-1) b
  , (select i from encodings1 where i between 0 and $i-1) c
where a.i between b.i and c.i
and b.i<c.i
group by b.i, c.i
having sum(v)=$v;
