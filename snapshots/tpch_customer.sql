{% snapshot tpch_customer %}

{{
    config(
      target_database='ROLAND_PLAYGROUND_DB',
      target_schema='snapshots',
      unique_key='c_custkey',

      strategy='check',
      check_cols=dbt 
    )
}}

select * from  {{ source('tpch', 'customer') }} 

{% endsnapshot %}