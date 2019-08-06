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


## Function that takes a tokenized list and removes lines that include profanity
censorize <- function(x, profanity){
    bad_lines <- sapply(x, function(y) profanity %in% y) #finds lines with profanity
    bad_lines <- apply(bad_lines, 2, any)
    x[!bad_lines]
}


################################################################################

## Execution

openSample

## Tokenizing using the tokenizers package performs very well in my opinion
twit_tk <- tokenize_words(twitter)
blog_tk <- tokenize_words(blogs)
news_tk <- tokenize_words(newses)








