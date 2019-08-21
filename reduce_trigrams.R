library(dplyr)
library(tidyr)
library(readr)
library(tidytext)


################################################################################

## Read in data
twitter <- readLines("./final/en_US/twitter_filtered_full.txt", encoding = "UTF-8")
blogs <- readLines("./final/en_US/blog_filtered_full.txt", encoding = "UTF-8")
news <- readLines("./final/en_US/news_filtered_full.txt", encoding = "UTF-8")

## Concatenate them into the full data set
corpus <- c(twitter, blogs, news)
rm(twitter, blogs, news)

## Split and tibblefy
corpus1 <- tibble(text = corpus[seq(1, length(corpus), by = 3)])
corpus2 <- tibble(text = corpus[seq(2, length(corpus), by = 3)])
corpus3 <- tibble(text = corpus[seq(3, length(corpus), by = 3)])
rm(corpus)

################################################################################

## Part 1
trigrams1 <- unnest_tokens(corpus1, trigrams, text, token = "ngrams", n = 3,
                           stopwords = c("rt"))
trigram_total1 <- nrow(trigrams1)
trigrams1 <- trigrams1 %>% count(trigrams, sort = T) %>% filter(n > 2)
write_csv(trigrams1, path = "./final/en_US/trigrams1.csv")
rm(corpus1, trigrams1)

## Part 2
trigrams2 <- unnest_tokens(corpus2, trigrams, text, token = "ngrams", n = 3,
                           stopwords = c("rt"))
trigram_total2 <- nrow(trigrams2)
trigrams2 <- trigrams2 %>% count(trigrams, sort = T) %>% filter(n > 2)

