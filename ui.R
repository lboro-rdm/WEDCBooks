library(shiny)
library(DT)
library(lubridate)
library(shinycssloaders)
library(httr)
library(jsonlite)
library(dplyr)

source("script.R")
source("global.R")

ui <- fluidPage(
  titlePanel(
    HTML('<span style="color: #361163;">WEDC, Loughborough University:</span> 
        <span style="color: #b70062;">Books and manuals</span>')
  ),
  
  # CSS to set the background color and font size
  tags$head(
    tags$style(HTML("
        body {
          background-color: #FFFFFF;
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
    style = "margin-left: 20px; margin-right: 20px;",
    withSpinner(uiOutput("bookDetails"), type = 3, color = "#361163", color.background = "#FFFFFF")
  )
)
