create table advent16_1_a_2
as 
select try_to_number(regexp_substr(value, '[0-9]*')) vmin, -try_to_number(regexp_substr(value, '-[0-9]*')) vmax
from table(flatten(split(
'departure location: 27-840 or 860-957
departure station: 28-176 or 183-949
departure platform: 44-270 or 277-967
...'
, ' '))) v
having vmin>0 
;

create or replace table advent16_1_b_2 as
select a.index i, b.value::number v, b.index::number pos_n
from table(flatten(split(
'83,53,73,139,127,131,97,113,61,101,107,67,79,137,89,109,103,59,149,71
541,797,657,536,243,821,805,607,97,491,714,170,714,533,363,491,896,399,710,865
351,879,143,113,228,415,393,714,163,171,233,726,422,469,706,264,83,354,309,915
590,56,148,311,729,76,884,352,590,419,205,393,287,761,305,838,76,762,390,914
...'
    , '\n'))) a, table(split_to_table(a.value::string, ',')) b
    ;
    

select sum(v)
from (
    select i, v, boolor_agg(isgood) isgood
    from (
        select i, v, v between vmin and vmax isgood
        from advent16_1_a_2, advent16_1_b_2
    )
    group by i, v
)
where not isgood
;
