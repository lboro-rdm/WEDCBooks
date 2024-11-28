fetch_api_data <- function() {
  
  options(encoding = "UTF-8")
  
  # Set your Figshare API key
  api_key <- Sys.getenv("API_KEY")
  
  # Set the Figshare API request URL
  endpoint1 <- "https://api.figshare.com/v2/account/institution/articles?search_for='WEDC'&item_type=13&page_size=1000"
  encoded_url <- URLencode(endpoint1)
  
  combined_df <- data.frame()
  number <- 0
  
  # Get the data to create the article IDs
  response <- GET(url = encoded_url, add_headers(Authorization = paste("token", api_key)))
  
  if (http_status(response)$category != "Success") {
    stop("Failed to fetch data from Figshare: ", http_status(response)$message)
  }
  
  # Create a JSON file from the data and extract article IDs
  articles_data <- fromJSON(content(response, "text", encoding = "UTF-8"), flatten = TRUE)
  article_ids <- articles_data$id
  
  # Set the Figshare API request URL for articles
  endpoint2 <- "https://api.figshare.com/v2/articles/"
  
  # Use article IDs to get article citation
  for (article_id in article_ids) {
    full_url_citation <- paste0(endpoint2, article_id)
    
    # Get the article citation data
    response <- GET(full_url_citation)
    if (http_status(response)$category != "Success") {
      warning("Failed to fetch data for article ID: ", article_id)
      next
    }
    citation_data <- fromJSON(content(response, "text", encoding = "UTF-8"), flatten = TRUE)
    
    # Put the citation into a data frame
    citation_df <- data.frame(
      Citation = citation_data$citation,
      URL = citation_data$figshare_url,
      Year = year(as.Date(citation_data$published_date, format = "%Y-%m-%d"))
    )
    combined_df <- rbind(combined_df, citation_df)
    number <- number + 1
    print(number)
  }
  
  # Remove duplicates
  deduplicated_df <- distinct(combined_df, .keep_all = TRUE)
  
  # Assign the final datasets to the global environment
  assign("citation_data", deduplicated_df, envir = .GlobalEnv)
  assign("deduplicated_df", deduplicated_df, envir = .GlobalEnv)
}
