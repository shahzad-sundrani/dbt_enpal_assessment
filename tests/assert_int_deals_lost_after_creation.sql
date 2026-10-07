-- A deal cannot be lost before it was created.
-- Returns deals with an impossible timeline; the test passes when there are none.

select
    deal_id,
    created_at,
    lost_at

from {{ ref('int_deals') }}
where lost_at < created_at
