-- The definition of the sales funnel: one row per funnel step.
-- Steps 1 to 9 are the pipeline stages. Steps 2.1 and 3.1 are the two sales calls.

with stages as (

    select
        stage_id,
        stage_name

    from {{ ref('stg_stages') }}

),

activity_types as (

    select
        activity_type,
        activity_type_name

    from {{ ref('stg_activity_types') }}

),

-- The position of the sales calls in the funnel is a business definition that exists in
-- no source table, so it is set here. Only the activity types listed are funnel steps.
call_step_mapping (activity_type, funnel_step, step_order) as (

    values
        ('meeting', 'Step 2.1', 2.1),
        ('sc_2', 'Step 3.1', 3.1)

),

-- every stage in the source is a funnel step, so a new stage appears here automatically
stage_steps as (

    select
        'Step ' || stage_id as funnel_step,
        stage_name as kpi_name,
        stage_id::numeric as step_order,
        'stage' as step_source,
        stage_id,
        null::text as activity_type

    from stages

),

call_steps as (

    select
        call_step_mapping.funnel_step,
        activity_types.activity_type_name as kpi_name,
        call_step_mapping.step_order,
        'activity' as step_source,
        null::int as stage_id,
        activity_types.activity_type

    from call_step_mapping
    inner join activity_types
        on call_step_mapping.activity_type = activity_types.activity_type

)

select
    funnel_step,
    kpi_name,
    step_order,
    step_source,
    stage_id,
    activity_type

from stage_steps

union all

select
    funnel_step,
    kpi_name,
    step_order,
    step_source,
    stage_id,
    activity_type

from call_steps
