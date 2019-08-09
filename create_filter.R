## Generates the profanity list to be used in filtering

## Get list from the source
list <- url("https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt", open="rt")
bad_words <- readLines(list)

## Add whitespace before and after each word to prevent partial matches
bad_words1 <- paste0(" ", bad_words, " ")

## MORE PROCESSING HERE???

## Write to file
writeLines(bad_words, "./final/en_US/filter.txt", useBytes = T)

## It's extremely inefficient to call grepl on each individual word; consider
## concatenating them all into a single call.
bad_words2 <- paste(bad_words, collapse = "|", sep = "")
bad_words2 <- paste0("\\b(", bad_words2, ")\\b")
## Will need to check on how to properly implement this

## Clean up
closeAllConnections()
