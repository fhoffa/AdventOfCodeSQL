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

select count_if(r)
from (
    select count(*)=8 or (count(*)=7 and count_if(field='cid')=0) r
    from (
        select i, substr(value, 0, 3) field
        from passports2, lateral flatten(v)
    )
    group by i
);
