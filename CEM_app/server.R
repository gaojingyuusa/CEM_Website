#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
# Define server logic ----
shinyServer(function(input, output) {
  
  # Run the map data initiation 
  source("server_map_1.R", local=T)
  
  # Mapping data availability
  output$WB_map <- renderLeaflet({
    # Initiate shapefile
    #Output map
    WB_map %>% 
      leaflet() %>% 
      addPolygons(weight = 1, 
                  # add labels that display mean income
                  color = "grey",
                  fillColor = ~pal2(val),
                  fillOpacity = 1,
                  opacity=1,
                  label = ~paste0(Names," - ",label),
                  # highlight polygons on hover
                  highlightOptions = highlightOptions(weight = 2, color = "#002244",
                                                      bringToFront = TRUE)) 
  })
  
  # Test reactive map
  output$map_val <- renderLeaflet({
    pal <- colorNumeric(c("white","#009CA7"), na.color = "#CDCDCD" ,domain = WB_MAP()@data$Value)
    WB_MAP() %>% 
      leaflet() %>% 
      addPolygons(weight = 1, 
                  # add labels that display mean income
                  color = "grey",
                  fillColor = ~pal(Value),
                  fillOpacity = 1,
                  opacity=1,
                  label = ~paste0(Names,": ",round(Value, 2)),
                  # highlight polygons on hover
                  highlightOptions = highlightOptions(weight = 2, color = "#002244",
                                                      bringToFront = TRUE))
  })
  
  # Mapping data table 
  output$table <- renderDT({
      as.datatable(formattable(WB_MAP()@data[,c("Names", "ISO_Codes","IND_Codes","Year","Value")], list(
      Value = color_tile("white", "#009CA7")
    )))
  })
  
  # Test reactive table 
  output$datatb <- renderDataTable({
    filr_data()
  })
  
  
 # Value box test
 output$vbox1 <- renderText({
   cover()
 })
 
 output$vbox2 <- renderText({
   average()
 })
 
 output$vbox3 <- renderText({
   range()
 })
 
 
 output$DOWNLOAD <- downloadHandler(
   filename = function() {
     paste(Sys.Date(), ".csv", sep = "")
   },
   content = function(file) {
     write.csv(dl_data(), file, row.names = FALSE)
   }
 )
 
 output$DOWNLOADALL <- downloadHandler(
   filename = function() {
     paste("test", ".csv", sep = "")
   },
   content = function(file) {
     write.csv(test, file, row.names = FALSE)
   }
 )
 
 
})