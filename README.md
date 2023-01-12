# Google-Data-Analytics-Cyclistic-Case-Study
Author: Harsh Haldankar

Date: jan 1,2023

#### [Tableau Dashboard](https://public.tableau.com/views/cyclisticdataanalysis/Dashboard1?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link)
#### [Tableau Presentation](https://public.tableau.com/views/cyclisticdataanalysis/Story1?:language=en-US&publish=yes&:display_count=n&:origin=viz_share_link)
_this case study follows the six steps of data analysis process:_

### [ASK](#1.ASK)
### [PREPARE](#2.PREPARE)
### [PROCESS](#3.PROCESS)
### [ANALYSIS](#4.ANALYSIS)
### [SHARE](#5. SHARE)
### [ACT]

## Scenario
A bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore,
your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members

# 1.ASK
**BUSINESS TASK: Analyze Divvy's riding Data to make marketing stratergies to influence casual riders to become members.**

Primary stakeholders: The director of marketing Lily Moreno and Cyclistic executive team.

Secondary stakeholders: Cyclistic marketing analytics team.

# 2.PREPARE
Data Source: 12 Month (Jan 2021 to Jan 2022) of Cyclistic trip Data from Motivate International Inc: [data source link](https://divvy-tripdata.s3.amazonaws.com/index.html) with [license](https://www.divvybikes.com/data-license-agreement).

The dataset has 12 CSV, 13 columns and 5915257 obs. The data also follow a ROCCC approach:

- Reliability: the data includes complete and accurate ride data from Divvy. Divvy is program of the Chicago Department of Transportation (CDOT), which owns the city’s bikes, stations and vehicles
- Original: the data is from Motivate International Inc, which operates the City of Chicago’s Divvy bicycle sharing service.
- Comprehensive: The data incudes type of bikes, start and end station name, start and end time, station ID, station longtitude and latitude, membership types.
- Current: data is up to date to January 2023
- Cited: the data is cited and under current [license](https://www.divvybikes.com/data-license-agreement) agreement.

The dataset has limitations:

- NA values: after checking `sum(is.na(bike_data))`, we see the dataset has 12004 NA values, such as in starting_station_id, end_station_id. Further investigation we noticed the NA values are mostly under rideable type: electric bike. Future investigations may be needed by the station names are not entered for electric bike.

- Personally identifiable information:There is no such a information to show that the rider is unique rider or same rider who ride more than once as casual rider or member.

# 3.PROCESS
cheking and examine the data
```
head(bike_data)
dim(bike_data)
colnames(bike_data)
summary(bike_data)
```

creating ride_length column for duration of ride calculated from start and end time of rides
```
bike_data$ride_length <- difftime(bike_data$ended_at,bike_data$started_at)
```

add column "day_of_week,", and calculate the day of the week that each ride started.
```
bike_data <- bike_data%>% mutate(day_of_week = weekdays(as.Date(bike_data$started_at)))
```

remove data error
```
bike_data <- bike_data[bike_data$ride_length>0,] 
sum(bike_data$ride_length > 86400)
```
now data is ready to analyze

# 4.ANALYSIS
 
checking max min ride length
```
max(bike_data$ride_length) #max ride length
max(bike_data$ride_length) #min ride length
```

aggregate the data

```
aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = mean)
aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = median)
aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = max)
aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = min)
```

Average ride time by each day for members vs casual users
```
aggregate(bike_data$ride_length ~ bike_data$member_casual + bike_data$day_of_week, FUN = mean)
```

analyze data by type and weekdays
```
bike_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, weekday) %>%  
  summarise(number_of_rides = n()							
            ,average_duration = mean(ride_length)) %>% 		
  arrange(member_casual, weekday)
```

```{r}
bike_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, weekday) %>%  
  summarise(number_of_rides = n()							
            ,average_duration = mean(ride_length)) %>% 		
  arrange(member_casual, weekday)
```

```{r}
bike_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, weekday) %>%  
  summarise(number_of_rides = n()							
            ,average_duration = mean(ride_length)) %>% 		
  arrange(member_casual, weekday)
```

visualize the number of ride by rider type on weekday

![image](https://user-images.githubusercontent.com/121929260/212097047-c2626270-25bb-4c8b-96a3-7cac74e785c3.png)


![image](https://user-images.githubusercontent.com/121929260/212097919-5f00663a-b257-413d-bcd0-caac1549ca1f.png)

for complete R code view the emd file [R code file :-](https://github.com/harshhaldankar/Google-Data-Analytics-Cyclistic-Case-Study/blob/main/cyclistic%20case%20study%20.Rmd)

# 5.SHARE
