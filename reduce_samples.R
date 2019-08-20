library(dplyr)
library(tidyr)
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
corpus1 <- tibble(text = corpus[seq(1, length(corpus), by = 2)])
corpus2 <- tibble(text = corpus[seq(2, length(corpus), by = 2)])
rm(corpus)


## Deal with each set of ngrams individually

##Generate ngrams
bigrams1 <- unnest_tokens(corpus1, bigrams, text, token = "ngrams", n = 2,
                         stopwords = c("rt"))

## Grab total (for weighting)
bigram_total1 <- nrow(bigrams1)

## Count up, remove the entries that only appear once, then separate the words
bigrams1 <- bigrams1 %>% count(bigrams, sort = T) %>% filter(n > 1) %>%
    separate(bigrams, into = c("word1", "word2"), sep = " ")


## Now, do the same for the other half
bigrams2 <- unnest_tokens(corpus2, bigrams, text, token = "ngrams", n = 2,
                          stopwords = c("rt"))
bigram_total2 <- nrow(bigrams2)
bigrams2 <- bigrams2 %>% count(bigrams, sort = T) %>% filter(n > 1) %>%
    separate(bigrams, into = c("word1", "word2"), sep = " ")
                          
                          
                          
###############################################################################
trigrams <- unnest_tokens(corpus, trigrams, text, token = "ngrams", n =3)



tetragrams <- unnest_tokens(corpus, tetragrams, text, token = "ngrams", n = 4)

## Grab the total number of ngrams, as we'll need these later

trigram_total <- nrow(trigrams)
tetragram_total <- nrow(tetragrams)

## Tablefy and calculate weights

trigrams <- trigrams %>% separate(trigrams, into = c("word1", "word2", "word3"),
                                  sep = " ") %>%
    count(word1, word2, word3, sort = T) %>% 
    mutate(n = n/trigram_total)
tetragrams <- tetragrams %>% separate(tetragrams,
                                      into = c("word1", "word2", "word3", "word4"),
                                      sep = " ") %>%
    count(word1, word2, word3, word4, sort = T) %>% 
    mutate(n = n/tetragram_total)