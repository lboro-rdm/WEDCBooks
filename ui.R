library(shiny)
library(DT)
library(lubridate)
library(shinycssloaders)
library(httr)
library(jsonlite)
library(dplyr)

ui <- tags$html(
  lang = "en",
  fluidPage(
    tags$head(
      tags$title("WEDC, Loughborough University: Books and Manuals"),  # Add page title here
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    tags$div(
      HTML('<span class="wedc-title">WEDC, Loughborough University: Books and Manuals</span><br><br>')
    ),
    sidebarLayout(
      sidebarPanel(
        selectInput("collectionSelect", "Select a Collection:", choices = NULL),
        textInput("authorSearch", "Search by Author:", placeholder = "Enter author\'s name"),
        textInput("titleSearch", "Search by Title:", placeholder = "Enter book or manual title")
      ),
      mainPanel(
        withSpinner(uiOutput("bookDetails"), type = 3, color = "#009BC9", color.background = "#FFFFFF")
      )
    ),
    tags$div(class = "footer", 
             fluidRow(
               column(12, 
                      tags$a(href = 'https://doi.org/10.17028/rd.lboro.28525481', 
                             "Accessibility Statement")
               )
             )
    )
    
  )
)
