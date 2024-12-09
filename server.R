server <- function(input, output, session) {
  
  # Reactive function to fetch and format the data
  formattedBooks <- reactive({
    # Fetch the data
    combined_df <- fetch_api_data()
    
    if (!is.null(combined_df) && nrow(combined_df) > 0) {
      # Create formatted strings with zebra stripe classes
      formatted_strings <- sapply(1:nrow(combined_df), function(i) {
        row_class <- ifelse(i %% 2 == 0, "even-row", "odd-row") # Determine the row class
        paste0("<div class='", row_class, "' style='margin-bottom: 10px;'>", # Add bottom margin
               "<span style='color: #6f3092;'><strong>", combined_df$bookTitle[i], "</strong>. ", 
               combined_df$Author[i], ". (", 
               combined_df$Year[i], "). Loughborough University. Book. </span>",
               '<a href="https://hdl.handle.net/', combined_df$hdl[i], 
               '" style="color: #009bc9;" target="_blank">https://hdl.handle.net/', combined_df$hdl[i], '</a>',
               "</div>")
      })
      
      # Return the formatted strings as a single string
      paste(formatted_strings, collapse = "")
    } else {
      "No data available."
    }
  })
  
  # Render the formatted output
  output$bookDetails <- renderUI({
    HTML(formattedBooks()) # Render the formatted string with hyperlinks
  })
}
