
select
    to_char(avg(time_difference), 'DD "days," HH24 "hours and" MI "minutes"')
from {{ ref('int_avg_delivery_time') }}