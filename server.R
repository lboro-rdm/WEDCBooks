server <- function(input, output, session) {
  # Load the citation data once when the app initializes
  citation_data <- fetch_api_data()
  
  # Render the data table with all the citation data
  output$citations_table <- renderDT({
    req(citation_data)  # Ensure the data exists before rendering the table
    
    # Ensure your citation_data has the necessary columns: URL and Citation
    datatable(
      citation_data %>%
        mutate(Citation = paste0('<a href="', URL, '" target="_blank">', Citation, '</a>')) %>%
        select(Citation),  # Ensure you select the columns to be displayed
      escape = FALSE,  # Allow HTML for hyperlinks
      options = list(
        pageLength = 1000,  # Set number of rows per page
        autoWidth = TRUE,  # Auto-adjust column widths
        dom = 't'  # Simplify the UI, showing only the table
      ),
      rownames = TRUE  # Show row numbers
    )
  })
}
