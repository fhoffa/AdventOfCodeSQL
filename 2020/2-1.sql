create or replace temp table passwords as
select regexp_substr(v, '[0-9]*') pmin
, regexp_substr(v, '-([0-9]*)', 1, 1, 'e') pmax
, regexp_substr(v, '[a-z]') char
, regexp_substr(v, '[a-z]+$') pass
from (
    select index i, value v
    from table(flatten(SPLIT(
'1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc'
, '\n'))));

select count_if(
  len(regexp_replace(pass, '[^'||char||']', '')) between pmin and pmax
) result
from passwords;
