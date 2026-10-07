-- Owner changes that point to a user id missing from users.
-- Result: 0.

select count(*) filter (where u.id is null) as owner_changes_without_user
from deal_changes c
left join users u on u.id = c.new_value::int
where c.changed_field_key = 'user_id';
