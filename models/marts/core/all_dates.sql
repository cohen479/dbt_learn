{{ dbt_utils.date_spine(
    datepart="day",
    start_date="to_date('01/01/2020', 'mm/dd/yyyy')",
    end_date="to_date('12/31/2020', 'mm/dd/yyyy')"
   )
}}