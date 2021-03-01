create or replace function dataset.cal_tools_month_start(fiscal_year_start date, fw_num int64)
options(description="calculate start date of 454 month of a given 454 week")
as
((
select date_add(fiscal_year_start, interval
    CASE
        WHEN fw_num between 1 AND 4 THEN 1
        WHEN fw_num between 5 AND 9 THEN 5
        WHEN fw_num between 10 AND 13 THEN 10
        WHEN fw_num between 14 AND 17 THEN 14
        WHEN fw_num between 18 AND 22 THEN 18
        WHEN fw_num between 23 AND 26 THEN 23
        WHEN fw_num between 27 AND 30 THEN 27
        WHEN fw_num between 31 AND 35 THEN 31
        WHEN fw_num between 36 AND 39 THEN 36
        WHEN fw_num between 40 AND 43 THEN 40
        WHEN fw_num between 44 AND 48 THEN 44
        ELSE 49
      END-1
      week)
));