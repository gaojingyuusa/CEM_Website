# Initiate server features for the data map

filr_data <- reactive({
  subset(test,IND_Codes==input$INDICATOR2&Year==input$YEAR2)
})

# Map
WB_MAP <- reactive({
  Map@data <- data.frame(Map@data, filr_data()[match(Map@data[,"ISO_Codes"], filr_data()[,"ISO_Codes"]),])
  Map
})

# Download datasets setting
dl_data <- reactive({
  if (input$INDICATOR=="All" & input$YEAR != "All") {
    yr <- input$YEAR
    dl <- subset(test, Year %in% yr)
  } else if (input$INDICATOR !="All" & input$YEAR == "All"){
    ind <- input$INDICATOR
    dl <- subset(test, IND_Codes %in% ind)
  } else if (input$INDICATOR =="All" & input$YEAR == "All") {
    dl <- test
  } else if (input$INDICATOR != "All" & input$YEAR != "All") {
    yr <- input$YEAR
    ind <- input$INDICATOR
    dl <- subset(test, IND_Codes %in% ind & Year %in% yr)
  }
  dl
})




# Set the reactive selection features: Check with Alberto if this is necessary

# Data availability
cover <- reactive({
  nrow(unique(na.omit(filr_data())))
})
# Summary data
average <- reactive({
  round(mean(filr_data()$Value,na.rm=T),2)
})
range <- reactive({
  paste(round(min(filr_data()$Value,na.rm=T),2),"-",round(max(filr_data()$Value,na.rm=T),2))
})