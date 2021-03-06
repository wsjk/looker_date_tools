# 4-5-4 Calendar Date Tools

This repo contains LookML code that can be used to filter a date partitioned BigQuery table by date intervals based on a
custom 4-5-4 retail calendar. An except of this custom calendar is provided in [`454_calendar.csv`](454_calendar.csv).

## Why Use A Custom Calendar?
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

## The Problem
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

When working in BigQuery alone, you could have a mapping table (e.g. [`454_calendar.csv`](454_calendar.csv)) and use that
to determine dates for filtering:
```buildoutcfg
declare start_date as date;
declare end_date as date;

set start_date = (select min(date(cal_date)) from 454_calendar where 454_year = 2021 and 454_week = 2);
set end_date = (select max(date(cal_date)) from 454_calendar where 454_year = 2021 and 454_week = 2);

--filter sample_table for second week of 2021 in 454 calendar
select 
*
from sample_table
where partition_field_date between start_date and end_date
```

Problems arise in Looker when you try to do the above in a [`derived_table` SQL block](https://docs.looker.com/reference/view-params/derived_table)
for a view, but then create an [NDT off of that view](https://docs.looker.com/data-modeling/learning-lookml/creating-ndts#defining_a_native_derived_table_in_lookml).
You'll notice errors because the `declare` statements being nested in the NDT.


## The Approach
To be able to filter in Looker, a combination of BigQuery User Defined Functions, LookML code, and SQL conditional 
statements are used.

The BigQuery UDFs can be found in the [bq_udf](bq_udf) folder in this repo and the functions will have to be 
created in your BigQuery project to use the LookML blck. The LookML blocks can be found in 
[`454_tools.view`](454_tools.view).

<details>
<summary><h3>Views</h3></summary>
<p>
    
There are 5 views defined in [`454_tools.view`](454_tools.view) file:
- 454_tools_parameters
    - Contains only parameters. Can be extended by other views for binding filters
- 454_tools
    - Generates the final filters that are applied to partition field date  
- repository_variables
    - Contains dimensions and filters for using custom repository variables. 
      Dynamic in the sense that it changes based on run date.
- py_repository_variables
    - Combined with repository_variables to conduct year-over-year analysis 
- 454_fixed_period_filters
    - Contains dimensions and filters for finding specific 454 dates (i.e., not dynamic)

<details>
<summary><h4>Fixed Period Filters</h4></summary>
<p>
    
<summary><h5>What Year is it in 454 calendar?</h5></summary> 

This question alone is difficult to answer when you're at the beginning/end of a calendar year. As mentioned above,
a year can start in December or January in a 454 calendar.

</p>
</details>


<details>
<summary><h4>Repository Variables</h4></summary>
<p>

</p>
</details>
</p>
</details>
