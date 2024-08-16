
SELECT
    concat(
        floor(AVG(time_difference)/24), ' days and ',
        round(mod(cast(AVG(time_difference) as numeric), 24.0)), ' hours'
    ) AS avg_time_difference
from {{ ref('int_avg_delivery_time') }}
