# 4-5-4 Calendar Date Tools

This repo contains LookML code that can be used to filter a date partitioned BigQuery table by date intervals based on 
4-5-4 retail calendar. 

### The Problem
It is easy to use BigQuery's native date functions to filter a date partitioned table if the user is only concerned about
calendar date fields. BigQuery's date functions do not support, however, custom calendars (e.g., 4-5-4, 4-4-5) definitions.

For example, to find the beginning of the start date of the current calendar month, you can run:
```buildoutcfg
SELECT
    DATE_TRUNC(CURRENT_DATE(), MONTH)
```

Unfortunately, the start date of the month in a 4-5-4 calendar does not align with the calendar date. 