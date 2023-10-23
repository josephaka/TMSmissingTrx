{# File name is the Table name #}

{{
  config(   
    materialized = 'table',
    pre_hook = [
        "DROP TABLE IF EXISTS public_arca.prepare_missing_trx_staged  ; CREATE TABLE public_arca.prepare_missing_trx_staged AS TABLE public_arca.prepare_missing_trx"    
       ]
  )
}}

with nibssdata as (

    select * from {{ ref('stg_nibss_data') }}
),

tms_pos_transaction as (

    select * from {{ ref('stg_tms_pos_transaction') }}
),



final as (

select i_a.*
from nibssdata i_a
where not exists (select 1 from tms_pos_transaction ir where i_a."TerminalID"  = ir.terminal_id
						and ltrim(rtrim(i_a."RetrievalReferenceNo"))  = ir.ret_ref_no 
						and DATE(i_a."date") = DATE(ir.date)
						and i_a."Amount" = cast(ir.amt as numeric(14, 2))/100 
				) 


  {% if is_incremental() %}
    -- this filter will only be applied on an incremental run

      and  i_a."RetrievalReferenceNo" not in (select "RetrievalReferenceNo" from {{ this }})
      and i_a."TerminalID" not in (select "TerminalID" from {{ this }})


  {% endif %} 


)
select * from final 