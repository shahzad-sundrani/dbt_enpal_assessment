-- Deals with more than one creation event.
-- Result: 5 deal ids (399956, 554294, 556338, 851850, 955417), each with 2 add_time rows.
-- This is why there are 2,000 add_time rows but only 1,995 deals.

select deal_id, count(*) as creation_events
from deal_changes
where changed_field_key = 'add_time'
group by deal_id
having count(*) > 1;

-- Full history of one of them:
-- select * from deal_changes where deal_id = 399956 order by change_time;
