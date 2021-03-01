create or replace function dataset.cal_tools_qtr_end(fiscal_year_start date, fw_num int64)
options(description="calculate end date of given 454 month")
as
((select
date_add(fiscal_year_start, interval
    CASE
        WHEN fw_num between 1 AND 13 THEN 13
        WHEN fw_num between 14 AND 26 THEN 126
        WHEN fw_num between 27 AND 39 THEN 39
        ELSE fw_num
      END
      week)
      ))
      ;