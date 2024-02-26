library(googledrive)
library(httr)
library(dplyr)
library(jsonlite)
library(lubridate)

# we want to write a scraper that will automatically run without input from us

# we will first write a script and use google drive's service account as
# perpetual storage

# then we will containerize the script using Docker, and finally,
# we will use the power of Google Cloud to automate our container

# first we authenticate ourselves

drive_auth(path = "gcp_token/token.json")

# set user agent

ua <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

httr::set_config(httr::user_agent(ua))

# now we write a simple scraper

# we scrape current flight departures from Berlin

current_time <- as.numeric(as.POSIXct(Sys.time(), origin = "1970-01-01"))

url <- sprintf("https://api.flightradar24.com/common/v1/airport.json?code=BER&plugin[]=schedule&plugin-setting[schedule][mode]=departures&plugin-setting[schedule][timestamp]=%.0f&limit=100&page=1", current_time)

# make a request to the url

response <- GET(url)

# extract content from the request

content <- content(response)

# now convert it into text from JSON

data <- fromJSON(content(response, as = "text"))

df <- data$result$response$airport$pluginData$schedule$departures$data

flights_df <- lapply(1:nrow(df), function(x){

  model <- df[x,] %>%
    .$aircraft %>%
    .$model

  airline <- df[x,] %>%
    .$airline %>%
    .$name

  status <- df[x,] %>%
    .$status %>%
    select(`estimated departure` = text)

  scheduled <- df[x,] %>%
    .$time %>%
    .$scheduled

  destination <- df[x,] %>%
    .$airport %>%
    .$destination %>%
    .$name

  cbind(model, airline, status, scheduled, destination) %>%
    mutate(across(c(departure, arrival), function(x) as.POSIXct(x, origin = "1970-01-01")))

}) %>%
  bind_rows()

# now we write to csv

flights_df %>%
  write.csv("output/flights_berlin.csv", row.names = FALSE)

# now we upload to our drive account

drive_upload("output/flights_berlin.csv", name = "flights_berlin",
             overwrite = TRUE)


