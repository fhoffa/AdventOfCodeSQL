create or replace temp table instructions1 as
select index id, split_part(value, ' ', 1) op, split_part(value, ' ', 2)::int v
from table(flatten(split(
'nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6','\n')));

create or replace table instructions1_plus as
select *, case op when 'jmp' then id+v else id+1 end next
from instructions1;

CREATE OR REPLACE PROCEDURE looping_process(ID float)
RETURNS variant
LANGUAGE JAVASCRIPT
AS
$$ 
  var visited = [];
  var id=ID;
  var acc=0;
  while(!visited.includes(id)) {
      visited.push(id);
      var row_count_query = snowflake.createStatement({
        sqlText: "select OP, V, NEXT from instructions1_plus where id=?",
        binds: [id]
        });
      var res = row_count_query.execute();
      res.next();
      if(res.getColumnValue('OP')=='acc') {
        acc += res.getColumnValue('V')
      }
      id=res.getColumnValue('NEXT');
  }
  return acc;
$$
;
call looping_process(0);
