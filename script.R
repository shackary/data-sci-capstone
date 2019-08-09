## Just some things to help me with my workspace
library(tidytext)
library(quanteda)

## These 2 functions let me quickly read in either the full files or the subsamples
openAll <- function(){
    twitter <<- readLines("./final/en_US/en_US.twitter.txt", encoding = "UTF-8")
    blogs <<- readLines("./final/en_US/en_US.blogs.txt", encoding = "UTF-8")
    newses <<- readLines("./final/en_US/en_US.news.txt", encoding = "UTF-8")
    closeAllConnections()
}

openSample <- function(){
    twitter <<- readLines("./final/en_US/twitter_filtered.txt", encoding = "UTF-8")
    blogs <<- readLines("./final/en_US/blog_filtered.txt", encoding = "UTF-8")
    newses <<- readLines("./final/en_US/news_filtered.txt", encoding = "UTF-8")
    closeAllConnections()
}

################################################################################

## Execution

openSample()









