create or replace function dataset.cal_tools_month_end(fiscal_year int64, fw_num int64)
options(description="calculate end date of the 454 month for a given 454 week")
as
((select
date_add(dataset.cal_tools_year_start(fiscal_year), interval
    CASE
        WHEN fw_num between 1 AND 4 THEN 4
        WHEN fw_num between 5 AND 9 THEN 9
        WHEN fw_num between 10 AND 13 THEN 13
        WHEN fw_num between 14 AND 17 THEN 17
        WHEN fw_num between 18 AND 22 THEN 22
        WHEN fw_num between 23 AND 26 THEN 26
        WHEN fw_num between 27 AND 30 THEN 30
        WHEN fw_num between 31 AND 35 THEN 35
        WHEN fw_num between 36 AND 39 THEN 39
        WHEN fw_num between 40 AND 43 THEN 43
        WHEN fw_num between 44 AND 48 THEN 48
        ELSE fw_num
      END
      week)
));