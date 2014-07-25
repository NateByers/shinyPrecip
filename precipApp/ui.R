library(shiny)
if(!require("IDEMdata")){
  if(!require("devtools")) install.packages("devtools")
  library(devtools)
  install_github("InDEM/IDEMdata")
}
library(IDEMdata)

data(wide_precip)

stations <- unique(wide.precip.df$station[!is.na(wide.precip.df$station)])


# to get the names for the substances, load the deep_river_chemistry
# data frame and reshape it to get the names in the proper order
data(deep_river_chemistry)
library(reshape2)
wide.df <- dcast(deep_river_chemistry, STATION_NAME + ACTIVITY_NO + ACTIVITY_END_DATE 
                 + WATERBODY_NAME + UTM_EAST + UTM_NORTH + COUNTY_NAME 
                 ~ SUBSTANCE_NAME, value.var = 'LAB_RESULT')
names <- colnames(wide.df)[8:34]

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("Precipitation Graphs"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("station",
                  "Station:", 
                  stations),
      
      selectInput("name",
                  "Sample:", 
                  names)
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("precipPlot")
    )
  )
))
