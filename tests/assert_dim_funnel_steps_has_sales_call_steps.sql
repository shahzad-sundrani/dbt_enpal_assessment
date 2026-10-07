-- The two sales call steps must always be part of the funnel.
-- They are joined to the activity types, so a step would silently disappear if its
-- activity type were removed or renamed in the source.
-- Returns the expected steps that are missing; the test passes when there are none.

with expected_steps (funnel_step) as (

    values
        ('Step 2.1'),
        ('Step 3.1')

)

select expected_steps.funnel_step

from expected_steps
left join {{ ref('dim_funnel_steps') }} as funnel_steps
    on expected_steps.funnel_step = funnel_steps.funnel_step
where funnel_steps.funnel_step is null
