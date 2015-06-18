library(shiny)
library(rCharts)
require(data.table)
#library(DT)


suppressPackageStartupMessages(library(googleVis))
gdpdata_a<-read.csv(file = "UNdata_Export_20150612_112319089.csv")
gdpdata_b<-read.csv(file = "UNdata_Export_20150614_180103947.csv")
gdpdata<-rbind(gdpdata_a,gdpdata_b)
gdpdata$CountryArea<-gsub("China, People's Republic of","China", gdpdata$CountryArea)
gdpdata$CountryArea<-gsub("Russian Federation","Russia", gdpdata$CountryArea)
gdpdata$CountryArea<-gsub("United Kingdom of Great Britain and Northern Ireland","United Kingdom", 
                           gdpdata$CountryArea)
gdpdata$CountryArea<-gsub("Iran, Islamic Republic of","Iran", gdpdata$CountryArea)
gdpdata$CountryArea<-gsub("Democratic People's Republic of Korea","North Korea", gdpdata$CountryArea)
gdpdata2<-reshape(gdpdata, idvar = c("CountryArea", "Year"), timevar = "Item", direction = "wide")


shinyServer(function(input, output) {
  output$text1 <- renderText({ 
  paste(input$var, "BETWEEN", input$range[1], "AND",input$range[2], "IN THE YEAR OF", input$Year)
    })
##render slider based on input data
output$slider <- renderUI({
  sliderInput("range", "Range of interest", min=min(subset(gdpdata, Item==input$var & Year==input$Year)$Value)-1,
              max=max(subset(gdpdata, Item==input$var & Year==input$Year)$Value)+1, 
              value=c(min(subset(gdpdata, Item==input$var & Year==input$Year)$Value)-1, max(subset(gdpdata, Item==input$var & Year==input$Year)$Value)+1))
  })
##plot table
output$table1<-renderDataTable({
        subset(gdpdata, Item==input$var & Year==input$Year & Value > input$range[1] & Value < input$range[2])
        },
        options = list(pageLength = 10)
        )
output$geomap<-renderGvis({gvisGeoMap(subset(gdpdata, Item==input$var & Year==input$Year & Value > input$range[1] & Value < input$range[2]), 
                                      locationvar="CountryArea",
                                      numvar="Value",
                                      options=list(region="world", dataMode="regions")
                                      )
  })
output$motionchart<-renderGvis({gvisMotionChart(gdpdata2, "CountryArea", "Year", options=list(width=800, height=600))
  })
}
)