-- part 1

select bus_cycle*(min_bus-arrival)
from (
    select *, (ceil(arrival/bus_cycle))*bus_cycle min_bus
    from (
        select split_part(x, '\n', 1) arrival, try_to_number(y.value) bus_cycle
        from (
        select 
'939
7,13,x,x,59,x,31,19'
            x
        ), table(split_to_table(split_part(x, '\n', 2), ',')) y
    )
    order by min_bus 
    limit 1
);

-- part 2 

-- generate equation for wolfram alpha
-- solve (41*a_2=23*a_1+13, 383*a_3=41*a_2+10, 13*a_4=383*a_3+13, 17*a_5=13*a_4+1, 19*a_6=17*a_5+5, 29*a_7=19*a_6+10, 503*a_8=29*a_7+2, 37*a_9=503*a_8+37) over the integers
select 'solve ('||listagg(eq, ', ')||') over the integers'
from (
    select v || '*a_' || rn || '=' || lag(v) over(order by i)  || '*a_' || lag(rn) over(order by i) || '+' || diff eq
    from (
        select index i, try_to_number(value) v, i - lag(i) over(order by i) diff, row_number() over(order by i) rn
        from table(split_to_table('7,13,x,x,59,x,31,19',','))
        having v>0
        order by i
    )
    order by i
);
