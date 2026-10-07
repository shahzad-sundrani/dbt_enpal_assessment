-- One row per deal: its current state plus how far it got in the funnel.

with deals as (

    select
        deal_id,
        created_at,
        owner_user_id,
        current_stage_id,
        current_stage_name,
        current_stage_entered_at,
        is_lost,
        lost_at,
        lost_reason_id,
        lost_reason

    from {{ ref('int_deals') }}

),

users as (

    select
        user_id,
        user_name

    from {{ ref('stg_users') }}

),

stage_summary as (

    select
        deal_id,
        max(stage_id) as furthest_stage_id,
        count(distinct stage_id) as stages_entered

    from {{ ref('int_deal_stage_changes') }}
    group by deal_id

)

select
    deals.deal_id,
    deals.created_at,
    deals.owner_user_id,
    -- the owner's name is kept here to save a join; other user details are in dim_users
    users.user_name as owner_name,
    deals.current_stage_id,
    deals.current_stage_name,
    deals.current_stage_entered_at,
    stage_summary.furthest_stage_id,
    stage_summary.stages_entered,
    deals.is_lost,
    deals.lost_at,
    deals.lost_reason_id,
    deals.lost_reason,
    extract(day from deals.lost_at - deals.created_at)::int as days_from_creation_to_lost

from deals
left join users
    on deals.owner_user_id = users.user_id
left join stage_summary
    on deals.deal_id = stage_summary.deal_id
