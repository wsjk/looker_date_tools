create or replace function dataset.cal_tools_qtr_start(fiscal_year_start date, fw_num int64)
options(description="calculate start date of given 454 month")
as
((
    select date_add(fiscal_year_start, interval
    CASE
        WHEN fw_num between 1 AND 13 THEN 1
        WHEN fw_num between 14 AND 26 THEN 14
        WHEN fw_num between 27 AND 39 THEN 27
        ELSE 40
      END-1
      week)
));