## Generates the profanity list to be used in filtering

## The main function removes lines containing profanity from a character vector
censorize <- function(file, profanity){
    bad_lines <- sapply(profanity, function(x) grepl(x, file, ignore.case = T))
    bad_lines <- apply(bad_lines, 1, any)
    cat("removed", as.character(sum(bad_lines)), "lines.")
    file[!bad_lines]
}

## Get list from the source
list <- url("https://raw.githubusercontent.com/RobertJGabriel/Google-profanity-words/master/list.txt", open="rt")
bad_words <- readLines(list)

## Add words missing from the default list
bad_words <- c(bad_words, "bullshit")

## Process the list into a regular expression that will find the full words
## but not partial matches
bad_words <- paste(bad_words, collapse = "|", sep = "")
bad_words <- paste0("\\b(", bad_words, ")\\b")

## Read in the samples
twitter <- readLines("./final/en_US/en_US.twitter.txt", encoding = "UTF-8")
blogs <- readLines("./final/en_US/en_US.blogs.txt", encoding = "UTF-8")
news <- readLines("./final/en_US/en_US.news.txt", encoding = "UTF-8")

## Filter them
cat("Twitter:")
twitter <- censorize(twitter, bad_words)
cat("Blogs:")
blogs <- censorize(blogs, bad_words)
cat("News:")
news <- censorize(news, bad_words)

## Write the results to a new file
writeLines(twitter, "./final/en_US/twitter_filtered_full.txt", useBytes = T)
writeLines(blogs, "./final/en_US/blog_filtered_full.txt", useBytes = T)
writeLines(news, "./final/en_US/news_filtered_full.txt", useBytes = T)

## Clean up
closeAllConnections()
rm(list, bad_words, twitter, news, blogs)