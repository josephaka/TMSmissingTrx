with source as (

    select * from {{ source('raw_tms_pos_transaction', 'tms_pos_transaction') }}

),

renamed as (

SELECT id, account_type, acq_inst_id, amt, auth_num, authentication_method, balance, card_holder_name, card_sequence_no, card_type_name, 
completed, created_on, currency_code, customer_num, exp_date, fwd_inst_id, icc_data, latency, local_date, local_time, masked_pan, 
merch_type, merchant_address, merchant_ext_id, merchant_id, merchant_name, msg_reason_code, msg_type, notified, pin_data, pos_condition_code, 
pos_data_code, pos_entry_mode, pos_pin_capture_code, proc_code, response_code, ret_ref_no, reversed, sales_amt, sales_id, service_restriction_code, 
stan, status_code, surcharge, terminal_id, track2, transaction_type, transmission_date_time date, transmission_log_date_time, user_name
FROM 

     source

),

final as (
select * from renamed

    where date >= date_trunc('day', CURRENT_TIMESTAMP) - interval '{{ env_var("START_DAY") }} day'
    {{ env_var("DAILY_SETTLEMENT_END_DAY_QUERY") }} 

)
select * from final 



