CREATE or replace FUNCTION dataset.cal_tools_year(current_ts_date date)
options(description="Determines 454 Year Based on Date Arg")
AS 
((
select case when extract(year from date_trunc(current_ts_date, week)) <> extract(year from last_day(current_ts_date, week)) then
  case when extract(year from current_ts_date) in (2004, 2009, 2015, 2021) then
    case when extract(month from current_ts_date) = 1 then
      extract(year from last_day(current_ts_date, week))
    when extract(month from current_ts_date) = 12 then
      extract(year from date_trunc(current_ts_date, week))
    end
  when extract(month from current_ts_date) = 1 and extract(dayofweek from date_trunc(current_ts_date, year)) >= 6 then
    extract(year from date_trunc(current_ts_date, week))
  when extract(month from current_ts_date) = 12 and extract(dayofweek from date_trunc(current_ts_date, year)) >= 6 then
    extract(year from date_trunc(current_ts_date, week))
  else
    extract(year from last_day(current_ts_date, week))
  end
  else
  extract(year from last_day(current_ts_date, week))
  end
));