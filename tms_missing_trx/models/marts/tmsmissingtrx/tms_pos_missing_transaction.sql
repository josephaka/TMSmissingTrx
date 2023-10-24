{{
    config(
        materialized = 'table',
        unique_key='id',
    )
}}

with tms_pos_transaction as (

    select * from {{ ref('stg_tms_pos_transaction') }}
),

prepare_tms_pos_missing_transaction as (

    select * from {{ ref('prepare_tms_pos_missing_transaction') }}
),


final as (

select i_a.*
from prepare_tms_pos_missing_transaction i_a
where not exists (select 1 from tms_pos_transaction ir where i_a.terminal_id  = ir.terminal_id
						and i_a.ret_ref_no  = ir.ret_ref_no 
						and i_a.amt = cast(ir.amt as numeric(14, 2))/100 
				)
) 

select * from final 

