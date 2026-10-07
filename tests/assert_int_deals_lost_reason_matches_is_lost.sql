-- A lost deal must have a lost reason label, and a deal that is not lost must have none.
-- Catches a lost reason id that has no label in the field options.
-- Returns the deals where the two disagree; the test passes when there are none.

select
    deal_id,
    is_lost,
    lost_reason_id,
    lost_reason

from {{ ref('int_deals') }}
where is_lost <> (lost_reason is not null)
