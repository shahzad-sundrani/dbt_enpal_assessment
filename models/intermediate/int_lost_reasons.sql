-- One row per lost reason, flattened from the JSON option list of the lost_reason field.

with fields as (

    select
        field_key,
        field_value_options

    from {{ ref('stg_fields') }}
    where field_key = 'lost_reason'

)

select
    (option ->> 'id')::int as lost_reason_id,
    option ->> 'label' as lost_reason

from fields
cross join lateral jsonb_array_elements(fields.field_value_options) as option
