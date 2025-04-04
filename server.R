server <- function(input, output, session) {
  
  # Reactive function to read and format the data from the CSV file
  booksData <- reactive({
    csv_file <- "combined_data.csv"
    if (file.exists(csv_file)) {
      read.csv(csv_file, stringsAsFactors = FALSE)
    } else {
      NULL
    }
  })
  
  # Populate the dropdown with unique collection names
  observe({
    df <- booksData()
    if (!is.null(df)) {
      updateSelectInput(
        session,
        "collectionSelect",
        choices = c("All", unique(df$collection_title)),  # Add "All" option
        selected = "All"
      )
    }
  })
  
  # Reactive function to filter books based on inputs
  filteredBooks <- reactive({
    df <- booksData()
    if (is.null(df)) return(NULL)
    
    # Apply filters
    if (!is.null(input$collectionSelect) && input$collectionSelect != "All" && input$collectionSelect != "") {
      df <- df[df$collection_title == input$collectionSelect, ]
    }
    if (!is.null(input$authorSearch) && input$authorSearch != "") {
      df <- df[grepl(input$authorSearch, df$Author, ignore.case = TRUE), ]
    }
    if (!is.null(input$titleSearch) && input$titleSearch != "") {
      df <- df[grepl(input$titleSearch, df$title, ignore.case = TRUE), ]
    }
    
    # Remove duplicate entries based on unique fields (e.g., title and Author)
    if (!is.null(df) && nrow(df) > 0) {
      df <- df %>%
        dplyr::distinct(title, Author, .keep_all = TRUE)
    }
    
    # Sort by title alphabetically
    if (!is.null(df) && nrow(df) > 0) {
      df <- df[order(df$title, decreasing = FALSE), ]
    }
    
    df
  })
  
  # Reactive function to format the filtered data in a grid
  formattedBooks <- reactive({
    df <- filteredBooks()
    if (!is.null(df) && nrow(df) > 0) {
      # Create formatted strings with proper links and thumbnails
      formatted_strings <- sapply(1:nrow(df), function(i) {
        # Determine the appropriate link (hdl, doi, or plain text)
        link <- if (df$hdl[i] != "" && !is.na(df$hdl[i])) {
          paste0("<a href='", df$hdl[i], "' style='color: #002c3d; text-decoration: underline;' target='_blank' class='hover-underline'>", df$title[i], "</a>")
        } else if (df$doi[i] != "" && !is.na(df$doi[i])) {
          paste0("<a href='", df$doi[i], "' style='color: #002c3d; text-decoration: underline;' target='_blank' class='hover-underline'>", df$title[i], "</a>")
        } else {
          paste0("<span style='color: #002c3d;'>", df$title[i], "</span>")
        }
        
        # Thumbnail path
        thumbnail_path <- paste0("thumbnails/", df$article_id[i], ".png")  # Adjust the path as needed
        
        alt_text <- paste("Thumbnail for item", df$article_id[i])

        paste0(
          "<div style='text-align: left; margin: 10px;'>", # Center align and add margin
          "<img src='", thumbnail_path, "' alt='", alt_text, "' style='width: 100px; height: auto;'/>",  # Thumbnail image
          "<br/><strong>", link, "</strong>.<br/>",  # Title link
          "<span style='color: #002c3d;'>", df$Author[i], ". (", 
          df$Year[i], ").</span>",
          "</div>"
        )
      })
      
      # Wrap in a grid container
      grid_output <- paste0(
        "<div style='display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 20px;'>", 
        paste(formatted_strings, collapse = ""),
        "</div>"
      )
      
      return(grid_output)  # Return the formatted strings as a grid layout
    } else {
      return("No results found.")
    }
  })
  
  # Render the filtered and formatted books
  output$bookDetails <- renderUI({
    HTML(formattedBooks())
  })
}
