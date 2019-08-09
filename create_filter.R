## Generates the profanity list to be used in filtering

## Get list from the source
list <- url("https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt", open="rt")
bad_words <- readLines(list)

## Add words missing from the default list
bad_words <- c(bad_words, "bullshit")

## Process the list into a regular expression that will find the full words
## but not partial matches
bad_words <- paste(bad_words, collapse = "|", sep = "")
bad_words <- paste0("\\b(", bad_words, ")\\b")

## Write to file
writeLines(bad_words, "./final/en_US/filter.txt")

## Clean up
closeAllConnections()
rm(list, bad_words)