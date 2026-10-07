-- Monthly sales funnel: how many deals entered each funnel step in each month.
-- One row per month and funnel step, including months in which no deal entered the step.

with funnel_steps as (

    select
        funnel_step,
        kpi_name,
        stage_id,
        activity_type

    from {{ ref('dim_funnel_steps') }}

),

dates as (

    select
        date_day,
        month_start

    from {{ ref('dim_date') }}

),

-- steps 1 to 9: a deal enters a step in the month it first enters the stage
stage_events as (

    select
        dates.month_start as month,
        funnel_steps.funnel_step,
        events.deal_id

    from {{ ref('fct_deal_stage_events') }} as events
    inner join dates
        on events.entered_date = dates.date_day
    inner join funnel_steps
        on events.stage_id = funnel_steps.stage_id
    where events.is_first_entry

),

-- steps 2.1 and 3.1: a deal enters a step in the month a sales call was completed;
-- the join to the funnel steps keeps only the two sales call activity types
call_events as (

    select
        dates.month_start as month,
        funnel_steps.funnel_step,
        activities.deal_id

    from {{ ref('fct_activities') }} as activities
    inner join dates
        on activities.due_date = dates.date_day
    inner join funnel_steps
        on activities.activity_type = funnel_steps.activity_type
    where activities.is_done

),

funnel_events as (

    select month, funnel_step, deal_id from stage_events

    union all

    select month, funnel_step, deal_id from call_events

),

monthly_counts as (

    select
        month,
        funnel_step,
        count(distinct deal_id) as deals_count

    from funnel_events
    group by month, funnel_step

),

-- every month between the first and the last funnel event
months as (

    select distinct month_start as month

    from dates
    where month_start between (select min(month) from funnel_events)
                          and (select max(month) from funnel_events)

)

select
    months.month,
    funnel_steps.kpi_name,
    funnel_steps.funnel_step,
    coalesce(monthly_counts.deals_count, 0) as deals_count

from months
cross join funnel_steps
left join monthly_counts
    on months.month = monthly_counts.month
    and funnel_steps.funnel_step = monthly_counts.funnel_step
