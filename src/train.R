# TODO set working directory

# Load package
library(readr)

# Load data
trend_data <- read_csv("../data/beach_chairs.csv")

# Add dummy for weekend
trend_data$weekend <- ifelse(weekdays(as.Date(trend_data$Date)) == "Samstag" | weekdays(as.Date(trend_data$Date)) == "Sonntag" | weekdays(as.Date(trend_data$Date)) == "saturday" | weekdays(as.Date(trend_data$Date)) == "sunday", TRUE, FALSE)

# Build model
beach_chairs = trend_data$beach_chairs
max_temp = trend_data$max_temp
sun_mins = trend_data$sun_mins
wspd = trend_data$wspd
weekend = trend_data$weekend
lin_mod = lm(beach_chairs ~ max_temp + sun_mins + wspd + weekend, data = trend_data)
summary(lin_mod)
saveRDS(lin_mod, "../model/lin_mod.rds")
