-- Do the deals referenced by activities exist in the deal change log?
-- Result: 4,572 activity deals, only 8 found in deal_changes.

with deals as (
    select distinct deal_id
    from deal_changes
)
select
    count(distinct a.deal_id) as activity_deals,
    count(distinct d.deal_id) as found_in_deal_changes
from activity a
left join deals d on d.deal_id = a.deal_id;
