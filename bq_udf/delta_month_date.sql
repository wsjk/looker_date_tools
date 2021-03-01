create or replace function dataset.cal_tools_delta_month_date(fy int64, fm int64, delta int64)
options(description="Get first or last day of month after adding/subtracting months from current month")
as ((
select
case when delta <= 0
    then date(
        case when (fm + delta) > 0 then fy when (fm + delta) <= 0 then fy-1 end, --start_fy
        case when (fm + delta) > 0 then (fm + delta) when (fm + delta) <= 0 then (12 + (fm + delta)) end, --start_fm
        1)
else
    last_day(
        date(
        case when (fm + delta) > 0 then fy when (fm + delta) <= 0 then fy-1 end, --start_fy
        case when (fm + delta) > 0 then (fm + delta) when (fm + delta) <= 0 then (12 + (fm + delta)) end, --start_fm
        1)
    )
end

));
