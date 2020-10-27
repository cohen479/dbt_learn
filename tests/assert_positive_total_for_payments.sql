-- Refunds have a negative amount, but the total amount on an order from 
-- all payments should be >=0.  Return records where this is not true, in 
-- order to make the test fail

-- would CTE be recommended here just like in models?

select 
    order_id,
    sum(amount) as total_amount
from {{ ref('stg_payments')}}
group by 1
having not(total_amount >= 0)