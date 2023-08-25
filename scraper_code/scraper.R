library(rvest)
library(webdriver)
library(dplyr)

setwd("phantomjs/bin")
system('phantomjs apsa_scrape.js') # call PhantomJS script (stored in phantomjs/bin)

text <- "rendered_page.html" %>%
  read_html() %>%
  html_elements(css = "li") %>%
  html_text()

submissions <- text[grepl("Submission Type", text)]









