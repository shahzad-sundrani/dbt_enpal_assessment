-- Activity row count, key uniqueness, nulls and date range.
-- Result: 4,579 rows but only 4,568 distinct ids, no nulls, due dates 2024-01-01 to 2024-09-13.

select
    count(*) as row_count,
    count(distinct activity_id) as distinct_ids,
    count(*) filter (where deal_id is null) as null_deals,
    count(*) filter (where due_to is null) as null_due,
    min(due_to) as first_due,
    max(due_to) as last_due
from activity;
