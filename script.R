library(tidytext)
library(quanteda)

## Read in data
twitter <- readLines("./final/en_US/twitter_filtered.txt", encoding = "UTF-8")
blogs <- readLines("./final/en_US/blog_filtered.txt", encoding = "UTF-8")
news <- readLines("./final/en_US/news_filtered.txt", encoding = "UTF-8")


## Concatenate them into the full data set, clean up
full_corp <- c(twitter, blogs, news)
rm(twitter, blogs, news)

## Generate quanteda corpus and document feature matrix
corpus <- corpus(full_corp)
features <- dfm(corpus)











