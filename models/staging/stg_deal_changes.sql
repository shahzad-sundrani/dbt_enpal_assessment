with source as (

    select * from {{ source('postgres_public', 'deal_changes') }}

),

renamed as (

    select
        deal_id,
        changed_field_key,
        new_value,
        change_time as changed_at

    from source

)

select * from renamed
