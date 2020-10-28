
with customers as (

    select * from {{ ref('stg_customers') }}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

-- either use fct_orders or go back to source (stg_payments)
-- don't want to do same lookups/calcs multiple times, but also don't want to tie into dependency knot 
-- building dims then facts.  may eventually need an int layer
payments as (
    select * from {{ ref('stg_payments' )}}
),

customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

customer_payments as (
    select
        orders.customer_id,
        sum(payments.amount) as lifetime_value
    from payments
    inner join orders on (orders.order_id = payments.order_id)
    where payments.status = 'success'
    group by orders.customer_id
),

final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_payments.lifetime_value as lifetime_value,
        sum(lifetime_value) over (partition by 1) jaffle_lifetime_revenue

    from customers

    left join customer_orders using (customer_id)
    left join customer_payments using (customer_id)

)

select * from final