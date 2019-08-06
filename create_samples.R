## CREATING THE SAMPLES

## Set seed for reproducibility
set.seed(1180)

## Read in the files to be sampled
twitter <<- readLines("./final/en_US/en_US.twitter.txt", encoding = "UTF-8") 
blogs <<- readLines("./final/en_US/en_US.blogs.txt", encoding = "UTF-8")
newses <<- readLines("./final/en_US/en_US.news.txt", encoding = "UTF-8")

## Sample 5 percent of each file
twitter_sample <- sample(twitter, length(twitter) * .05)
blog_sample <- sample(blogs, length(blogs) * .05)
news_sample <- sample(newses, length(newses) * .05)

## Write the samples to a file so they're easier to work with
writeLines(twitter_sample, "./final/en_US/twitter_sample.txt", useBytes = T)
writeLines(blog_sample, "./final/en_US/blog_sample.txt", useBytes = T)
writeLines(news_sample, "./final/en_US/news_sample.txt", useBytes = T)

## Clean up
closeAllConnections()
rm(twitter, newses, blogs, twitter_sample, news_sample, blog_sample)



