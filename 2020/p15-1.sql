create or replace procedure advent15_insert_until_2020(RS float)
  returns float not null
  language javascript
  as    
$$
var sqlInsert = `  
insert into advent15_1_2
select b.i + 1, ifnull(b.i-a.i,0)
from advent15_1_2 a
right join (
    select *
    from advent15_1_2
    order by i desc
    limit 1
) b
on a.i<b.i
and a.v=b.v
order by a.i desc
limit 1;
`;

for (i = 0; i < RS; i++) {
    var statement1 = snowflake.createStatement( {sqlText: sqlInsert} );
    var result_set1 = statement1.execute()
}
return RS
$$;

call advent15_insert_until_2020((select 2020-max(i) from advent15_1_2));

select *
from advent15_1_2
order by i desc;
