create or replace function dataset.cal_tools_num_wks(fiscal_year int64)
options(description="number of weeks in 454 year")
as
((select case when fiscal_year in (2004, 2009, 2015, 2021) then 53 else 52 end));