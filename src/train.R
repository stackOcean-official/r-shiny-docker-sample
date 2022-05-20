
# Load package
library(readr)


# Load data
trend_data <- read_csv("data/beach_chairs.csv")

# Build model
beach_chairs = trend_data$beach_chairs
max_temp = trend_data$max_temp
sun_mins = trend_data$sun_mins
wspd = trend_data$wspd
lin_mod = lm(beach_chairs ~ max_temp + sun_mins + wspd , data = trend_data)
summary(lin_mod)
round(predict(lin_mod, data.frame(max_temp = 23, sun_mins = 200, wspd = 12)))
saveRDS(lin_mod, "model/lin_mod.rds")