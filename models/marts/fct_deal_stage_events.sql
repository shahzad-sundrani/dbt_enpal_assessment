-- One row each time a deal enters a stage. Source of funnel steps 1 to 9.

with stage_changes as (

    select
        deal_id,
        stage_id,
        stage_name,
        entered_at,
        exited_at,
        is_first_entry

    from {{ ref('int_deal_stage_changes') }}

),

deals as (

    select
        deal_id,
        lost_at

    from {{ ref('int_deals') }}

)

select
    stage_changes.deal_id,
    stage_changes.stage_id,
    stage_changes.stage_name,
    -- joins to dim_date.date_day
    stage_changes.entered_at::date as entered_date,
    stage_changes.entered_at,
    stage_changes.exited_at,
    -- a deal's last stage ends when the deal is lost
    extract(
        day from coalesce(stage_changes.exited_at, deals.lost_at) - stage_changes.entered_at
    )::int as days_in_stage,
    stage_changes.is_first_entry,
    stage_changes.exited_at is null as is_current_stage

from stage_changes
left join deals
    on stage_changes.deal_id = deals.deal_id
