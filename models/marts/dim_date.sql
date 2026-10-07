-- Calendar with one row per day, generated without reading any table.
-- The fixed range runs from one month before the earliest date in the data (2024-01-01)
-- to one year after the latest (2025-03-11), in whole months. Extend the end date when
-- the data moves past it; the relationships tests on the facts fail if a date is missing.

with days as (

    select generate_series(
        '2023-12-01'::date,
        '2026-03-31'::date,
        interval '1 day'
    )::date as date_day

)

select
    date_day,
    -- weeks start on Monday
    date_trunc('week', date_day)::date as week_start,
    date_trunc('month', date_day)::date as month_start,
    to_char(date_day, 'YYYY-MM') as year_month,
    extract(year from date_day)::int as year,
    extract(quarter from date_day)::int as quarter,
    extract(month from date_day)::int as month_number,
    to_char(date_day, 'FMMonth') as month_name,
    to_char(date_day, 'FMDay') as day_name,
    extract(isodow from date_day) in (6, 7) as is_weekend

from days
