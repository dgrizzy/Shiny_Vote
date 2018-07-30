# Load Libraries
library(shiny)
library(tidyverse)
library(leaflet)
library(geojsonio)
library(httr)
library(jsonlite)
library(magrittr)


# Create Our Main Presedential Leaflet Plot
plotPresLeaflet <- function(electionData, geoJsonData) {
  library(leaflet)
  
  bins <- c(-Inf, -20, -5, 0, 5, 20, Inf)
  
  pallet <-
    colorBin(
      brewer.pal(3, name = "RdBu"),
      domain = electionData[["State"]],
      bins = bins,
      reverse = TRUE
    )
  
  stateLabels <-
    paste0(
      "<strong>",
      electionData[["State"]],
      "<strong/> <br/> <sup>Trump Margin: ",
      electionData[["Margin"]],
      "%<sup/>"
    ) %>% lapply(htmltools::HTML)
  
  mapboxToken <- "pk.eyJ1IjoiZGF2aWRncmlzd29sZCIsImEiOiJjamswYzRmZ24wNTlpM2tsbHF5cXV5djVuIn0.-UfCrx2It8OGax9NS3mdIA"
  
  
  # Start Actual Leaflet
  ourPlot <- leaflet() %>%
    setView(-96, 37.8, 4) %>%
    addProviderTiles("MapBox",
                     options = providerTileOptions(id = "mapbox.light",
                                                   accessToken = mapboxToken)) %>% 
    addPolygons(
      data = geoJsonData,
      fillColor = ~ pallet(electionData[["Margin"]]),
      weight = 2,
      opacity = 1,
      smoothFactor = 0.5,
      color = "white",
      fillOpacity = 0.7,
      highlightOptions = highlightOptions(
        weight = 5,
        color = "#666",
        fillOpacity = 0.4,
        bringToFront = TRUE
      ),
      label = stateLabels,
      labelOptions = labelOptions(
        style = list(
          "font-weight" = "normal",
          margin = "0px 0px",
          padding = "1px 1px"
        ),
        textsize = "15px",
        direction = "auto"
      )
    ) %>% addLegend(
      pal = pallet,
      values = electionData[["Margin"]],
      opacity = 0.7,
      title = "Trump Margin",
      position = "bottomleft")
  return(ourPlot)
}



# Create Young People Plot
plotParticLeaflet <- function(electionData, geoJsonData) {
  library(leaflet)
  bins <- c(20, 30, 40, 50, 61)
  
  pallet <-
    colorBin(
      brewer.pal(3, name = "Blues"),
      domain = electionData[["State"]],
      bins = bins
    )
  
  stateLabels <-
    paste0(
      "<strong>",
      electionData[["State"]],
      "<strong/> <br/> <sup>Percent of 18-24 who voted: ",
      electionData[["Percent_Voting_Poup"]],
      "%<sup/>"
    ) %>% lapply(htmltools::HTML)
  
  mapboxToken <- "pk.eyJ1IjoiZGF2aWRncmlzd29sZCIsImEiOiJjamswYzRmZ24wNTlpM2tsbHF5cXV5djVuIn0.-UfCrx2It8OGax9NS3mdIA"
  
  
  # Start Actual Leaflet
  ourPlot <- leaflet() %>%
    setView(-96, 37.8, 4) %>%
    addProviderTiles("MapBox",
                     options = providerTileOptions(id = "mapbox.light",
                                                   accessToken = mapboxToken)) %>% 
    addPolygons(
      data = geoJsonData,
      fillColor = ~ pallet(electionData[["Percent_Voting_Poup"]]),
      weight = 2,
      opacity = 1,
      smoothFactor = 0.5,
      color = "white",
      fillOpacity = 0.7,
      highlightOptions = highlightOptions(
        weight = 5,
        color = "#666",
        fillOpacity = 0.4,
        bringToFront = TRUE
      ),
      label = stateLabels,
      labelOptions = labelOptions(
        style = list(
          "font-weight" = "normal",
          margin = "0px 0px",
          padding = "1px 1px"
        ),
        textsize = "15px",
        direction = "auto"
      )
    ) %>% addLegend(
      pal = pallet,
      values = electionData[["Percent_Voting_Poup"]],
      opacity = 0.7,
      title = "Youth Voting Participation",
      position = "bottomleft"
    )
  return(ourPlot)
}


# Gen Z Power Graph
genZPowerLeaflet <- function(electionData, geoJsonData) {
  library(leaflet)
  bins <- c(0, 200, 400, 600,800, 1000, 1200,1400, 1600, 1800, 2000)
  
  pallet <-
    colorBin(
      brewer.pal(3, name = "Greens"),
      domain = electionData[["State"]],
      bins = bins,
      reverse = TRUE
    )
  
  stateLabels <-
    paste0(
      "<strong>",
      electionData[["State"]],
      "<strong/>",
      "<br/> <sup>Vote Margin: ",
      electionData[["Margin"]],
      "%<sup/>",
      "<br/> <sup>Participation: ",
      electionData[["Percent_Voting_Poup"]],
      "%<sup/>") %>% lapply(htmltools::HTML)
  
  mapboxToken <- "pk.eyJ1IjoiZGF2aWRncmlzd29sZCIsImEiOiJjamswYzRmZ24wNTlpM2tsbHF5cXV5djVuIn0.-UfCrx2It8OGax9NS3mdIA"
  
  
  # Start Actual Leaflet
  ourPlot <- leaflet() %>%
    setView(-96, 37.8, 4) %>%
    addProviderTiles("MapBox",
                     options = providerTileOptions(id = "mapbox.light",
                                                   accessToken = mapboxToken)) %>% 
    addPolygons(
      data = geoJsonData,
      fillColor = ~ pallet(electionData[["GenZ_Power"]]),
      weight = 2,
      opacity = 1,
      smoothFactor = 0.5,
      color = "white",
      fillOpacity = 0.7,
      highlightOptions = highlightOptions(
        weight = 5,
        color = "#666",
        fillOpacity = 0.4,
        bringToFront = TRUE
      ),
      label = stateLabels,
      labelOptions = labelOptions(
        style = list(
          "font-weight" = "normal",
          margin = "0px 0px",
          padding = "1px 1px"
        ),
        textsize = "15px",
        direction = "auto"
      )
    )
  return(ourPlot)
}



