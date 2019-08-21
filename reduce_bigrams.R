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
corpus1 <- tibble(text = corpus[seq(1, length(corpus), by = 2)])
corpus2 <- tibble(text = corpus[seq(2, length(corpus), by = 2)])
rm(corpus)

## Generate ngrams
bigrams1 <- unnest_tokens(corpus1, bigrams, text, token = "ngrams", n = 2,
                         stopwords = c("rt"))

## Grab total (for weighting)
bigram_total1 <- nrow(bigrams1)

## Count up and remove the entries that only appear once
bigrams1 <- bigrams1 %>% count(bigrams, sort = T) %>% filter(n > 1)

## Now, do the same for the other half
bigrams2 <- unnest_tokens(corpus2, bigrams, text, token = "ngrams", n = 2,
                          stopwords = c("rt"))
bigram_total2 <- nrow(bigrams2)
bigrams2 <- bigrams2 %>% count(bigrams, sort = T) %>% filter(n > 1)
                          
## Merging: get the intersection, then create a data frame that totals the
## values of the common bigrams
bi_intersect <- intersect(bigrams1$bigrams, bigrams2$bigrams)
bi_intersect_n <- bigrams1$n[bigrams1$bigrams %in% bi_intersect] + bigrams2$n[bigrams2$bigrams %in% bi_intersect]
bigrams_both <- data.frame(bi_intersect, bi_intersect_n, stringsAsFactors = F)
colnames(bigrams_both) <- c("bigrams", "n")

## Remove the values from the two lists that appear in the both list
bigrams1 <- bigrams1[!(bigrams1$bigrams %in% bigrams_both$bigrams),]
bigrams2 <- bigrams2[!(bigrams2$bigrams %in% bigrams_both$bigrams),]

## Union them all
bigrams_all <- union(bigrams_both, union(bigrams1, bigrams2))

## Finally, separate into words and normalize the weights
bigrams_all <- bigrams_all %>% 
    separate(bigrams, into = c("word1", "word2"), sep = " ")  %>% 
    mutate(n = n/(bigram_total1 + bigram_total2))

## Write to CSV because whew
write_csv(bigrams_all, path = "./final/en_US/bigrams.csv")

