library(shiny)
library(IDEMdata)
library(lattice)
library(latticeExtra)

data(wide_precip)

samples <- colnames(wide.precip.df)[8:34]

data(substance_names)

# Define server logic required to draw a lattice graph
shinyServer(function(input, output) {

  # Expression that generates a conditioned lattice plot. The expression is
  # wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically
  #     re-executed when inputs change
  #  2) Its output type is a plot

  output$precipPlot <- renderPlot({
    sample.column <- samples[substance_names == input$name]
    
    prSubsetPlot(data = wide.precip.df, site = input$station, site.col = "station", 
                 date.col = "date", precip.col = "precipitation",  
                 sample.col = sample.column, sample.name = input$name, 
                 conditioned = "TRUE", save = FALSE)
  })

})


