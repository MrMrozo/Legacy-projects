#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
library(plotly)

imiona <- read_csv("imiona.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    # Application title
    titlePanel("LO OL"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
          textAreaInput( 
            inputId = "text", 
            label = "Podaj imiona buddy", 
            value = "Jan"),
          sliderInput(
            inputId = "lata",
            label = "LaTA",
            min = min(imiona$rok),
            max = max(imiona$rok),
            value = c(2005, 2015))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    wybrane_imiona <- reactive(input$text %>% 
      str_split_1(",") %>%
      str_trim())
  
    p <- output$distPlot <- renderPlotly({
        # generate bins based on input$bins from ui.R
        imiona %>% 
          filter(imie %in% wybrane_imiona(), between(rok, input$lata[1], input$lata[2])) %>% 
          group_by(imie, rok) %>% 
          summarise(ile_razy = sum(liczba)) %>%  
          ggplot(aes(x = rok, y = ile_razy, color = imie)) +
          geom_line() +
          geom_point(size = 3) +
          scale_x_continuous(breaks = 2004:2016) +
          scale_color_brewer(palette = "Set1") +
          theme_minimal()
    })
    
    ggplotly(p)
}

# Run the application 
shinyApp(ui = ui, server = server)
