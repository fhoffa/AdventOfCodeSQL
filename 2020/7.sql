create or replace temp table bag_rules1 as
select index i, value v
from table(flatten(split('light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.','\n')));

create or replace temp table parsed_bag_rules1 as
select regexp_substr(v, '(.*) bags contain', 1, 1, 'e') bag_color
  , try_to_number(regexp_substr(x.value, '[0-9]*')) n_bags
  , regexp_substr(x.value, '[0-9] (.*) bag', 1, 1, 'e') contains_color
from bag_rules1, table(split_to_table(regexp_substr(v, 'bags contain (.*)\.', 1, 1, 'e'), ', ')) x
;

select count(distinct bag_color)
from parsed_bag_rules1
start with contains_color = 'shiny gold'
connect by prior bag_color =  contains_color 
;

create or replace temp table bag_rules3 as
select index i, value v
from table(flatten(split('shiny gold bags contain 2 dark red bags.
dark red bags contain 2 dark orange bags.
dark orange bags contain 2 dark yellow bags.
dark yellow bags contain 2 dark green bags.
dark green bags contain 2 dark blue bags.
dark blue bags contain 2 dark violet bags.
dark violet bags contain no other bags.','\n')));

select sum(y)
from (
    select exp(sum(ln(x.value))) y
    from (
        select *, sys_connect_by_path(n_bags, ' ') path
        from parsed_bag_rules1
        start with bag_color = 'shiny gold'
        connect by bag_color = prior contains_color 
    ), table(split_to_table(substr(path, 2), ' ')) x
    group by x.seq
)
;
