{{ config(
    indexes = [{'columns':['_airbyte_emitted_at'],'type':'hash'}],
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_test_normalization",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
select
    cast({{ adapter.quote('id') }} as {{ dbt_utils.type_bigint() }}) as {{ adapter.quote('id') }},
    cast(currency as {{ dbt_utils.type_string() }}) as currency,
    cast({{ empty_string_to_null(adapter.quote('date')) }} as {{ type_date() }}) as {{ adapter.quote('date') }},
    cast({{ empty_string_to_null('timestamp_col') }} as {{ type_timestamp_with_timezone() }}) as timestamp_col,
    cast({{ adapter.quote('HKD@spéçiäl & characters') }} as {{ dbt_utils.type_float() }}) as {{ adapter.quote('HKD@spéçiäl & characters') }},
    cast(hkd_special___characters as {{ dbt_utils.type_string() }}) as hkd_special___characters,
    cast(nzd as {{ dbt_utils.type_float() }}) as nzd,
    cast(usd as {{ dbt_utils.type_float() }}) as usd,
    cast({{ adapter.quote('column`_\'with""_quotes') }} as {{ dbt_utils.type_string() }}) as {{ adapter.quote('column`_\'with""_quotes') }},
    _airbyte_ab_id,
    _airbyte_emitted_at,
    {{ current_timestamp() }} as _airbyte_normalized_at
from {{ ref('exchange_rate_ab1') }}
-- exchange_rate
where 1 = 1

