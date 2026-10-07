-- Lost reason labels from the fields JSON.
-- Result: 5 reasons: Customer Not Ready, Pricing Issues, Unreachable Customer,
-- Product Mismatch, Duplicate Entry.

select
    field_key,
    option ->> 'id' as option_id,
    option ->> 'label' as option_label
from fields
cross join lateral jsonb_array_elements(field_value_options) as option
where field_key = 'lost_reason';
