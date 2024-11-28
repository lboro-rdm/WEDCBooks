library(shiny)
library(DT)
library(lubridate)
library(shinycssloaders)

source("script.R")
source("global.R")

# Define UI for application
ui <- fluidPage(
  # Application title
  titlePanel("Loughborough University WEDC Books"),
  
  # CSS to set the background color and font size
  tags$head(
    tags$style(HTML("
      body {
        background-color: #FEFAF5;
        font-size: 16px;
      }
      h2 {
        color: #6F3092;
      }
      a {
        color: #6F3092;
      }
    "))
  ),
  
  # Show a table of the column with a spinner
  fluidRow(
    withSpinner(DTOutput("citations_table"), type = 3, color = "#6F3092", color.background = "#FEFAF5")
  )
)
