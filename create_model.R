library(dplyr)
library(readr)
library(tokenizers)

################################################################################

## Main prediction functions

generate_sentence <- function(sentence = sample_n(bigrams, 1)[[1]],
                              add = sample(1:15, 1)){
    for(i in seq_len(add)){
        nxt <- get_next_word(sentence)
        if(nxt == "i") nxt <- toupper(nxt)
        sentence <- paste(sentence, nxt)
    }
    substr(sentence, 1, 1) <- toupper(substr(sentence, 1, 1))
    sentence <- paste0(sentence, ".")
    cat(sentence, "\n")
}


get_next_word <- function(string){
    word <- get_word(string, 3)
    if(word == "character(0)"){
        word <- get_word(string, 2)
        if (word == "character(0)"){
            word <- sample_n(bigrams, 1)[[1]]
        }
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
    out
}

################################################################################

## Read in data
bigrams <- read_csv("./final/en_US/bigrams.csv")
trigrams <- read_csv("./final/en_US/trigrams.csv")





