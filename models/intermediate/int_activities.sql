-- Activities with their type details: one row per activity.

with activities as (

    select
        activity_id,
        deal_id,
        activity_type,
        assigned_user_id,
        is_done,
        due_at

    from {{ ref('stg_activity') }}

),

activity_types as (

    select
        activity_type,
        activity_type_name,
        is_active

    from {{ ref('stg_activity_types') }}

),

deals as (

    select deal_id

    from {{ ref('int_deals') }}

)

select
    -- activity_id is shared by unrelated activities in the source, so it cannot be the key
    md5(concat_ws(
        '|',
        activities.activity_id,
        activities.deal_id,
        activities.activity_type,
        activities.assigned_user_id,
        activities.due_at
    )) as activity_key,
    activities.activity_id,
    activities.deal_id,
    -- almost no activity deal id exists in the deal change log; rows are kept either way
    deals.deal_id is not null as has_deal_history,
    activities.activity_type,
    activity_types.activity_type_name,
    case
        when lower(trim(activity_types.is_active)) = 'yes' then true
        when lower(trim(activity_types.is_active)) = 'no' then false
    end as is_activity_type_active,
    activities.assigned_user_id,
    activities.is_done,
    activities.due_at

from activities
left join activity_types
    on activities.activity_type = activity_types.activity_type
left join deals
    on activities.deal_id = deals.deal_id
