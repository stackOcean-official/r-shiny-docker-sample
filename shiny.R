# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
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
saveRDS(lin_mod, "lin_mod.rds")
duplicated_mod = readRDS("lin_mod.rds")

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Beach chair prediciton"),
                sidebarLayout(
                  sidebarPanel(
                    
                    # Select whether it's weekend - does nothing at the moment because weekday not part of lin_mod
                    checkboxInput(inputId = "weekend", label = strong("Is it weekend?"), value = FALSE),
                    
                    # slider to adjust sun minutes, windsped and maximum temperature
                    sliderInput(inputId = "sun", label = "Sun minutes:", min = 0, max = 1440, value = 50, step = 10, animate = animationOptions(interval = 100)),
                    sliderInput(inputId = "wind", label = "Windspeed:", min = 0, max = 63, value = 8, step = 1, animate = animationOptions(interval = 100)),
                    sliderInput(inputId = "temp", label = "Maximun Temperature:",min = 0, max = 30, value = 20, step = 1, animate = animationOptions(interval = 100))
                  ),
                  
                  # Output: Prediction how many sun chairs will be needed.
                  mainPanel(
                    textOutput(outputId = "predict"),
                    tags$a(href = "https://stackocean.com", "provided by stackOcean", target = "_blank")
                  )
              )
)

# Define server function
server <- function(input, output) {

  # Pull in prediction depending on input factors
  output$predict <- renderText({
    trend_text <- round(predict(duplicated_mod, data.frame(max_temp = input$temp, sun_mins = input$sun, wspd = input$wind)))
    paste(trend_text, "beach chairs need to be set up today.")
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)
