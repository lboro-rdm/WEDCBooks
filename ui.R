library(shiny)
library(DT)
library(lubridate)
library(shinycssloaders)
library(httr)
library(jsonlite)
library(dplyr)

source("global.R")

ui <- tags$html(
  lang = "en",  # Set the language attribute here
  fluidPage(
    titlePanel(
      HTML('<span style="color: #002c3d;"><strong>WEDC, Loughborough University:</strong></span>
          <span style="color: #009BC9;">Books and manuals</span><br><br>')
    ),
  
  # CSS to set the background color and font size
  tags$head(
    tags$style(HTML("
        @font-face {
          font-family: 'DIN';
          src: url('fonts/DINOT-Medium.otf') format('opentype');
          font-weight: normal;
          font-style: normal;
        }
        @font-face {
          font-family: 'DIN';
          src: url('fonts/DINOT-Bold.otf') format('opentype');
          font-weight: bold;
          font-style: normal;
        }
        
        body {
          background-color: #FFFFFF;
          font-size: 16px;
          font-family: 'DIN', sans-serif;
        }
        h2, a {
          color: #6F3092;
          font-family: 'DIN', sans-serif;
        }
    "))
  ),
  
  # Show a table of the column with a spinner
  fluidRow(
    style = "margin-left: 20px; margin-right: 20px;",
    withSpinner(uiOutput("bookDetails"), type = 3, color = "#009BC9", color.background = "#FFFFFF")
  )
)
)