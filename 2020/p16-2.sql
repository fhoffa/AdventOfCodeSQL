create table advent16_2_a_2
as 
select split_part(a.value, ':', 1) desc
, try_to_number(regexp_substr(b.value, '[0-9]*')) vmin, -try_to_number(regexp_substr(b.value, '-[0-9]*')) vmax
from table(flatten(split(
'departure location: 27-840 or 860-957
departure station: 28-176 or 183-949
departure platform: 44-270 or 277-967
...'
, '\n'))) a, table(split_to_table(value::string, ' ')) b
having vmin>0 
;


with good_tickets as (
    select i
    from (
        select i, v, boolor_agg(isgood) isgood
        from (
            select i, v, v between vmin and vmax isgood
            from advent16_1_a_2, advent16_1_b_2
        )
        group by i, v
    ) 
    group by i
    having booland_agg(isgood) 
), ranked_choices as (
    select count(distinct i) c, desc, pos_n
        , count(*) over(partition by desc) choices
    from (
        select i, v, pos_n, desc, v between vmin and vmax isgood, vmin, vmax
        from advent16_2_a_2, advent16_1_b_2
        where i in (select * from good_tickets)
        -- and i=1
    )
    where isgood
    group by desc, pos_n
    having c=191
), each_pos as (
    select *
    from ranked_choices a
    where pos_n not in (
        select pos_n
        from ranked_choices
        where choices<a.choices
    )
)

select exp(sum(ln(v)))
from each_pos
join advent16_1_b_2
using(pos_n)
where i=0
and desc like 'departure%'
;
