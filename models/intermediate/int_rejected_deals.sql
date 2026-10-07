{{ config(materialized='ephemeral') }}

-- Deals that are rejected from the model because of a data quality problem.
-- A deal id with more than one creation event holds two different deals mixed under one id,
-- so its history cannot be trusted.
-- Ephemeral: not created in the database, it is inlined into the models that use it.

select
    deal_id,
    'More than one creation event' as rejection_reason,
    count(*) as creation_events,
    min(changed_at) as first_created_at,
    max(changed_at) as last_created_at

from {{ ref('stg_deal_changes') }}
where changed_field_key = 'add_time'
group by deal_id
having count(*) > 1
