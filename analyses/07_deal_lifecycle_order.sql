-- Order of events in a deal's life.
-- Result: 1,995 / 1,995 / 1,995 / 324. Every deal enters stage 1 after it is created,
-- and every deal ends up lost, including the 324 that reach stage 9.

with deals as (
    select
        deal_id,
        min(change_time) filter (where changed_field_key = 'add_time') as created,
        min(change_time) filter (where changed_field_key = 'stage_id' and new_value = '1') as entered_stage_1,
        max(change_time) filter (where changed_field_key = 'lost_reason') as lost,
        max(new_value::int) filter (where changed_field_key = 'stage_id') as furthest_stage
    from deal_changes
    group by deal_id
)
select
    count(*) as deals,
    count(*) filter (where entered_stage_1 > created) as stage_1_after_creation,
    count(*) filter (where lost is not null) as lost_deals,
    count(*) filter (where furthest_stage = 9) as reached_stage_9
from deals;
