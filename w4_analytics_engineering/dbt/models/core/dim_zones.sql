{{config(materialized='table')}}

select 
    locationid,
    borough,
    zone,
    replace(service_zone, 'Boro', 'Green') as service_zone -- added this replace because Green was called Boro in the data
from {{ ref('taxi_zone_lookup') }}