## Generates the profanity list to be used in filtering

## The main function removes lines containing profanity from a character vector
censorize <- function(file, profanity){
    bad_lines <- sapply(profanity, function(x) grepl(x, file, ignore.case = T))
    bad_lines <- apply(bad_lines, 1, any)
    print(paste("removed", as.character(sum(bad_lines)), "entries"))
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
twitter <- readLines("./final/en_US/twitter_sample.txt", encoding = "UTF-8")
blogs <- readLines("./final/en_US/blog_sample.txt", encoding = "UTF-8")
news <- readLines("./final/en_US/news_sample.txt", encoding = "UTF-8")

## Filter them
print("Twitter:")
twitter <- censorize(twitter, bad_words)
print("Blogs:")
blogs <- censorize(blogs, bad_words)
print("News:")
news <- censorize(news, bad_words)

## Write the results to a new file
writeLines(twitter, "./final/en_US/twitter_filtered.txt", useBytes = T)
writeLines(blogs, "./final/en_US/blog_filtered.txt", useBytes = T)
writeLines(news, "./final/en_US/news_filtered.txt", useBytes = T)

## Clean up
closeAllConnections()
rm(list, bad_words, twitter, news, blogs)