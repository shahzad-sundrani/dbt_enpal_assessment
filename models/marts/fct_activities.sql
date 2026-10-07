-- One row per activity. Source of funnel steps 2.1 (Sales Call 1) and 3.1 (Sales Call 2).

select
    activity_key,
    activity_id,
    deal_id,
    has_deal_history,
    activity_type,
    activity_type_name,
    is_activity_type_active,
    -- user details are looked up in dim_users
    assigned_user_id,
    is_done,
    -- joins to dim_date.date_day
    due_at::date as due_date,
    due_at

from {{ ref('int_activities') }}
