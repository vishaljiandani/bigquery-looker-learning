create table mydataset.trips as (
select ST_GeogFromText(start_station_loc) as start_station_loc
      ,start_station_name
      ,total_rides
from (
  select ST_AsText(start_station_geom) as start_station_loc -- geo datatype has to be converted to string in order to group
      ,start_station_name
      ,count(*) as total_rides
  from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
  group by 1, 2
)
);