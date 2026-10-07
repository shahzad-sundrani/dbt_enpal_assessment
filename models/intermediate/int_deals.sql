-- One row per deal with its current state, rebuilt from the change log
-- (the source has no deals table).

with rejected_deals as (

    select deal_id

    from {{ ref('int_rejected_deals') }}

),

deal_changes as (

    select
        deal_changes.deal_id,
        deal_changes.changed_field_key,
        deal_changes.new_value,
        deal_changes.changed_at

    from {{ ref('stg_deal_changes') }} as deal_changes
    -- leave out deals rejected for data quality reasons
    where not exists (
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

),

lost_reasons as (

    select
        lost_reason_id,
        lost_reason

    from {{ ref('int_lost_reasons') }}

),

-- number the changes of each field per deal, newest first
ranked as (

    select
        deal_id,
        changed_field_key,
        new_value,
        changed_at,
        row_number() over (
            partition by deal_id, changed_field_key
            order by changed_at desc
        ) as recency_rank

    from deal_changes

),

-- one row per deal: the creation time and the latest value of every other field
deals as (

    select
        deal_id,
        min(changed_at) filter (where changed_field_key = 'add_time') as created_at,
        max(new_value::int) filter (where changed_field_key = 'stage_id' and recency_rank = 1) as current_stage_id,
        max(changed_at) filter (where changed_field_key = 'stage_id' and recency_rank = 1) as current_stage_entered_at,
        max(new_value::int) filter (where changed_field_key = 'user_id' and recency_rank = 1) as owner_user_id,
        max(new_value::int) filter (where changed_field_key = 'lost_reason' and recency_rank = 1) as lost_reason_id,
        max(changed_at) filter (where changed_field_key = 'lost_reason' and recency_rank = 1) as lost_at

    from ranked
    group by deal_id

)

select
    deals.deal_id,
    deals.created_at,
    deals.owner_user_id,
    deals.current_stage_id,
    stages.stage_name as current_stage_name,
    deals.current_stage_entered_at,
    deals.lost_at is not null as is_lost,
    deals.lost_at,
    deals.lost_reason_id,
    lost_reasons.lost_reason

from deals
left join stages
    on deals.current_stage_id = stages.stage_id
left join lost_reasons
    on deals.lost_reason_id = lost_reasons.lost_reason_id
