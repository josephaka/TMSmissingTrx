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
                        and ltrim(rtrim(i_a."RetrievalReferenceNo"))  = ir.ret_ref_no 
                        and DATE(i_a."date") = DATE(ir.date)
                        and i_a."Amount" = cast(ir.amt as numeric(14, 2))/100 
                ) 

),

final as (

select * from prepare_missing_trx_staged
union 
select * from missing_trx

)

select * from final
