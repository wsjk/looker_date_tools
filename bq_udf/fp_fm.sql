create or replace function dataset.cal_tools_fp_fm(fy int64, fm int64, delta int64)
options(description="Get 454 month number after adding/subtracting months from current month")
as ((
select
extract(month from dataset.cal_tools_delta_month_date(fy, fm, delta))
));
