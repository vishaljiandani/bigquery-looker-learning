Dataset Metadata

1. bikeshare_regions: List of regions where the bikeshare program has been implemented
2. bikeshare_station_info: Contains high level information about each bike station
3. bikeshare_station_status: Operating status of each bike station as of the 'last_reported' timestamp
4. bikeshare_trips: Contains information about each bike trip

Data Quality Issues

1. 'start_station_id' in bikeshare_trips can't be used to join. It's not a foreign key from the bikeshare_station_info
table, like I first thought.
2. A lot of nulls for short_name
3. Nulls in member_birth_year in bikeshare_trips
4. People who are 123 years old are riding bikes? Just seems like certain riders have put in a wrong DOB.
5. The longest trip ever is 4797.33 hours. That's almost 200 days. Maybe the rider just never stopped that trip.
7. start_station_geom has quite a few null values. Since this columns is being used to visualize trips
in Looker, results may not be completely accurate.

My Recommendations

1. There's certain records where "start_station_geom" is missing even though the "start_station_name" is present. This is just a case of missing data which can be replaced easily. Results will be more accurate after this.
2. Users can't always be counted on to put in their correct DOB all the time. The only way to get accurate data on this is to prompt users to upload some form of ID.
3. Implement a system to make sure rides are auto-stopped after an appropriate amount of time.
4. Most bike stations seem to be concentrated in the downtown areas. Maybe open some more further away and test how good the demand is.
