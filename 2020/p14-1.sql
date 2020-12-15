create or replace table advent14_1_1 as
select index i, value v
from table(flatten(split(
'mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0'
,'\n')));

create or replace function bin_str_to_number(a string)
  returns float
  language javascript
  as
  $$
    return parseInt(A, 2)
  $$
;
select bin_str_to_number('110');

with parsed as (
select i, ismask, sum(ismask) over(order by i) maskid, regexp_substr(v, 'mem\\[([0-9]*)]',1,1,'e')::number mem
  , (regexp_substr(v, '= (.*)', 1,1,'e')) the_num
  , bin_str_to_number(replace(mask, 'X', 0)) mask1
  , bin_str_to_number(replace(mask, 'X', 1)) mask0
from (
    select *, iff(v like 'mask%', 1,0) ismask
      , regexp_substr(v, 'mask = (.*)', 1,1,'e') mask
    from advent14_1_2
)
)

select sum(masked_result)
from (
    select i, mem, the_num, bitand(bitor(the_num, mask1),mask0) masked_result
      , row_number() over(partition by mem order by i desc) rn
    from (
        select i, mem, the_num
          , (select max(mask1) from parsed where a.maskid=maskid and ismask=1) mask1
          , (select max(mask0) from parsed where a.maskid=maskid and ismask=1) mask0
        from parsed a
        where ismask=0
    )
    qualify rn=1
)
;
