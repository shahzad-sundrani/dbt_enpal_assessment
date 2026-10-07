-- Exact duplicate rows in the deal change log.
-- Result: 0 rows.

select deal_id, change_time, changed_field_key, new_value, count(*)
from deal_changes
group by 1, 2, 3, 4
having count(*) > 1;
