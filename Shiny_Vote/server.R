# Load Libraries
library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)
library(httr)
library(jsonlite)
library(magrittr)

# Load Data
electionData <- read_csv("VoteAndYouthTurnoutData2016.csv")
geoJsonData <- geojson_read("statesData.json", what = "sp")

# Source Functions
source("leafletFunction.R")
source("uxFunctions.R")

# Change Types
states <- select(electionData, State)
electionData <- bind_cols(states, map_df(electionData[,2:ncol(electionData)], as.numeric))

# Change Caps 
geoJsonData$NAME %<>% str_to_title() 

# Order the Titles Properly
electionData <- electionData[order(match(electionData$State, geoJsonData$NAME)), ] 



#________________Start Server Logic________________
shinyServer(function(input, output) {

  
  #________________Plot Leaflet________________
  output$mainLeaflet <- renderLeaflet({
    
    if (input$layerRequested == "2018 Presidential Margin") {
      plotPresLeaflet(electionData, geoJsonData)  
    } else if (input$layerRequested == "Youth Voting Participation Rate") {
      plotParticLeaflet(electionData, geoJsonData)
    } else {
      genZPowerLeaflet(electionData, geoJsonData)
    }
    })

  #________________Create UI Element For States________________
  output$StateChoices <- renderUI({
    selectInput(inputId = "StateInput",
                label = "Choose Focus State:",
                multiple = FALSE,
                selected = "Michigan",
                choices = sort(electionData$State))})

  #________________Set Up The Bottom Varibles________________
  output$StateResponse <- renderUI({
    
    writeContent(input, electionData, state = input$StateInput)
  
    })
  
  output$Explain <- renderUI({
    tags$em("In 2016, nearly 60% of people between the ages of 18-24 chose not to vote. Whether you're happy
    or not about the result, we need to begin to recognize that young people have the
    power to engage with others and make a difference.")
  })
  
}) #SERVER END BRACKET

