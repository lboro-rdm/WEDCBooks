library(httr)
library(jsonlite)
library(lubridate)

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
  
  # Check for missing fields and handle gracefully
  bookTitle <- ifelse(!is.null(citation_data$title), citation_data$title, NA)
  Author <- ifelse(!is.null(citation_data$authors$full_name), 
                   paste(citation_data$authors$full_name, collapse = ", "), 
                   NA)
  Year <- ifelse(!is.null(citation_data$published_date), 
                 year(as.Date(citation_data$published_date)), 
                 NA)
  hdl <- ifelse(!is.null(citation_data$handle), citation_data$handle, NA)
  
  # Put the citation into a data frame
  citation_df <- data.frame(
    bookTitle = bookTitle,
    Author = Author,
    Year = Year,
    hdl = hdl,
    stringsAsFactors = FALSE
  )
  combined_df <- rbind(combined_df, citation_df)
  number <- number + 1
  print(number)
}

# Sort alphabetically by bookTitle
combined_df <- combined_df[order(combined_df$bookTitle), ]

# Save the final dataset to a CSV file
output_file <- "combined_data.csv"
write.csv(combined_df, file = output_file, row.names = FALSE)
cat("Data saved to", output_file, "\n")
