CREATE or replace FUNCTION dataset.cal_tools_fw_to_fm(fw_num int64)
options(description="Determine 454 Month based on 454 Week Number")
AS 
((
select CASE
    WHEN fw_num between 1 AND 4 THEN 1
    WHEN fw_num between 5 AND 9 THEN 2
    WHEN fw_num between 10 AND 13 THEN 3
    WHEN fw_num between 14 AND 17 THEN 4
    WHEN fw_num between 18 AND 22 THEN 5
    WHEN fw_num between 23 AND 26 THEN 6
    WHEN fw_num between 27 AND 30 THEN 7
    WHEN fw_num between 31 AND 35 THEN 8
    WHEN fw_num between 36 AND 39 THEN 9
    WHEN fw_num between 40 AND 43 THEN 10
    WHEN fw_num between 44 AND 48 THEN 11
    ELSE 12
END
))
;