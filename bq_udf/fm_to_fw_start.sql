CREATE or replace FUNCTION dataset.cal_tools_fm_to_fw_start(fy_num int64, fm_num int64)
options(description="Determine Start Date given 454 Year and 454 Month Number")
AS
((
select
date_add(dataset.cal_tools_year_start(fy_num), interval
    CASE
        WHEN fm_num = 1 THEN (1)
        WHEN fm_num = 2 then (5)
        WHEN fm_num = 3 then (5+5)
        WHEN fm_num = 4 then (5+5+4)
        WHEN fm_num = 5 then (5+5+4+4)
        WHEN fm_num = 6 then (5+5+4+4+5)
        WHEN fm_num = 7 then (5+5+4+4+5+4)
        WHEN fm_num = 8 then (5+5+4+4+5+4+4)
        WHEN fm_num = 9 then (5+5+4+4+5+4+4+5)
        WHEN fm_num = 10 then (5+5+4+4+5+4+4+5+4)
        WHEN fm_num = 11 then (5+5+4+4+5+4+4+5+4+4)
        WHEN fm_num = 12 then (5+5+4+4+5+4+4+5+4+4+5)
      END - 1
      week)
))