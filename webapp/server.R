#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(ggplot2)
library(dplyr)
library(shiny)
library(RCurl)

#d1 <- read.csv("../FAO_Global_Catch.csv")
d0 <- getURL("https://raw.githubusercontent.com/bergertom/ShinyApp/gh-pages/FAO_Global_Catch.csv")
d1 <- read.csv(text = d0)
d2 <- aggregate(d1[,2], list(d1[,1]), sum)
d2[,2] <- round(d2[,2]/1000,0)
colnames(d2) <- c("Year","Quantity")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    rdata <- reactive({
        print(paste0("reactive=",input$year))
        subset(d2, Year >= input$year[1] & Year <= input$year[2])
    })
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2] 
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
      

      df <- rdata()
      myplot <- ggplot(data=df, aes(x=Year, y=Quantity)) + 
          xlab("Year") +
          ylab("Catch Quantity (1000 tons)") +
          ggtitle(paste0("Global Capture Forecast ",input$year[1],"-",input$year[2]))+
          geom_point() +
          geom_smooth(method="glm")
      if (input$year[2] == 2014) {
          fit <- glm(Quantity ~ Year, data=df)  
          p2 <- predict(fit, data.frame(Year=c(2015,2016)))
          d3 <- data.frame(Year=c(2015,2016), Quantity=round(p2,0))
          myplot <- myplot + geom_point(data=d3, colour="red")
      }
      print(myplot)
  })
})
