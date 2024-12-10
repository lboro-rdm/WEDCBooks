server <- function(input, output, session) {
  
  # Reactive function to fetch and format the data from the CSV file
  formattedBooks <- reactive({
    # Read the data from the CSV file
    csv_file <- "combined_data.csv"
    if (file.exists(csv_file)) {
      combined_df <- read.csv(csv_file, stringsAsFactors = FALSE)
      
      if (!is.null(combined_df) && nrow(combined_df) > 0) {
        # Create formatted strings with zebra stripe classes
        formatted_strings <- sapply(1:nrow(combined_df), function(i) {
          paste0("' style='margin-bottom: 10px;'>", # Add bottom margin
                 "<strong><a href='https://hdl.handle.net/", combined_df$hdl[i], 
                 "' style='color: #002c3d; text-decoration: none;' target='_blank'>",
                 combined_df$bookTitle[i], "</a></strong>. ", 
                 "<span style='color: #002c3d;'>", combined_df$Author[i], ". (", 
                 combined_df$Year[i], "). Loughborough University. Book. </span>",
                 '<a href="https://hdl.handle.net/', combined_df$hdl[i], 
                 '" style="color: #009BC9;" target="_blank">https://hdl.handle.net/', combined_df$hdl[i], '</a>',
                 "</div>")
        })
        
        # Return the formatted strings as a single string
        paste(formatted_strings, collapse = "")
      } else {
        "No data available."
      }
    } else {
      "CSV file not found."
    }
  })
  
  # Render the formatted output
  output$bookDetails <- renderUI({
    HTML(formattedBooks()) # Render the formatted string with hyperlinks
  })
}
