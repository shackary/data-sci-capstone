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
write_csv(trigrams2, path = "./final/en_US/trigrams2.csv")
rm(corpus2, trigrams2)

## Part 3
trigrams3 <- unnest_tokens(corpus3, trigrams, text, token = "ngrams", n = 3,
                           stopwords = c("rt"))
trigram_total3 <- nrow(trigrams3)
trigrams3 <- trigrams3 %>% count(trigrams, sort = T) %>% filter(n > 2)
write_csv(trigrams3, path = "./final/en_US/trigrams3.csv")
rm(corpus3, trigrams3)

################################################################################

## Stitch them together

## First parts 1 and 2
trigrams1 <- read_csv("./final/en_US/trigrams1.csv")
trigrams2 <- read_csv("./final/en_US/trigrams2.csv")

## Get the intersection, then create a data frame from that list with totaled ns
tri_intersect <- intersect(trigrams1$trigrams, trigrams2$trigrams)
tri_intersect_n <- trigrams1$n[trigrams1$trigrams %in% tri_intersect] + trigrams2$n[trigrams2$trigrams %in% tri_intersect]
trigrams_both <- data.frame(tri_intersect, tri_intersect_n, stringsAsFactors = F)
colnames(trigrams_both) <- c("trigrams", "n")

## Remove the values from the two lists that appear in the both list
trigrams1 <- trigrams1[!(trigrams1$trigrams %in% trigrams_both$trigrams),]
trigrams2 <- trigrams2[!(trigrams2$trigrams %in% trigrams_both$trigrams),]

## Union them all
trigrams_merge1 <- union(trigrams_both, union(trigrams1, trigrams2))
rm(trigrams1, trigrams2, trigrams_both, tri_intersect, tri_intersect_n)

## Then merge1 with part 3
trigrams3 <- read_csv("./final/en_US/trigrams3.csv")
tri_intersect <- intersect(trigrams_merge1$trigrams, trigrams3$trigrams)
tri_intersect_n <- trigrams_merge1$n[trigrams_merge1$trigrams %in% tri_intersect] + trigrams3$n[trigrams3$trigrams %in% tri_intersect]
trigrams_both <- data.frame(tri_intersect, tri_intersect_n, stringsAsFactors = F)
colnames(trigrams_both) <- c("trigrams", "n")
trigrams_merge1 <- trigrams_merge1[!(trigrams_merge1$trigrams %in% trigrams_both$trigrams),]
trigrams3 <- trigrams3[!(trigrams3$trigrams %in% trigrams_both$trigrams),]
trigrams_all <- union(trigrams_both, union(trigrams_merge1, trigrams3))
rm(trigrams_merge1, trigrams3, trigrams_both, tri_intersect, tri_intersect_n)

## Write to file again
write_csv(trigrams_all, "./final/en_US/trigrams_all.csv")

## Finally, separate into words and calculate weights
trigrams_all <- read_csv("./final/en_US/trigrams_all.csv")
trigram_total <- trigram_total1 + trigram_total2 + trigram_total3
trigrams_all <- trigrams_all %>% 
    separate(trigrams, into = c("word1", "word2", "word3"), sep = " ")  %>% 
    mutate(n = n/(trigram_total))

