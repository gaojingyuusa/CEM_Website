#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
source("global.R", local=F)
source("server_map_1.R",local=T)
# Define UI ----

fluidPage(
  tags$head(
    tags$style(HTML("
    .leaflet-container { background: white;}
    #sidebar  {background-color: white;}
    .tabbable > .nav > li[class=active] > a {background-color: #002244;color: #FFF; 
                   ")
              )
  ),
  
  # Set the title panel: including the title and WBG picture
  titlePanel(
    fluidRow(
      column(6,p("Country Economic Memorandum 2.0", style="color:#009FDA"))
            )
            ),
  
  # Set the sidebar selection buttons: including indicator selection and download buttons
  sidebarLayout(
    
    # Sidebar setting
    sidebarPanel(id="sidebar",
      h3(strong("MACRO QUESTION 1"),style="color:#002244"),
      h4("Download Indicators", style="color:grey"),
      selectInput("INDICATOR","Select Indicator",choices=c("All",unique(as.character(test$IND_Codes))),"NV.AGR.TOTL.KD", multiple = T),
      selectInput("YEAR", "Select Year", choices = c("All",unique(test$Year)),selected="All",multiple=T),
      downloadButton("DOWNLOAD","Download Selected",class="butt",
                     tags$head(tags$style(".butt{background-color:#002244;} .butt{color: white;}"))),
      downloadButton("DOWNLOADALL","Download Bulk", class="butt2",
                     tags$head(tags$style(".butt2{background-color:#009FDA;} .butt2{color: white;}"))),
      p(" "),
      img(src="wbg_efi.png", height = 50)
                ),
    
    # Mainpanel setting
    mainPanel(
      tabsetPanel(type = "tabs",

                  # Mapping Data                    
                  tabPanel("Data Map",
                           h3(strong("Is Recent Economic Growth due to Cyclical or Structural Factors?"), style="color:#002244"),
                           p("It is important to understand whether growth is mainly due to structural factors and/or represents reactions to the economic cycle. Disentangling structural from cyclical components of growth may throw some light on whether recent growth will be maintained going forward."),
                           # Two selection boxes
                           h5("Mapping Your Data", style="color:#002244"),
                           fluidRow(
                           column(6, div(style = "color:#002244",
                           selectInput("INDICATOR2","Indicator",choices=unique(test$IND_Codes),"NV.AGR.TOTL.KD")
                           )
                           ),
                           column(6,div(style = "color:#002244",
                           selectInput("YEAR2", "Year", choices = unique(test$Year),max(test$Year))
                           )
                           )
                           ),
                           # Three value boxes before the map
                           
                           fluidRow(
                             column(4,
                                    h4("Data availability"),
                                    h3(span(textOutput("vbox1"),style="color:#009CA7;font-size:40px"),style="margin:0%"),
                                    h4("countries",style="margin-top:0%")
                                    ),
                             column(4, 
                                    h4("Average"),
                                    h3(span(textOutput("vbox2"),style="color:#006068;font-size:40px"),style="margin:0%"),
                                    h4("index unit",style="margin-top:0%")
                                    ),
                             column(4, 
                                    h4("Range"),
                                    h3(span(textOutput("vbox3"),style="color:#009FDA;font-size:36px"),style="margin:0%"),
                                    h4("index unit",style="margin-top:2%")
                                    )
                                    ),
                  # Map the bothe the value and availability
                           leafletOutput("map_val", width="100%")
                           ),
                  
                  # Presenting Data Table
                  tabPanel("Table",
                           h4("Indicator Selected Information"),
                           DTOutput("table")
                          ),
                  
                  # Adding additional information
                  tabPanel("Documentation",
                           h4(strong("Tools & Approaches"), style="color:#002244"),       
                           p("Two alternative methods can be used to decompose growth into its structural and cyclical components. Each approach would take approximately 1-2 hours."),
                           p(strong("Hodrick-Prescott (HP) filter and model-based analysis")," – using the World Bank’s macroeconometric model, MFMOD. The HP filter is a statistical technique used to produce a smoothed measure of real GDP, which is then taken to represent an economy’s underlying potential. Deviations from this trend would represent unsustainable temporary deviations from potential. The Hodrick-Prescott-Filter Excel Add-In and MFMOD. You may download the HP Filter Excel add-in from http://www.web-reg.de/hp_addin.html. The HP filter is also implementable in Stata and other statistical software."),
                           p(strong("Compare actual and potential growth")," – latter of which can be computed using MFMOD. Potential growth is estimated as a function of changes in capital stock, labor force, and TFP along the lines of Solow decomposition. For instance, structural factors could include increases in investment and rising labor inputs while cyclical drivers may reflect short-term stimulative measures. Although these methods are admittedly imperfect, they could give us a sense of how an economy is performing compared to its potential.")
                          ),
                  
                  # Link to original data sources
                  tabPanel("Data Source",
                           dataTableOutput("datatb")
                          )
                  
                  )
      
              )
  )
)


