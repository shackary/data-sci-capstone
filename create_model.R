library(dplyr)
library(tidyr)
library(tidytext)

################################################################################

## Main prediction functions

generate_sentence <- function(sentence, add = sample(1:9, 1)){
    for(i in seq_len(add)){
        sentence <- c(sentence, get_next_word(sentence))
    }
    cat(sentence)
}


get_next_word <- function(string){
    if(get_word(string, 4) == T){
        word <- get_word(string, 4)
    }
    else if(get_word(string, 3) == T){
        word <- get_word(string, 3)
    }
    else if(get_word(string, 2) == T){
        word <- get_word(string, 3)
    }
    else{
        word <- sample_n(bigrams, 1)[[1]]
    }
    word
}

get_word <- function(string, gram){
    raw <- sample_n(get_possibilities(string, gram), 1, weight = n)[gram]
    as.character(raw)
}

get_possibilities <- function(string, n){
    phrase <- build_phrase(string, n)
    if(length(phrase) == 1){
        out <- bigrams %>% filter(word1 == phrase[1])
        
    }
    if(length(phrase) == 2){
        out <- trigrams %>% filter(word1 == phrase[1], word2 == phrase[2])
        
    }
    if(length(phrase) == 3){
        out <- tetragrams %>% filter(word1 == phrase[1], word2 == phrase[2],
                              word3 == phrase[3])
        
    }
    out
}

prep_string <- function(string, n){
    tokens <- tokenizers::tokenize_words(string)
    tokens <- tail(tokens[[1]], n)
    tokens
}

build_phrase <- function(string, n){
    n <- n - 1 
    if(n == 1){
        n1 <- prep_string(string, n)[1]
        out <- c(n1)
    }
    if(n == 2){
        n1 <- prep_string(string, n)[1]
        n2 <- prep_string(string, n)[2]
        out <- c(n1, n2)
    }
    if(n == 3){
        n1 <- prep_string(string, n)[1]
        n2 <- prep_string(string, n)[2]
        n3 <- prep_string(string, n)[3]
        out <- c(n1, n2, n3)
    }
    out
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
corpus <- tibble(text = corpus)
bigrams <- unnest_tokens(corpus, bigrams, text, token = "ngrams", n = 2,
                         stopwords = c("rt"))
trigrams <- unnest_tokens(corpus, trigrams, text, token = "ngrams", n =3)
tetragrams <- unnest_tokens(corpus, tetragrams, text, token = "ngrams", n = 4)

## Grab the total number of ngrams, as we'll need these later
bigram_total <- nrow(bigrams)
trigram_total <- nrow(trigrams)
tetragram_total <- nrow(tetragrams)

## Tablefy and calculate weights
bigrams <- bigrams %>% separate(bigrams, into = c("word1", "word2"), sep = " ") %>%
    count(word1, word2, sort = T) %>% 
    mutate(n = n/bigram_total)
trigrams <- trigrams %>% separate(trigrams, into = c("word1", "word2", "word3"),
                     sep = " ") %>%
    count(word1, word2, word3, sort = T) %>% 
    mutate(n = n/trigram_total)
tetragrams <- tetragrams %>% separate(tetragrams,
                                      into = c("word1", "word2", "word3", "word4"),
                                  sep = " ") %>%
    count(word1, word2, word3, word4, sort = T) %>% 
    mutate(n = n/tetragram_total)




