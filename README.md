# Google-Data-Analytics-Cyclistic-Case-Study
Author: Harsh Haldankar

Date: jan 1,2023

#

_this case study follows the six steps of data analysis process:_

### [ASK](#1.ASK)
### [PREPARE](#2.PREPARE)
### [PROCESS]
### [ANALYSIS]
### [SHARE]
### [ACT]

## Scenario
A bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore,
your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members

# 1.ASK
**BUSINESS TASK: Analyze Divvy's riding Data to make marketing stratergies to influence casual riders to become members.**

Primary stakeholders: The director of marketing Lily Moreno and Cyclistic executive team.

Secondary stakeholders: Cyclistic marketing analytics team.

# 2.PREPARE
Data Source: 12 Month (Jan 2022 to Jan 2023) of Cyclistic trip Data from Motivate International Inc: [data source link](https://divvy-tripdata.s3.amazonaws.com/index.html) with [license](https://www.divvybikes.com/data-license-agreement).

The dataset has 12 CSV, 13 columns and 351310 obs. The data also follow a ROCCC approach:

- Reliability: the data includes complete and accurate ride data from Divvy. Divvy is program of the Chicago Department of Transportation (CDOT), which owns the city’s bikes, stations and vehicles
- Original: the data is from Motivate International Inc, which operates the City of Chicago’s Divvy bicycle sharing service.
- Comprehensive: The data incudes type of bikes, start and end station name, start and end time, station ID, station longtitude and latitude, membership types.
- Current: data is up to date to January 2023
- Cited: the data is cited and under current [license](https://www.divvybikes.com/data-license-agreement) agreement.

The dataset has limitations:

- NA values: after checking `sum(is.na(bike_data))`, we see the dataset has 460 NA values, such as in starting_station_id, end_station_id. Further investigation we noticed the NA values are mostly under rideable type: electric bike. Future investigations may be needed by the station names are not entered for electric bike.
