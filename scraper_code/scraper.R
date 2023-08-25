library(rvest)
library(webdriver)
#install_phantomjs()

pjs_instance <- run_phantomjs()
pjs_session <- Session$new(port = pjs_instance$port)

url <- "https://convention2.allacademic.com/one/apsa/apsa23/index.php?cmd=Online+Program+View+Selected+Session+Type+Submissions&selected_session_type_id=11507&program_focus=browse_by_session_type_submissions&PHPSESSID=jg0ql4t3ntucqhluo98t7kerm2"

# load URL to phantomJS session
pjs_session$go(url)

# retrieve the rendered source code of the page
rendered_source <- pjs_session$getSource()

# parse the dynamically rendered source code
html_document <- read_html(rendered_source)


html_document %>%
  html_elements("li") %>%
  html_text()

library(rvest)
library(RSelenium)

remDr <- rsDriver(browser = NULL)

brow <- remDr[["client"]]
brow$open()
brow$navigate("https://www.filmweb.no/kinotoppen/")
h <- brow$getPageSource()
h <- read_html(h[[1]])
h %>% html_nodes(".Kinotoppen_MovieTitle__2MFbT") %>%
  html_text()
