-- Stage names in stages versus the stage labels in the fields JSON.
-- Result: 9 stages, all matching except stage 2 ("Qualified lead" versus "Qualified Lead").

with stage_options as (
    select jsonb_array_elements(field_value_options) as option
    from fields
    where field_key = 'stage_id'
)
select
    s.stage_id,
    s.stage_name,
    o.option ->> 'label' as field_label,
    s.stage_name = o.option ->> 'label' as same
from stages s
join stage_options o on (o.option ->> 'id')::int = s.stage_id
order by 1;
