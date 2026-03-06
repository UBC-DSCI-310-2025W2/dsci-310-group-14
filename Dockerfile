FROM rocker/tidyverse:4.5.2

RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    build-essential \
    zlib1g-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libtiff5-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /home/rstudio

COPY --chown=rstudio:rstudio renv/activate.R renv/activate.R
COPY --chown=rstudio:rstudio renv.lock renv.lock

RUN R -e "install.packages('renv', repos='https://cloud.r-project.org/')"
RUN R -e "renv::restore()"

RUN mkdir -p output && chown rstudio:rstudio output
COPY --chown=rstudio:rstudio data/raw/meteorite_landings.csv data/raw/meteorite_landings.csv
COPY --chown=rstudio:rstudio src/01_meteor-size-analysis.ipynb src/01_meteor-size-analysis.ipynb
COPY --chown=rstudio:rstudio src/02_meteor-size-analysis.R src/02_meteor-size-analysis.R
COPY --chown=rstudio:rstudio README.md README.md

