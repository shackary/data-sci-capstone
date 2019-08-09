## Just some things to help me with my workspace
library(tokenizers)
library(tidytext)
library(tm)

## These 2 functions let me quickly read in either the full files or the subsamples
openAll <- function(){
    twitter <<- readLines("./final/en_US/en_US.twitter.txt", encoding = "UTF-8")
    blogs <<- readLines("./final/en_US/en_US.blogs.txt", encoding = "UTF-8")
    newses <<- readLines("./final/en_US/en_US.news.txt", encoding = "UTF-8")
    closeAllConnections()
}

openSample <- function(){
    twitter <<- readLines("./final/en_US/twitter_sample.txt", encoding = "UTF-8")
    blogs <<- readLines("./final/en_US/blog_sample.txt", encoding = "UTF-8")
    newses <<- readLines("./final/en_US/news_sample.txt", encoding = "UTF-8")
    closeAllConnections()
}



## Function that takes output from readLines() and removes lines that include profanity
## Need to find a suitable word list and ingest it in such a way that it will catch
## start-of-line and end-of-line swears (see create_filter.R)
censorize <- function(file, profanity){
    bad_lines <- sapply(profanity, function(x) grepl(x, file))
    bad_lines <- apply(bad_lines, 1, any)
    print(paste("removed", as.character(sum(bad_lines)), "entries"))
    file[!bad_lines]
}


################################################################################

## Execution

openSample()

## Read in the current profanity list
profanity <- readLines("./final/en_US/filter.txt")

## Filter the text
twitter <- censorize(twitter, profanity)
news <- censorize(newses, profanity)
blogs <- censorize(blogs, profanity)

## Tokenizing using the tokenizers package performs very well in my opinion
twit_tk <- tokenize_words(twitter)
blog_tk <- tokenize_words(blogs)
news_tk <- tokenize_words(news)








