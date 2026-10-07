-- Stage entries and distinct deals per stage.
-- Result: a shrinking funnel from 1,995 deals in stage 1 down to 324 in stage 9.
-- Where stage_entries is higher than deals, a deal entered that stage twice.

select
    new_value::int as stage_id,
    count(*) as stage_entries,
    count(distinct deal_id) as deals
from deal_changes
where changed_field_key = 'stage_id'
group by 1
order by 1;
