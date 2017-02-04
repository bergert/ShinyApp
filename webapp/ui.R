#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Global Capture forecast"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("year", "Year range:", 1950, 2014, value = c(1994, 2014), sep = ""),
       p("The slider allows to select the years for which to show catch data."),
       p("The graph shows the global catch (for human consumption); along with a linear regression line (lm)"),
       p(paste0("The slope of the regression line indicates if the catch is sustainable (upwards) or not; if the last",
         " year selected is 2014 a forecast for 2015 and 2016 is shown (red dots)."))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot")
    )
  )
))
