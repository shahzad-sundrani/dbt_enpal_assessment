with source as (

    select * from {{ source('postgres_public', 'activity_types') }}

),

renamed as (

    select
        id as activity_type_id,
        type as activity_type,
        name as activity_type_name,
        active as is_active

    from source

)

select * from renamed
