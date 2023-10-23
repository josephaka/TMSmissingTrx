with source as (

    select * from {{ source('raw_nibss_data', 'nibsstrx') }}

),

renamed as (

SELECT id, "Merchant", "TerminalID", "IssuingBank", "AcquiringBank", "BIN", "PAN", "Date" date, merchant_id, "Amount", "ResponseCode", 
"System Trace Number", "RetrievalReferenceNo", "Acquirer_name", uploaded_at
FROM

     source

), 

final as (

    select * from renamed
    where date >= date_trunc('day', CURRENT_TIMESTAMP) - interval '{{ env_var("START_DAY") }} day'
    {{ env_var("DAILY_SETTLEMENT_END_DAY_QUERY") }}
)

select * from final
