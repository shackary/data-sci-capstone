library(dplyr)
library(readr)

################################################################################

## Main prediction functions

generate_sentence <- function(sentence, add = sample(1:9, 1)){
    for(i in seq_len(add)){
        sentence <- c(sentence, get_next_word(sentence))
    }
    cat(sentence)
}


get_next_word <- function(string){
#    if(get_word(string, 4) == T){
#        word <- get_word(string, 4)
#    }
    if(get_word(string, 3) == T){
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

## Read in data
bigrams <- read_csv("./final/en_US/bigrams.csv")
trigrams <- read_csv("./final/en_US/trigrams.csv")





