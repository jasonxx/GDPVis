library(shiny)
# ui.R

shinyUI(
  navbarPage("GDPvis",
#  titlePanel("GDPvis"),
  tabPanel("Explore the Data",
    sidebarPanel(
      helpText("Create global maps with economic information."),
      selectInput("var", 
                  label = "Choose a value to display",
                  choices = list("Changes in inventories","Exports of goods and services","Final consumption expenditure","General government final consumption expenditure",
                                 "Gross capital formation","Gross Domestic Product (GDP)","Gross fixed capital formation (including Acquisitions less disposals of valuables)",
                                 "Household consumption expenditure (including Non-profit institutions serving households)","Imports of goods and services"),
                  selected = "Gross Domestic Product (GDP)"),
      uiOutput("slider"),
      sliderInput("Year", 
                  label = "Year:",
                  min = 1970, max = 2013, value = 2013)

    ),    
#    uiOutput("geomap"),
    
    mainPanel(
      textOutput("text1"),
      uiOutput("geomap"),
      dataTableOutput("table1")
    )
  ),
tabPanel("Motionchart",
           mainPanel(
             uiOutput("motionchart")
           )
  )
)
)
