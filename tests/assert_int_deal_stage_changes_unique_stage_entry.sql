-- A deal can enter a stage only once at a given time (the grain of the model).
-- Returns the duplicated combinations; the test passes when there are none.

select
    deal_id,
    stage_id,
    entered_at,
    count(*) as row_count

from {{ ref('int_deal_stage_changes') }}
group by deal_id, stage_id, entered_at
having count(*) > 1
