-- One row per user. Used for deal owners and for the users activities are assigned to.
-- The email address is left out on purpose, to keep personal data out of the marts.

select
    user_id,
    user_name

from {{ ref('stg_users') }}
