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
      tags$title("WEDC, Loughborough University: Books and Manuals"),
      tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
    ),
    
    tags$div(
      class = "wedc-title-container",
      tags$span(class = "wedc-title", "WEDC, Loughborough University: Books and Manuals"),
      tags$a(
        href = "https://lboro.ac.uk",
        target = "_blank",  # Opens in a new tab
        tags$img(src = "logo.png", class = "wedc-logo", alt = "WEDC Logo")
      )
    ),
    
    sidebarLayout(
      sidebarPanel(
        selectInput("collectionSelect", "Select by Collection:", choices = NULL),
        textInput("authorSearch", "Search by Author:", placeholder = "Enter author\'s name"),
        textInput("titleSearch", "Search by Title:", placeholder = "Enter book or manual title"),
        p(),
        p("Water Engineering and Development Centre (WEDC) produces and disseminates quality, relevant and accessible knowledge products to meet the needs of academics, policymakers and practitioners working in various aspects of water engineering and development."),
        p("Books and manuals represent our substantial body of knowledge in water management, engineering and other international development-related subjects developed over 50 years."),
        p(),
        p(tags$a(
          href = "https://www.lboro.ac.uk/research/wedc/publications-and-resources/",
          "View our other publications.",
          target = "_blank"
        ))
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
