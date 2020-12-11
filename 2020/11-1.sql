create or replace temp table seats1 as
select index i, value v
from table(flatten(split(
'L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL','\n')));


create or replace table seats1_plus
as
select 0::number gen, i, index-1 j, value v
from seats1, table(split_to_table(regexp_replace(v, '.', ',\\0', 2), ','));

set maxj = (select max(j) from seats1_plus);
set maxj1 = $maxj+1;
set maxj2 = $maxj+2;

insert into seats1_plus
select gen+1 gen, i, j
    , case v when 'L' then iff('#' not in (n1,n2,n3,n4,n5,n6,n7,n8), '#', 'L') 
        when '.' then '.'
        when '#' then iff(iff(n1='#',1,0)+iff(n2='#',1,0)+iff(n3='#',1,0)+iff(n4='#',1,0)
                          +iff(n5='#',1,0)+iff(n6='#',1,0)+iff(n7='#',1,0)+iff(n8='#',1,0) >= 4,
                          'L', '#')
    end ll
from (
    select *
      , ifnull(iff(j>0,lag(v, 1) over(order by i,j),null),'') n1
      , ifnull(iff(j<$maxj,lead(v, 1) over(order by i,j),null),'') n2
      , ifnull(iff(j<$maxj,lag(v, $maxj) over(order by i,j),null),'') n3
      , ifnull(lag(v, $maxj1) over(order by i,j),'') n4
      , ifnull(iff(j>0,lag(v, $maxj2) over(order by i,j),null),'') n5
      , ifnull(iff(j>0,lead(v, $maxj) over(order by i,j),null),'') n6
      , ifnull(lead(v, $maxj1) over(order by i,j),'') n7
      , ifnull(iff(j<$maxj,lead(v, $maxj2) over(order by i,j),null),'') n8
    from seats1_plus
    where gen=(select max(gen) from seats1_plus)
);


select length(regexp_replace(x , '[L\.]', '')), gen, x
from (
    select gen, listagg(v) x
    from seats1_plus
    group by gen
    order by gen desc
)
;
