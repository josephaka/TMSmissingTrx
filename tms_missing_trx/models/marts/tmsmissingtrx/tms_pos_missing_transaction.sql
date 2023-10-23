{# File name is the Table name #}

{{
    config(
        materialized = 'table',
        unique_key='id',
    )
}}

with nibssdata as (

    select * from {{ ref('stg_nibss_data') }}
),

tms_pos_transaction as (

    select * from {{ ref('stg_tms_pos_transaction') }}
),

prepare_missing_trx as (

    select * from {{ ref('prepare_missing_trx') }}
),

prepare_missing_trx_staged as (

    select * from public_arca.prepare_missing_trx_staged
),

missing_trx as (

select i_a.*
from nibssdata i_a
where not exists (select 1 from tms_pos_transaction ir where i_a."TerminalID"  = ir.terminal_id
                        and i_a."RetrievalReferenceNo_t"  = ir.ret_ref_no 
                        and DATE(i_a."date") = DATE(ir.date)
                        and i_a."Amount" = cast(ir.amt as numeric(14, 2))/100 
                ) 

),

final as (

select * from prepare_missing_trx_staged
union 
select * from missing_trx

)

select 
'NULL' id,
'NULL' account_type,
'NULL' acq_inst_id,
"Amount" amt,
'NULL'  auth_num,
'NULL' authentication_method,
'NULL' balance,
'NULL' card_holder_name,
'NULL' card_sequence_no,
'NULL' card_type_name,
'NULL' completed,
'NULL' created_on,
'NULL' currency_code,
'NULL' customer_num,
'NULL' exp_date,
'NULL' fwd_inst_id,
'NULL' icc_data,
'NULL'  latency,
'NULL' local_date,
'NULL'  local_time,
"PAN" masked_pan,
'NULL' merch_type,
'NULL' merchant_address,
merchant_id merchant_ext_id,
'NULL' merchant_id,
"Merchant" merchant_name,
'NULL' msg_reason_code,
'NULL' msg_type, 
'NULL' notified,
'NULL' pin_data,
'NULL' pos_condition_code,
'NULL' pos_data_code,
'NULL' pos_entry_mode,
'NULL' pos_pin_capture_code,
'NULL' proc_code,
"ResponseCode" response_code,
"RetrievalReferenceNo_t" ret_ref_no,
'NULL'  reversed,
"Amount" sales_amt,
'NULL' sales_id,
'NULL' service_restriction_code,
"System Trace Number" stan,
"ResponseCode" status_code,
'NULL' surcharge,
"TerminalID" terminal_id,
'NULL' track2,
'NULL' transaction_type,
"date" transmission_date_time,
'NULL' transmission_log_date_time,
'NULL' user_name
from final
