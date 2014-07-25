library(shiny)
if(!require("IDEMdata")){
  if(!require("devtools")) install.packages("devtools")
  library(devtools)
  install_github("InDEM/IDEMdata")
}
library(IDEMdata)
library(lattice)
library(latticeExtra)

data(wide_precip)

samples <- colnames(wide.precip.df)[8:34]

# to get the names for the substances, load the deep_river_chemistry
# data frame and reshape it to get the names in the proper order
data(deep_river_chemistry)
library(reshape2)
wide.df <- dcast(deep_river_chemistry, STATION_NAME + ACTIVITY_NO + ACTIVITY_END_DATE 
                 + WATERBODY_NAME + UTM_EAST + UTM_NORTH + COUNTY_NAME 
                 ~ SUBSTANCE_NAME, value.var = 'LAB_RESULT')
names <- colnames(wide.df)[8:34]

# Define server logic required to draw a lattice graph
shinyServer(function(input, output) {

  # Expression that generates a conditioned lattice plot. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot

  output$precipPlot <- renderPlot({
    sample.column <- samples[names == input$name]
    
    prSubsetPlot(data = wide.precip.df, site = input$station, site.col = "station", 
                 date.col = "date", precip.col = "precipitation",  
                 sample.col = sample.column, sample.name = input$name, 
                 conditioned = "TRUE", save = FALSE)
  })

})
