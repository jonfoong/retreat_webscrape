# Base image https://hub.docker.com/u/oliverstatworx/
FROM oliverstatworx/base-r-tidyverse:latest
## create directories
RUN mkdir -p /code
RUN mkdir -p /token
RUN mkdir -p /output
## copy files
COPY /scraper_code/4_install_packages.R /code/4_install_packages.R
COPY /scraper_code/4_automate_scraper.R /code/4_automate_scraper.R
COPY /gcp_token/token.json /gcp_token/token.json
## run the script
RUN Rscript /code/4_install_packages.R
CMD Rscript /code/4_automate_scraper.R

