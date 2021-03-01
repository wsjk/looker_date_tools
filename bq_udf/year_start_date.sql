CREATE or replace FUNCTION dataset.cal_tools_year_start(current_fy int64)
options(description="Determine Start Date of given 454 Year")
AS
((
select
    case when current_fy in (2004, 2009, 2015, 2021) then
        date_trunc(date(current_fy, 1,1), week)
    when extract(dayofweek from date(current_fy, 1,1)) >= 6 then
    date_add(date_trunc(date(current_fy, 1,1), week), interval 1 week)
    else
    date_trunc(date(current_fy, 1,1), week)
    end
))
;