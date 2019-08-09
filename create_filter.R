## Generates the profanity list to be used in filtering

## Get list from the source
list <- url("https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt", open="rt")
bad_words <- readLines(list)

## Add whitespace before and after each word to prevent partial matches
bad_words <- paste0(" ", bad_words, " ")

## MORE PROCESSING HERE???

## Write to file
writeLines(bad_words, "./final/en_US/filter.txt", useBytes = T)

## It's extremely inefficient to call grepl on each individual word; consider
## concatenating them all into a single call.
## e.g., bad_words <- paste(bad_words, collapse = " | ")
## Will need to check on how to properly implement this

## Clean up
closeAllConnections()