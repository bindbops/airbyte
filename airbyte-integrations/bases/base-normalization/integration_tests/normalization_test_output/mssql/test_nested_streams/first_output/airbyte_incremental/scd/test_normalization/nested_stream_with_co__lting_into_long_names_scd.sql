
      
   
  USE [test_normalization];
  if object_id ('test_normalization."nested_stream_with_co__lting_into_long_names_scd_temp_view"','V') is not null
      begin
      drop view test_normalization."nested_stream_with_co__lting_into_long_names_scd_temp_view"
      end


   
   
  USE [test_normalization];
  if object_id ('test_normalization."nested_stream_with_co__lting_into_long_names_scd"','U') is not null
      begin
      drop table test_normalization."nested_stream_with_co__lting_into_long_names_scd"
      end


   USE [test_normalization];
   EXEC('create view test_normalization."nested_stream_with_co__lting_into_long_names_scd_temp_view" as
    
with

input_data as (
    select *
    from "test_normalization"._airbyte_test_normalization."nested_stream_with_co__lting_into_long_names_ab3"
    -- nested_stream_with_co__lting_into_long_names from "test_normalization".test_normalization._airbyte_raw_nested_stream_with_complex_columns_resulting_into_long_names
),

scd_data as (
    -- SQL model to build a Type 2 Slowly Changing Dimension (SCD) table for each record identified by their primary key
    select
      convert(varchar(32), HashBytes(''md5'',  coalesce(cast(
    
    

    concat(concat(coalesce(cast(id as 
    VARCHAR(max)), ''''),''''), '''') as 
    VARCHAR(max)), '''')), 2) as _airbyte_unique_key,
        id,
        "date",
        "partition",
      "date" as _airbyte_start_at,
      lag("date") over (
        partition by id
        order by
            "date" desc,
            "date" desc,
            _airbyte_emitted_at desc
      ) as _airbyte_end_at,
      case when row_number() over (
        partition by id
        order by
            "date" desc,
            "date" desc,
            _airbyte_emitted_at desc
      ) = 1 then 1 else 0 end as _airbyte_active_row,
      _airbyte_ab_id,
      _airbyte_emitted_at,
      _airbyte_nested_strea__nto_long_names_hashid
    from input_data
),
dedup_data as (
    select
        -- we need to ensure de-duplicated rows for merge/update queries
        -- additionally, we generate a unique key for the scd table
        row_number() over (
            partition by _airbyte_unique_key, _airbyte_start_at, _airbyte_emitted_at
            order by _airbyte_ab_id
        ) as _airbyte_row_num,
        convert(varchar(32), HashBytes(''md5'',  coalesce(cast(
    
    

    concat(concat(coalesce(cast(_airbyte_unique_key as 
    VARCHAR(max)), ''''), ''-'', coalesce(cast(_airbyte_start_at as 
    VARCHAR(max)), ''''), ''-'', coalesce(cast(_airbyte_emitted_at as 
    VARCHAR(max)), ''''),''''), '''') as 
    VARCHAR(max)), '''')), 2) as _airbyte_unique_key_scd,
        scd_data.*
    from scd_data
)
select
    _airbyte_unique_key,
    _airbyte_unique_key_scd,
        id,
        "date",
        "partition",
    _airbyte_start_at,
    _airbyte_end_at,
    _airbyte_active_row,
    _airbyte_ab_id,
    _airbyte_emitted_at,
    SYSDATETIME() as _airbyte_normalized_at,
    _airbyte_nested_strea__nto_long_names_hashid
from dedup_data where _airbyte_row_num = 1
    ');

   SELECT * INTO "test_normalization".test_normalization."nested_stream_with_co__lting_into_long_names_scd" FROM
    "test_normalization".test_normalization."nested_stream_with_co__lting_into_long_names_scd_temp_view"

   
   
  USE [test_normalization];
  if object_id ('test_normalization."nested_stream_with_co__lting_into_long_names_scd_temp_view"','V') is not null
      begin
      drop view test_normalization."nested_stream_with_co__lting_into_long_names_scd_temp_view"
      end

    
   use [test_normalization];
  if EXISTS (
        SELECT * FROM
        sys.indexes WHERE name = 'test_normalization_nested_stream_with_co__lting_into_long_names_scd_cci'
        AND object_id=object_id('test_normalization_nested_stream_with_co__lting_into_long_names_scd')
    )
  DROP index test_normalization.nested_stream_with_co__lting_into_long_names_scd.test_normalization_nested_stream_with_co__lting_into_long_names_scd_cci
  CREATE CLUSTERED COLUMNSTORE INDEX test_normalization_nested_stream_with_co__lting_into_long_names_scd_cci
    ON test_normalization.nested_stream_with_co__lting_into_long_names_scd

   


  