-- Activities per type, with the type name. The join is on type, not id.
-- Result: four types of about 1,100-1,200 each, roughly half done.
-- meeting = Sales Call 1 (1,145, of which 568 done), sc_2 = Sales Call 2 (1,124, of which 560 done).

select
    a.type,
    t.name,
    t.active,
    count(*) as activities,
    count(*) filter (where a.done) as done
from activity a
left join activity_types t on t.type = a.type
group by 1, 2, 3
order by 1;
