-- Activity ids that appear on more than one row.
-- Result: 22 rows (11 ids x 2). Each pair differs in deal, type, user and date,
-- so they are different activities that share an id.

with duplicated_ids as (
    select activity_id
    from activity
    group by activity_id
    having count(*) > 1
)
select a.*
from activity a
join duplicated_ids d on d.activity_id = a.activity_id
order by a.activity_id, a.due_to;
