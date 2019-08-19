library(dplyr)
library(tidyr)
library(tidytext)

################################################################################

## Some trial functions
guess_word <- function(n1, n2){
    n3 <- trigrams %>% filter(word1 == n1, word2 == n2) %>%
        sample_n(1, weight = n) %>% .[["word3"]]
    n3
}

show_possibilities <- function(n1, n2){
    trigrams %>% filter(word1 == n1, word2 == n2) %>% View()
}

################################################################################

## Actual script

## Read in data
twitter <- readLines("./final/en_US/twitter_filtered.txt", encoding = "UTF-8")
blogs <- readLines("./final/en_US/blog_filtered.txt", encoding = "UTF-8")
news <- readLines("./final/en_US/news_filtered.txt", encoding = "UTF-8")



## Concatenate them into the full data set
corpus <- c(twitter, blogs, news)
rm(twitter, blogs, news)

## Tokenize
corpus_tbl <- tibble(text = corpus)
bigrams <- unnest_tokens(corpus_tbl, bigrams, text, token = "ngrams", n = 2)
trigrams <- unnest_tokens(corpus_tbl, trigrams, text, token = "ngrams", n =3)

## Grab the total number of bi- and tri-grams, as we'll need these later
bigram_total <- nrow(bigrams)
trigram_total <- nrow(trigrams)

## Tablefy and calculate weights
bigrams <- bigrams %>% separate(bigrams, into = c("word1", "word2"), sep = " ") %>%
    count(word1, word2, sort = T) %>% 
    mutate(n = n/bigram_total)
trigrams <- trigrams %>% separate(trigrams, into = c("word1", "word2", "word3"),
                     sep = " ") %>%
    count(word1, word2, word3, sort = T) %>% 
    mutate(n = n/trigram_total)




