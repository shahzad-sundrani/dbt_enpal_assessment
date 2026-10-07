-- Which deal fields change, and how often.
-- Result: four fields (stage_id 8,906 rows, user_id 2,500, add_time 2,000, lost_reason 2,000),
-- 1,995 deals in each, no nulls, changes from 2024-01 to 2025-03.

select
    changed_field_key,
    count(*) as row_count,
    count(distinct deal_id) as deals,
    count(distinct new_value) as distinct_values,
    count(*) filter (where new_value is null) as null_values,
    min(change_time) as first_change,
    max(change_time) as last_change
from deal_changes
group by changed_field_key
order by row_count desc;
