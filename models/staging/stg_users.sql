with source as (

    select * from {{ source('postgres_public', 'users') }}

),

renamed as (

    select
        id as user_id,
        name as user_name,
        email as user_email,
        modified as modified_at

    from source

)

select * from renamed
