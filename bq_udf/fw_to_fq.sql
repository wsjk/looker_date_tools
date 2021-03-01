create or replace function dataset.cal_tools_fw_to_fq(fw_num int64)
options(description="calculate 454 quarter based on 454 wk num")
as
((
select
    CASE
    WHEN fw_num between 1 AND 13 THEN 1
    WHEN fw_num between 14 AND 26 THEN 2
    WHEN fw_num between 27 AND 39 THEN 3
    WHEN fw_num between 40 AND 53 THEN 4
    END
));