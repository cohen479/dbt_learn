with payments as (
    select
        ID as payment_id,
        ORDERID as order_id,
        PAYMENTMETHOD as payment_method,
        STATUS,
        {{ cents_to_dollars('amount') }} as AMOUNT,
        CREATED,
        _BATCHED_AT
    from {{ source('stripe', 'payment') }}
)

select * from payments