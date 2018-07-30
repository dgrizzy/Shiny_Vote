library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)
library(httr)
library(jsonlite)
library(RColorBrewer)
library(magrittr)
library(DT)


writeContent <- function(input, electionData, state) {
  
  #Change Back to State Input
  
  ourFilter <- electionData[["State"]] == state
  
  stateData <- filter(electionData, ourFilter)
  
  whoWon <- ifelse(stateData[["Margin"]] > 0, "Donald Trump ", "Hillary Clinton ")
    
  howManyNoVote <- stateData[["Num_Not_Voting"]] * 1000
  
  marginInNumber <- abs(stateData[["Margin"]]) * (stateData[["clintonVotes"]] + stateData[["trumpVotes"]])
  
  network <- input[["Freinds"]]^2
  
  numberOfNetworks <- round(marginInNumber / network)
  
  
  
  paste0("The state of ", state, " went to ", 
         whoWon, 
         "by ", abs(stateData[["Margin"]]),"%. ",
         "However, only ", stateData[["Percent_Voting_Poup"]], "% of ages 18-24 voted. ",
         "If you and your freinds all voted for change, it would only take ",
         numberOfNetworks, 
         " of these communities to have changed the 2016 electoral outcome in ",
         stateData[["State"]], "."
  )
  
  
  
  
  
}