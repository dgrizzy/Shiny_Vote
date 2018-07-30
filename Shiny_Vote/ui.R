# Load Libraries
library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)
library(httr)
library(jsonlite)
library(magrittr)


shinyUI(fluidPage(theme = "main.css",
  
  # TITLE
  titlePanel("Discover the Power of One"),
  
  
  # SIDEBAR
  sidebarLayout(
    sidebarPanel(
      
      # Layer Input 
      selectInput("layerRequested",
                   "Map:",
                   c("2018 Presidential Margin",
                        "Youth Voting Participation Rate",
                        "Gen Z Impact Opportunity"
                        )),
      
      
      # Input for the state of focus
      uiOutput("StateChoices"),
      
      # Input for Number of Freinds
      numericInput(inputId = "Freinds", 
                   label = "How many social media friends do you have?", 
                   value = 300,
                   min = 1, 
                   max = 1000, 
                   step= 15),
      
      tags$hr(),
      
      # Explanation
      htmlOutput("Explain")
    
    ),
    
    # MAIN PANEL
    mainPanel(
      
      # LEAFLET PLOT OUTPUT
      leafletOutput("mainLeaflet"),
      
      tags$hr(),
      
      htmlOutput("StateResponse")
        
  
    )
  )
))

