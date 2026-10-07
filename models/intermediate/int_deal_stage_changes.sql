-- Stage history of every deal: one row each time a deal enters a stage.

with rejected_deals as (

    select deal_id

    from {{ ref('int_rejected_deals') }}

),

stage_changes as (

    select
        deal_changes.deal_id,
        deal_changes.new_value::int as stage_id,
        deal_changes.changed_at as entered_at

    from {{ ref('stg_deal_changes') }} as deal_changes
    where deal_changes.changed_field_key = 'stage_id'
        -- leave out deals rejected for data quality reasons
        and not exists (
            select 1
            from rejected_deals
            where rejected_deals.deal_id = deal_changes.deal_id
        )

),

stages as (

    select
        stage_id,
        stage_name

    from {{ ref('stg_stages') }}

)

select
    stage_changes.deal_id,
    stage_changes.stage_id,
    stages.stage_name,
    stage_changes.entered_at,
    -- the deal leaves a stage when it enters the next one; empty for its latest stage
    lead(stage_changes.entered_at) over (
        partition by stage_changes.deal_id
        order by stage_changes.entered_at
    ) as exited_at,
    -- false when the deal comes back to a stage it has been in before
    row_number() over (
        partition by stage_changes.deal_id, stage_changes.stage_id
        order by stage_changes.entered_at
    ) = 1 as is_first_entry

from stage_changes
left join stages
    on stage_changes.stage_id = stages.stage_id
