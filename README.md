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

### Views
    
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

All filters are viewable under the view label: `_Reporting Date Tools`
and group label: `4-5-4 Tools ({{ _view._name}})`

<details>
<summary><h4>454 Tools</h4></summary>
<p>

The `454_tools` view extends `454_parameters`, `454_fixed_period_filters`, `repository_variables`, and 
`py_repository_variables`. This is the view that is extended in a view that is based off a table so that
users have access to the date filters tools. 

An example of how to extend `454_tools` in a view so that users can see date filters in the Explore:

<details>
<summary>Show Example</summary>
<p>

```buildoutcfg
include: "/path/to/454_tools.view"

view: orders {
    extends: [454_tools] ## Now this view can use the date filters in 454_tools
    sql_table_name: dataset.orders ;;
    
    ## overrides the partition_field_param parameter in 454_tools.view
    ## with the field specific for this view
    parameter: partition_field_param {
      type: unquoted
      hidden: yes
      allowed_value: {
        label: "order_date"
        value: "order_date"
      }
    }
    
    dimension_group: order_date {
        # order_date is a timestamp
        # dataset.orders table is partitioned on date(order_date)
        type: time
        sql: ${TABLE}.order_date 
    }
    
    dimension: order_id {
        type: number
        sql: ${TABLE}.order_id
    }
    
    dimension: sales {
        type: number
        sql: ${TABLE}.sales
    }
    
    measure: total_sales {
        type: sum
        sql: ${sales}
    }
    
}

explore:  orders {
    from: orders
    
    # partition field must be defined to use 454_tools
    always_filter: {
      filters: [partition_field_param: ""]
    }

    # need these to make sure partition fields are always being filtered
    sql_always_where:
      ${454_FILTER} ;;
}
```
</p>
</details>

<details>
<summary><h6>454_FILTER</h6></summary>
<p>

In example above, the `orders` Explore always filters `${454_FILTER}` which is a filter defined in 
`454_tools` view. This is the final filter applied where the `partition_field_param` (i.e., partition date field)
is filtered in a `WHERE` clause. 

Using Looker's Liquid syntax, we apply different filters based on certain conditions regarding the parameters
used. Furthermore, we assume the `partition_field_param` is a timestamp and it is converted to a `DATE` when filtered.

The `454_FILTER` is essentially the following:
```buildoutcfg
date( partition field ) between start_date and end_date
```

and if a year-over-year analysis is desired:
```buildoutcfg
date( partition field ) between start_interval and end_interval
or 
date( partition field) between previous_year_start_interval and previous_year_end_interval
```

</p>
</details>

<details>
<summary><h6>Start Interval</h6></summary>
<p>

</p>
</details>

<details>
<summary><h6>End Interval</h6></summary>
<p>

</p>
</details>

<details>
<summary><h6>N Start/End</h6></summary>
<p>

</p>
</details>
    
</p>
</details>


<details>
<summary><h4>Fixed Period Filters</h4></summary>
<p>

These filters can be used for when users want to view a very specific time interval within 454 calendar. In this
instance, the user has to define the year and the week, month, or quarter.
    
</p>
</details>


<details>
<summary><h4>Repository Variables</h4></summary>
<p>

The `repository_variable` and `py_repository_variable` views contains LookML code to custom variables 
-- similar to Looker filter expressions -- to represent custom filter definitions based on current date
(`repository_variable`) and previous year (`py_repository_variable`). 

Key differences compared to Fixed Period Filters:

- Users can choose from a menu of human-readable options to apply date filters
- It is dynamic/rolling because it is always based on the current date
  - Useful for creating automated reports

<details>
<summary><h6>What Year Is It In 454 calendar?</h6></summary> 

This question alone is difficult to answer when you're at the beginning/end of a calendar year. As mentioned above,
a year can start in December or January in a 454 calendar.

</details>

<details>
<summary><h6>What Week Is It In 454 calendar?</h6></summary> 

</details>

<details>
<summary><h6>What Month Is It In 454 calendar?</h6></summary> 

</details>

<details>
<summary><h6>What Quarter Is It In 454 calendar?</h6></summary> 

</details>

<details>
<summary><h6>What Is The Equivalent of This Week/Month/Quarter Last Year In 454 calendar?</h6></summary> 

</details>

</p>
</details>

<details>
<summary><h4>Parameters</h4></summary>
<p>

The `454_tools_parameters` view contains all the parameters required for users to filter dates. Separating
them out allows for users to extend just the parameters in an NDT and then bind the filters.

An example is shown below where we have a view called `orders` and an Explore based off that view also called
`orders`. The `orders` view/Explore is built on top of a fact table in BigQuery that contains orderline level 
of granularity and is partitioned on `order_date` field. A summary of `orders` aggregated at `order_date` level is created with an NDT called 
`order_summary`. Users can now use `order_summary` Explore to join other views on a much smaller scale.   

```buildoutcfg

include: "/path/to/454_tools.view"

view: orders {
    extends: [454_tools]
    sql_table_name: dataset.orders ;;
    
    ## overrides the partition_field_param parameter in 454_tools.view
    ## with the field specific for this view
    parameter: partition_field_param {
      type: unquoted
      hidden: yes
      allowed_value: {
        label: "order_date"
        value: "order_date"
      }
    }
    
    dimension_group: order_date {
        # order_date is a timestamp
        # dataset.orders table is partitioned on date(order_date)
        type: time
        sql: ${TABLE}.order_date 
    }
    
    dimension: order_id {
        type: number
        sql: ${TABLE}.order_id
    }
    
    dimension: sales {
        type: number
        sql: ${TABLE}.sales
    }
    
    measure: total_sales {
        type: sum
        sql: ${sales}
    }
    
}

explore: orders {
    from: orders
    # A fact table that contains orderline level information
}

view: order_summary {
    # NDT that aggregates orders by day
    extends: [454_parameters]
    derived_table: {
      explore_source: orders {
        timezone: "query_timezone"
        column: order_date_date {} 
        column: order_id {}
        column: total_sales {}
        filters: {
          # 454_tools.view requires a partition_field_param to be defined
          field: orders.partition_field_param
          value: "order_date"
        }
        ### Following bind filters are for parameters in 454_parameters
        bind_filters: {
        to_field: orders.FY_start
        from_field: order_summary.FY_start
        }
        bind_filters: {
          to_field: orders.N_start
          from_field: order_summary.N_start
        }
        bind_filters: {
          to_field: orders.454interval_start
          from_field: order_summary.454interval_start
        }
        bind_filters: {
          to_field: orders.FY_end
          from_field: order_summary.FY_end
        }
        bind_filters: {
          to_field: orders.N_end
          from_field: order_summary.N_end
        }
        bind_filters: {
          to_field: orders.454interval_end
          from_field: order_summary.454interval_end
        }
        bind_filters: {
          to_field: orders.compare_yoy
          from_field: order_summary.compare_yoy
        }
        bind_filters: {
          to_field: nested_sb_customer_transactions_daily__details.po_category
          from_field: order_summary.po_category
        }
      }
    }
    
    dimension: order_date {
        sql: ${TABLE}.order_date_date
    }
    
    dimension: order_id {}
    
    dimension: total_sales_per_order {
        sql: ${TABLE}.total_sales
    }
    
    measure: total_sales {
        type:sum
        sql: ${total_sales_per_order}
    }   
    
}

explore: order_summary {
    from: order_summary
    join: some_other_view {
        sql_on: ${order_sumamry.order_id} = ${some_other_view.order_id}
        relationship: one_to_one
    }
 }


```

</p>
</details>