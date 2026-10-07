-- Users row count, key uniqueness and date range.
-- Result: 1,787 rows, 1,787 distinct ids, 1,783 distinct emails.
-- id is unique; four email addresses are each shared by two users.

select
    count(*) as row_count,
    count(distinct id) as distinct_ids,
    count(distinct email) as distinct_emails,
    min(modified) as first_modified,
    max(modified) as last_modified
from users;
