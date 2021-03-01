create or replace function dataset.cal_tools_fp_fy(fy int64, fm int64, delta int64)
options(description="Get 454 year number after adding/subtracting months from current month")
as ((
select
extract(year from dataset.cal_tools_delta_month_date(fy, fm, delta))
));
