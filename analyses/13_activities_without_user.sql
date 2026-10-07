-- Activities assigned to a user id missing from users.
-- Result: 0.

select count(*) filter (where u.id is null) as activities_without_user
from activity a
left join users u on u.id = a.assigned_to_user;
