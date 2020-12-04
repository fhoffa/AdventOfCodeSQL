create or replace temp table passports as 
select index i, strtok_to_array(value, '\n ') v
from table(flatten(SPLIT(
'ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm
iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929
hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm
hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in'
, '\n\n')));

create or replace function val_pass(a string, b string)
  returns boolean
  as
  $$
    case a
    when 'byr' then (b::int between 1920 and 2002)
    when 'iyr' then (b::int between 2010 and 2020)
    when 'eyr' then (b::int between 2020 and 2030)
    when 'hgt' then (b between '150cm' and '193cm' and substr(b,4,2)='cm')  or (b between '59in' and '76in' and substr(b,3,2)='in')
    when 'hcl' then (regexp_instr(b, '^#[0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f][0-9a-f]$'))
    when 'ecl' then (array_contains(b::variant, split('amb blu brn gry grn hzl oth',' ')))
    when 'pid' then (regexp_instr(b, '^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]$'))
   end 
  $$
;

select count_if(r2=7 and r)
from (
    select i, count_if(val_pass(field, val )) r2, count(*)=8 or (count(*)=7 and count_if(field='cid')=0) r
    from (
        select i, substr(value, 0, 3) field, substr(value, 5) val
        from passports2, lateral flatten(v)
    )
    group by 1
)
;
