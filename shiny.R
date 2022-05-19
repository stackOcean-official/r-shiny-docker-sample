# Load packages
library(shiny)
library(shinythemes)
library(dplyr)
library(readr)

# Load data
trend_data <- read_csv("data/trend_data.csv")
trend_description <- read_csv("data/trend_description.csv")

# Define UI
ui <- fluidPage(theme = shinytheme("lumen"),
                titlePanel("Strandkorb Prediciton"),
                sidebarLayout(
                  sidebarPanel(
                    
                    # Select whether to overlay smooth trend line
                    checkboxInput(inputId = "weekend", label = strong("Is weekend?"), value = FALSE),
                    
                    # Display only if the smoother is checked
                    conditionalPanel(sliderInput(inputId = "sun", label = "Sunminutes:",
                                                 min = 0, max = 1440, value = 50, step = 10,
                                                 animate = animationOptions(interval = 100))
                    )
                    conditionalPanel(sliderInput(inputId = "wind", label = "Windspeed:",
                                                 min = 0, max = 63, value = 8, step = 1,
                                                 animate = animationOptions(interval = 100))
                    )
                    conditionalPanel(sliderInput(inputId = "temp", label = "Maximun Temperature:",
                                                 min = 0, max = 30, value = 20, step = 1,
                                                 animate = animationOptions(interval = 100))
                    )
                  ),
                  
                  # Output: Description, lineplot, and reference
                  mainPanel(
                    textOutput(outputId = "predict"),
                    tags$a(href = "https://stackocean.com", "provided by stackOcean", target = "_blank")
                  )
                )
)

# Define server function
server <- function(input, output) {
  beach_chairs = data$beach_chairs
  max_temp = data$max_temp
  sun_mins = data$sun_mins
  wspd = data$wspd
  lin_mod = lm(beach_chairs ~ max_temp + sun_mins + wspd , data = data)
  summary(lin_mod)
  round(predict(lin_mod, data.frame(max_temp = 23, sun_mins = 200, wspd = 12)))
  # Subset data
  selected_trends <- reactive({
    # TODO
    req(input$date)
    trend_data %>%
      filter(
        type == input$type,
        date > as.POSIXct(input$date[1]) & date < as.POSIXct(input$date[2]
        ))
  })
  
 
  
  # Pull in prediction of trend
  output$predict <- renderText({
    trend_text <- filter(trend_description, type == input$type) %>% pull(text)
    paste(trend_text, "The index is set to 1.0 on January 1, 2004 and is calculated only for US search traffic.")
  })
}

# Create Shiny object
shinyApp(ui = ui, server = server)