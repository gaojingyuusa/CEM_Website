library(shiny)
library(leaflet)
library(rgdal)
library(raster)
library(dplyr)
library(formattable)
library(shinydashboard)

# Test selection box
selection <- c("NV.AGR.TOTL.KD",
               "NV.IND.TOTL.KD",
               "NV.SRV.TOTL.KD",
               "NY.GDP.MKTP.KD",
               "NY.GDP.FCST.KD",
               "NE.GDI.FTOT.KD",
               "SP.POP.TOTL",
               "SP.POP.1564.TO.ZS",
               "SL.TLF.CACT.ZS",
               "SL.UEM.TOTL.ZS",
               "SL.AGR.EMPL.ZS",
               "SL.IND.EMPL.ZS",
               "SL.SRV.EMPL.ZS")

# Initiate fake table data
tb <- data.frame(
  name = c("Bob", "Ashley", "James", "David", "Jenny", 
           "Hans", "Leo", "John", "Emily", "Lee"), 
  age = c(28, 27, 30, 28, 29, 29, 27, 27, 31, 30),
  grade = c("C", "A", "A", "C", "B", "B", "B", "A", "C", "C"),
  test1_score = c(8.9, 9.5, 9.6, 8.9, 9.1, 9.3, 9.3, 9.9, 8.5, 8.6),
  test2_score = c(9.1, 9.1, 9.2, 9.1, 8.9, 8.5, 9.2, 9.3, 9.1, 8.8),
  registered = c(TRUE, FALSE, TRUE, FALSE, TRUE, TRUE, TRUE, FALSE, FALSE, FALSE),
  stringsAsFactors = FALSE)

formattable(tb, list(
  age = color_tile("white", "orange"),
  grade = formatter("span", style = x ~ ifelse(x == "A", 
                                               style(color = "green", font.weight = "bold"), NA)),
  area(col = c(test1_score, test2_score)) ~ normalize_bar("#009FDA", 0.2),
  registered = formatter("span",
                         style = x ~ style(color = ifelse(x, "green", "red")),
                         x ~ icontext(ifelse(x, "ok", "remove"), ifelse(x, "Yes", "No")))
))


# Initiate geospatial dataset
Map <- readOGR("WBG_Poly/WB_CountryPolys.shp")
#WB_map <- readOGR("WBG_Poly/WB_CountryPolys.shp")
CJK <- c("CHN","JPN","KOR")
# Read additional data and merge it to the shape file 
df <- data.frame(
  ISO_Codes = WB_map@data$ISO_Codes,
  val = ifelse(WB_map@data$ISO_Codes %in% CJK,1,0),
  label = ifelse(WB_map@data$ISO_Codes %in% CJK,"Available","Unavailable")
)
# Finish up shapefile
WB_map@data <- data.frame(WB_map@data, df[match(WB_map@data[,"ISO_Codes"], df[,"ISO_Codes"]),])
pal2 <- colorNumeric(c("grey","#009FDA"), domain = WB_map@data$val)


# Generate fake sample data
test <- expand.grid(WB_map@data$ISO_Codes,selection, c(2010:2017))
test$value <- rnorm(n=nrow(test),mean=0.5,sd=0.1)
ind <- which(test$value %in% sample(test$value, 5000))
test$value[ind] <- NA
names(test) <- c("ISO_Codes","IND_Codes","Year","Value")
test <- test[!(test$Year>=2015&test$IND_Codes=="SP.POP.TOTL"),]


