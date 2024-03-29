library(quanteda)
library(ggplot2)

## Read in data
twitter <- readLines("./final/en_US/twitter_filtered.txt", encoding = "UTF-8")
blogs <- readLines("./final/en_US/blog_filtered.txt", encoding = "UTF-8")
news <- readLines("./final/en_US/news_filtered.txt", encoding = "UTF-8")


## Concatenate them into the full data set
corpus <- c(twitter, blogs, news)


## Generate quanteda corpuses for each type and the full corpus
twit_corp <- corpus(twitter)
blog_corp <- corpus(blogs)
news_corp <- corpus(news) # newscorp lol
full_corp <- corpus(corpus)


## Generate summary statistics about each corpus
twit_tokens <- summary(twit_corp, n = 111755)
blog_tokens <- summary(blog_corp, n = 42747)
news_tokens <- summary(news_corp, n = 49946)
full_tokens <- summary(full_corp, n = 204448)

## Look at the longest and shortest lines
for(i in list(c("Tweets:", twit_tokens), c("Blogs:", blog_tokens), c("News:", news_tokens))){
    cat(as.character(i[1]), "\n")
    cat("The longest line has", as.character(max(i[[4]])), "words.\n")
    cat("There are", as.character(sum(i[[4]] == 1)), "one-word lines.\n")
    cat("Line length quantiles:\n")
    print(quantile(i[[4]]))
    cat("\n\n")
}


## Plot word counts with percentile lines

hist(twit_tokens$Tokens, main = "Frequency of word count per line: Tweets",
     xlab = "Words per line", breaks = "Scott", col = "gainsboro")
abline(v=quantile(twit_tokens$Tokens)[2:4], col = c("dodgerblue", "orangered1", "dodgerblue"),
       lwd = 2, lty = "dashed")
legend(x = "topright", legend = c("25th/75th percentile", "mean"), lty = "dashed",
       lwd = 2, col = c("dodgerblue", "orangered1"), box.lty = 0)

hist(blog_tokens$Tokens, main = "Frequency of word count per line: Blogs",
     xlab = "Words per line", breaks = "Scott", col = "gainsboro")
abline(v=quantile(blog_tokens$Tokens)[2:4], col = c("dodgerblue", "orangered1", "dodgerblue"),
       lwd = 2, lty = "dashed")
legend(x = "topright", legend = c("25th/75th percentile", "mean"), lty = "dashed",
       lwd = 2, col = c("dodgerblue", "orangered1"), box.lty = 0)

hist(news_tokens$Tokens, main = "Frequency of word count per line: News",
     xlab = "Words per line", breaks = "Scott", col = "gainsboro")
abline(v=quantile(news_tokens$Tokens)[2:4], col = c("dodgerblue", "orangered1", "dodgerblue"),
       lwd = 2, lty = "dashed")
legend(x = "topright", legend = c("25th/75th percentile", "mean"), lty = "dashed",
       lwd = 2, col = c("dodgerblue", "orangered1"), box.lty = 0)


## Construct document-features matrices for words and bigrams using the full corpus
dfm1 <- dfm(full_corp, remove = stopwords('english'),
                remove_punct = T)

dfm2 <- dfm(full_corp, remove = stopwords('english'),
            remove_punct = T, ngrams = 2L)

## See the most common features
topfeatures(dfm1, n = 15)
topfeatures(dfm2, n = 15)

## Create data frames from the top features (for ease of plotting)
features1 <- data.frame(word = as.character(names(topfeatures(dfm1, n = 15))),
                        count = unname(topfeatures(dfm1, n = 15)))
features2 <- data.frame(word = as.character(names(topfeatures(dfm2, n = 15))),
                        count = unname(topfeatures(dfm2, n = 15)))

## Plot time 
plot1 <- ggplot(data = features1, aes(x = reorder(word, -count), y = count)) +
    geom_bar(stat = "identity", aes(fill = count)) +
    scale_fill_gradient(low = "plum", high = "darkorchid") +
    labs(title = "Frequency of the top 15 words", x = "", y = "Count") + 
    theme(axis.text.x = element_text(size = 14), legend.position = "none")

plot1

plot2 <- ggplot(data = features2, aes(x = reorder(word, -count), y = count)) +
    geom_bar(stat = "identity", aes(fill = count)) +
    scale_fill_gradient(low = "plum", high = "darkorchid") +
    labs(title = "Frequency of the top 15 bigrams", x = "", y = "Count") + 
    theme(axis.text.x = element_text(size = 12), legend.position = "none")

plot2




