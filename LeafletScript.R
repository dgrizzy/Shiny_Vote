# Load Libraries
library(tidyverse)
library(leaflet)
library(geojsonio)
library(httr)
library(jsonlite)
library(RColorBrewer)
library(magrittr)

# Load Data
electionData <- read_csv("ElectionData2016.csv")
geoJsonData <- geojson_read("statesData.json", what = "sp")

electionData <- electionData %>% 
  rbind(c("PR", "Puerto Rico", "0", "0", "0"))

electionData$TrumpVotes %<>% as.character() %>% str_replace_all(",", "") %>% as.numeric()
electionData$ClintonVotes %<>% as.character() %>% str_replace_all(",", "") %>% as.numeric()

electionData <- electionData %>% mutate(TrumpMargin = TrumpVotes -  ClintonVotes)

electionData <- electionData[order(match(electionData$StateNames, geoJsonData$NAME)),]
is.element(electionData$StateNames, geoJsonData$NAME)

# Start Leaflet
mapboxToken <- "pk.eyJ1IjoiZGF2aWRncmlzd29sZCIsImEiOiJjamswYzRmZ24wNTlpM2tsbHF5cXV5djVuIn0.-UfCrx2It8OGax9NS3mdIA"

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pallet <- colorBin("Blue", domain = electionData$TrumpMargin, bins = 10 )

stateLabels <- paste0("<strong>", electionData$StateNames, "<strong/> <br/> <sup>Margin:", electionData$TrumpMargin,"<sup/>" ) %>% lapply(htmltools::HTML)


leafletPlot <- leaflet() %>%
  setView(-96, 37.8, 4) %>% 
  addProviderTiles("MapBox", options = providerTileOptions(
  id = "mapbox.light",
  accessToken = mapboxToken))


  leafletPlot <- addPolygons(leafletPlot,
              data = geoJsonData,
              fillColor = ~pallet(electionData$TrumpMargin),
              weight = 2,
              opacity = 1,
              smoothFactor = 0.5,
              color = "white",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(
                weight = 5,
                color = "#666",
                fillOpacity = 0.7,
                bringToFront = TRUE),
              label = stateLabels,
              labelOptions = labelOptions(
                style = list("font-weight" = "normal", margin = "0px 0px", padding = "1px 1px"),
                textsize = "15px",
                direction = "auto")) 
    
    
 addLegend(leafletPlot, pal = pallet, values = electionData$TrumpMargin, opacity = 0.7, title = NULL,
              position = "bottomright")
  



