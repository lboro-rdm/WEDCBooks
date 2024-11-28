server <- function(input, output, session) {
  # Load the citation data once when the app initializes
  citation_data <- fetch_api_data()
  
  # Render the data table with all the citation data
  output$citations_table <- renderDT({
    req(citation_data)  # Ensure the data exists before rendering the table
    
    datatable(
      citation_data %>%
        mutate(Citation = paste0('<a href="', URL, '" target="_blank">', Citation, '</a>')) %>%
        select(Citation),  # Only keep the Citation column
      escape = FALSE, # Allow HTML for hyperlinks
      options = list(
        pageLength = 1000, # Set number of rows per page
        autoWidth = TRUE, # Auto-adjust column widths
        dom = 't' # Simplify the UI, showing only the table
      )
    )
  })
}
