library(shiny)
library(dplyr)
library(sp)
library(tmap)
library(raster)

realEstateDf <- read.csv("RealEstate.csv", stringsAsFactors = F)
costaRicaMap <- readRDS("CRI_adm2.rds")
extent <- c(-87.09486, -82.55322, 8, 11.21692  )
costaRicaMap <- crop(costaRicaMap, extent )
costaRicaMap@data$Code <- substr(costaRicaMap@data$HASC_2,7, 8)
listOfRegions <- costaRicaMap@data %>% dplyr::select(Provincia = NAME_1, Canton = NAME_2, Codigo = Code)


generatePlot <- function(terrainWeigth = 0.25, lowerBound = -0.5, upperBound = 0.5){
  meanByCanton <- realEstateDf %>% mutate (
    combinedTerrain = SquareMetersConstruction + SquareMetersTerrain * terrainWeigth,
    PriceByMeters = Price / combinedTerrain
    ) %>%
    filter(combinedTerrain > 1 & !is.na(Price)) %>%
    mutate(NormalizedPriceByMeters= as.vector(scale(PriceByMeters) )) %>%
    filter(NormalizedPriceByMeters > lowerBound & NormalizedPriceByMeters < upperBound) %>%
    group_by(Canton) %>%
    summarize(median = median(PriceByMeters, na.rm=T))
  
  
    meanByCanton <- left_join(costaRicaMap@data, meanByCanton, by=c( "NAME_2" = "Canton"), copy=T)
    
    costaRicaMap2 <- costaRicaMap
    costaRicaMap2@data <- meanByCanton
    
    qtm(costaRicaMap2, "median", text="Code", fill.title="Median Price by M2 (USD)")
}


function(input, output){
  output$out <-renderPlot({generatePlot(input$weight, input$lowerBound, input$upperBound)}, 1024, 1024)
  output$listOfRegions <- renderDataTable(listOfRegions)
}