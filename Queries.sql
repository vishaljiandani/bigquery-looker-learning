/* All results below are only for March 2018 unless mentioned otherwise */
/* The start_date of a trip is used for this filtering, even for trips that start in one month but end in the following month */ 

/* Q1. What are the stations with the most start trips (by short name)? */
/* Since no number is specified, I'll consider only the top 5 */
select station.short_name
      ,count(trip.trip_id) as number_of_start_trips
      from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips trip
      join bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info station
      on trip.start_station_name = station.name -- joining on name since IDs don't match
where extract(year from trip.start_date) = 2018 and extract(month from trip.start_date) = 3
group by station.short_name
order by number_of_start_trips desc
limit 5;

/* Q2. What are the stations with the most destination trips (by short name name)? */
/* Since no number is specified, I'll consider only the top 5 */
select station.short_name
      ,count(trip.trip_id) as number_of_destination_trips
      from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips trip
      join bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info station
      on trip.end_station_name = station.name -- joining on name since IDs don't match
where extract(year from trip.start_date) = 2018 and extract(month from trip.start_date) = 3
group by station.short_name
order by number_of_destination_trips desc
limit 5;

/* Q3. What is the average age of the riders? */
/* Birth year will be used to calculate this since that is the only data available */
select round(sum(extract(year from current_date()) - member_birth_year)/sum(case when member_birth_year is not null then 1 else 0 end), 2) as average_rider_age
from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
where extract(year from start_date) = 2018 and extract(month from start_date) = 3;

/* Q4. What is the most common journey (i.e. has the most trips between start and destination stations) */
select start_station_name
      ,end_station_name
      ,count(*) as number_of_trips
from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
where extract(year from start_date) = 2018 and extract(month from start_date) = 3
group by start_station_name
      ,end_station_name
order by number_of_trips desc
limit 1;

/* Q5. What are the busiest hours of the day? */
/* I'll be using start time of each ride to calculate this */
select extract(hour from start_date) as hour
      ,count(*) as total_rides
from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
where extract(year from start_date) = 2018 and extract(month from start_date) = 3
group by hour
order by total_rides desc
limit 2;

/* Q6. What are the two regions with more trips amongst them (in both directions)? */
select route , count(*) as trip_count from
(
   select
   case when start_station_name > end_station_name then concat(start_station_name, ' - ', end_station_name)
   else concat(end_station_name, ' - ', start_station_name) 
   end as route
   from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
   where extract(year from start_date) = 2018 and extract(month from start_date) = 3
 ) a
 group by route
 order by trip_count desc
 limit 1;

/* Q7. What is the trip with the longest average ride time? */
select start_station_name
      ,end_station_name
      ,round(avg(duration_sec)/3600, 2) as average_ride_time_hours
from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
where extract(year from start_date) = 2018 and extract(month from start_date) = 3
group by start_station_name
      ,end_station_name
order by average_ride_time_hours desc
limit 1;

/* Q8. What is the longest trip ever? */
/* Assuming "ever" to mean all time, hence not filtering for March 2018 */
select start_station_name
      ,end_station_name
      ,round(max(duration_sec)/3600, 2) as longest_trip_hours
from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
group by start_station_name
      ,end_station_name
order by longest_trip_hours desc
limit 1;

/* Q9. How many bikes had their first trip in that month? And their last? */
/* first trip */
select count(*) as first_trip_count from
(
      select bike_number
      from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
      where start_date between '2018-03-01' and '2018-03-31'

      except distinct

      select bike_number
      from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
      where start_date < '2018-03-01'
);

/* Last trip */
select count(*) as last_trip_count from
(
      select bike_number
      from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
      where start_date between '2018-03-01' and '2018-03-31'

      except distinct

      select bike_number
      from bigquery-public-data.san_francisco_bikeshare.bikeshare_trips
      where start_date > '2018-03-31'
);