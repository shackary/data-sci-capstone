library(quanteda)

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
    cat("Line length quantiles\n")
    print(quantile(i[[4]]))
    cat("\n\n")
}


## Plot word counts with percentile lines
hist(twit_tokens$Tokens, main = "Frequency of word count per line: Tweets",
     xlab = "Words per line", breaks = "Scott")
abline(v=quantile(twit_tokens$Tokens)[2:4], col = c("chartreuse3", "red", "chartreuse3"),
       lwd = 2, lty = "dashed")
legend(x = "topright", legend = c("25th/75th percentile", "mean"), lty = "dashed",
       lwd = 2, col = c("chartreuse3", "red"), box.lty = 0)

hist(blog_tokens$Tokens, main = "Frequency of word count per line: Blogs",
     xlab = "Words per line", breaks = "Scott")
#ablines and legend go here

hist(news_tokens$Tokens, main = "Frequency of word count per line: News",
     xlab = "Words per line", breaks = "Scott")
#ablines and legend go here






