CREATE or replace FUNCTION dataset.cal_tools_current_fw_num(current_date string)
options(description="Determine Current 454 Week Number for given timezone")
AS
((
select DATE_DIFF(current_date(tz), dataset.cal_tools_year_start(dataset.cal_tools_year(current_date(tz))), WEEK) +1
))