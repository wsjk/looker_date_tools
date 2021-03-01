# 4-5-4 Calendar Date Tools

This repo contains LookML code that can be used to filter a date partitioned BigQuery table by date intervals based on a
custom 4-5-4 retail calendar. An except of this custom calendar is provided in [`454_calendar.csv`](454_calendar.csv).

### Why Use A Custom Calendar?
The retail industry are primary users of 4-5-4 calendars as it allows for a better 
[year-over-year comparison](https://nrf.com/resources/4-5-4-calendar):
```
The 4-5-4 calendar is a guide for retailers that ensures sales comparability between years by dividing the year into 
months based on a 4 weeks – 5 weeks – 4 weeks format. The layout of the calendar lines up holidays and ensures the same 
number of Saturdays and Sundays in comparable months. Hence, like days are compared to like days for sales reporting 
purposes. 
```

The calendar used for examples in this repo are baesed off of the [NRF's 4-5-4 calendar](https://nrf.com/resources/4-5-4-calendar),
but with some modifications.

An except of this custom calendar is provided in [`454_calendar.csv`](454_calendar.csv).

### The Problem
It is easy to use BigQuery's native date functions to filter a date partitioned table if the user is only concerned about
calendar date fields. BigQuery's date functions do not support, however, custom calendars (e.g., 4-5-4, 4-4-5) definitions.

For example, to find the beginning of the start date of the current calendar month, you can run:
```buildoutcfg
SELECT
    DATE_TRUNC(CURRENT_DATE(), MONTH)
```

Unfortunately, the start date of the month in a 4-5-4 calendar does not align with the calendar date. 

For example, the start of calendar year 2021 may be `2021-01-01` (`YYYY-MM-DD`), but in terms of a custom 4-5-4 calendar 
the start of 2021 is actually `2020-12-27`.

There are additional constraints in Looker that must be dealt with when you are trying to use date filters based on a
custom calendar.

When working in BigQuery alone, you may create a mapping table that would provide 

### The Approach
To be able to filter in Looker, a combination of BigQuery User Defined Functions, LookML code, and SQL conditional 
statements are used.

The BigQuery UDFs can be found in the [bq_udf](bq_udf) folder in this repo. The LookML blocks can be found in 
[`454_tools.view`](454_tools.view)
