{{ config(severity='warn') }}

-- Reports the deals that are rejected from the model for data quality reasons.
-- Severity warn: the build continues, but the number of rejected deals is shown on every run,
-- so it is noticed if more deals start to be rejected.
-- Returns one row per rejected deal; the test passes when there are none.

select
    deal_id,
    rejection_reason,
    creation_events,
    first_created_at,
    last_created_at

from {{ ref('int_rejected_deals') }}
