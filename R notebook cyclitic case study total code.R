install.packages('tidyverse')
install.packages("skimr")
library(tidyverse)
library(dplyr)
library(skimr)
library(lubridate)
library(ggplot2)

getwd()#getting path

bike_data <-rbind(                         #combining data rbind
  read.csv("202112-divvy-tripdata.csv"),
  read.csv("202201-divvy-tripdata.csv"),
  read.csv("202202-divvy-tripdata.csv"),
  read.csv("202203-divvy-tripdata.csv"),
  read.csv("202204-divvy-tripdata.csv"),
  read.csv("202205-divvy-tripdata.csv"),
  read.csv("202206-divvy-tripdata.csv"),
  read.csv("202207-divvy-tripdata.csv"),
  read.csv("202208-divvy-tripdata.csv"),
  read.csv("202209-divvy-publictripdata.csv"),
  read.csv("202210-divvy-tripdata.csv"),
  read.csv("202211-divvy-tripdata.csv"),
  read.csv("202212-divvy-tripdata.csv")
  
  head(bike_data)
  dim(bike_data)
  colnames(bike_data)
  summary(bike_data)
  nrow(bike_data)
  
  max(bike_data$started_at)
  sum(is.na(bike_data))#NA values
  
  head(count(bike_data, start_station_name, member_casual,  rideable_type, sort= TRUE))
  
  head(count(bike_data, end_station_name, member_casual,  rideable_type, sort= TRUE))
  
 #drop columns we don't need
   bike_data <- bike_data %>% select(-c(start_lat, start_lng, end_lat, end_lng))
bike_data   

remove_missing(bike_data)
drop_na(bike_data)

sum(is.na(bike_data))

#formatting dates
bike_data$started_at <- lubridate::dmy_hm(bike_data$started_at)
bike_data$ended_at <- lubridate::dmy_hm(bike_data$ended_at)

bike_data$ride_length <- difftime(bike_data$ended_at,bike_data$started_at)
bike_data

str(bike_data)
 
bike_data <- bike_data %>%  mutate(day_of_week = weekdays(as.Date(bike_data$started_at)))
bike_data

#optional but better for further analysis
bike_data$date <- as.Date(bike_data$started_at)  #default format is yyyy-mm-dd
bike_data$month <-  format(as.Date(bike_data$date), "%m")
bike_data$day <- format(as.Date(bike_data$date), "%d")
bike_data$year <- format(as.Date(bike_data$date), "%Y")

bike_data$ride_length <- as.numeric(bike_data$ride_length)
bike_data$ride_length <- as.numeric(bike_data$ride_length/60)
bike_data

bike_data <- bike_data[bike_data$ride_length>0,]

sum(bike_data$ride_length > 1440 )
summary(bike_data)
#analyze
max(bike_data$ride_length)
min(bike_data$ride_length)


aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = mean)
aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = median)
aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = max)
aggregate(bike_data$ride_length ~ bike_data$member_casual, FUN = min)
aggregate(bike_data$ride_length ~ bike_data$member_casual + bike_data$day_of_week, FUN = mean)

bike_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, weekday) %>%  
  summarise(number_of_rides = n()							
            ,average_duration = mean(ride_length)) %>% 		
  arrange(member_casual, weekday)


bike_data %>%
  mutate(weekday = wday(started_at, label=TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(), average_duration=mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x=weekday, y=number_of_rides, fill=member_casual))+
  geom_col(position="dodge")

bike_data %>%
  mutate(weekday = wday(started_at, label=TRUE)) %>%
  group_by(member_casual, weekday) %>%
  summarise(number_of_rides = n(), average_duration=mean(ride_length)) %>%
  arrange(member_casual, weekday) %>%
  ggplot(aes(x=weekday, y=average_duration , fill=member_casual))+
  geom_col(position="dodge")

ggplot(data = bike_data) +
  geom_bar(mapping = aes(x = factor(day_of_week), fill = rideable_type))+
  facet_wrap(~member_casual) +
  labs(title='riding choice during day of the week', x= 'day of the week' )+
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

hour_data <- bike_data
hour_data$start_hour <- as.numeric(format(strptime(bike_data$started_at,"%d-%m-%Y %H:%M"),'%H'))

rm(list = "hour_data")

ggplot(data = hour_data) +
geom_bar(mapping = aes(x=start_hour, fill = member_casual),stat = 'count') +
facet_wrap(~factor(day_of_week)) +
labs(title = "bike usage by hour", x = "starting hours") +
theme(axis.title.x = element_text(angle = 90, vjust = 0.5, hjust = 1))   
   
write_csv(bike_data, "bikedata.csv")   


summary_ride_weekly <- bike_data %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday) 
 write.csv(summary_ride_weekly ,"summary_ride_weekly.csv")
 

  summary_ride_weekly_type <- bike_data %>% 
   mutate(weekday = wday(started_at, label = TRUE)) %>% 
   group_by(member_casual, weekday, rideable_type) %>% 
   summarise(number_of_rides = n()
             ,average_duration = mean(ride_length)) %>% 
   arrange(member_casual, weekday) 
  write.csv(summary_ride_weekly_type ,"summary_ride_weekly_type.csv")

  summary_ride_weekly_type <- bike_data %>% 
    mutate(weekday = wday(started_at, label = TRUE)) %>% 
    group_by(member_casual, weekday, rideable_type) %>% 
    summarise(number_of_rides = n()
              ,average_duration = mean(ride_length)) %>% 
    arrange(member_casual, weekday) 
  write.csv(summary_ride_weekly_type ,"summary_ride_weekly_type.csv")
  
 summary_month <- bike_data %>%
   mutate(month = month(started_at, label = TRUE)) %>%
   group_by(member_casual, month) %>% 
   summarise(number_of_rides = n() ,average_duration = mean(ride_length) %>% 
      arrange(member_casual ,month) 
      write.csv(summary_month, "summary_ride_monthly.csv")
      
      summary_month <- bike_data %>% 
        mutate(month = month(started_at, label = TRUE)) %>%  
        group_by(month,member_casual) %>%  
        summarise(number_of_rides = n()
                  ,average_duration = mean(ride_length)) %>%    
        arrange(month, member_casual) 

 popular_stations <- bike_data %>%
   mutate(station = start_station_name) %>%
   drop_na(start_station_name) %>%
   group_by(start_station_name, member_casual) %>%
   summarise(number_of_rides=n())
  
 write_csv(popular_stations, "popular_stations.csv")

 total_riders <- data.frame(table(bike_data$member_casual))
 total_types <- data.frame(table(bike_data$rideable_type))
 write_csv(total_riders, "total_riders.csv")
 write_csv(total_types, "total_types.csv")
 