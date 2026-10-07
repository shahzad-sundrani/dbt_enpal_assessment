-- Row counts of all source tables.
-- Result: deal_changes 15,406 / activity 4,579 / users 1,787 / stages 9 / activity_types 4 / fields 4.

select 'deal_changes' as table_name, count(*) as row_count from deal_changes
union all select 'activity', count(*) from activity
union all select 'activity_types', count(*) from activity_types
union all select 'stages', count(*) from stages
union all select 'fields', count(*) from fields
union all select 'users', count(*) from users;
