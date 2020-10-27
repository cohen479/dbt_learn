with orders as (
    select * from {{ ref('stg_orders') }}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

-- stg_customers not required unless additional lookups on customer are required
-- originally filtered for 'success', refactored per Exemplar to keep all rows and null out unsuccessful payments

-- makes sense now to refactor below to a CTE orders_payments to get on the right level of detail for simpler "final" CTE

final as (
    select 
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        nvl(sum(case when payments.status = 'success' then payments.amount/100 else 0 end), 0) as amount
    from orders
    left join payments on payments.order_id = orders.order_id
    group by 1, 2, 3, 4
)

select * from final