with source as (

    select * from {{ source('postgres_public', 'activity') }}

),

renamed as (

    select
        activity_id,
        deal_id,
        type as activity_type,
        assigned_to_user as assigned_user_id,
        done as is_done,
        due_to as due_at

    from source

)

select * from renamed
