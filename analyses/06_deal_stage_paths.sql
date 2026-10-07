-- The path each deal takes through the stages, most common first.
-- Result: the top path is 1 > 2 > 3 > 4 (82 deals), but many paths skip stages,
-- such as 1 > 2 > 3 > 5 (60 deals).

with paths as (
    select
        deal_id,
        string_agg(new_value, ' > ' order by change_time) as stage_path
    from deal_changes
    where changed_field_key = 'stage_id'
    group by deal_id
)
select
    stage_path,
    count(*) as deals
from paths
group by stage_path
order by deals desc;
