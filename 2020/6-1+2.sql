create or replace temp table questions as 
select index i, strtok_to_array(value, '\n ') v
from table(flatten(SPLIT(
'abc

a
b
c

ab
ac

a
a
a
a

b', '\n\n')));

select sum(answers)
from (
    select i, count(distinct y.value) answers
    from questions
      , lateral flatten(input=>v) x
      , table(split_to_table(regexp_replace(x.value, '.', ',\\0', 2), ',')) y
    group by i  
);

select sum(common_answers)
from (
    select i, count_if(letter_count=group_size) common_answers
    from (
        select i, y.value letter, count(*) letter_count, array_size(any_value(v)) group_size
        from questions2
          , lateral flatten(input=>v) x
          , table(split_to_table(regexp_replace(x.value, '.', ',\\0', 2), ',')) y
        group by i, y.value
    )
    group by i
)
;
