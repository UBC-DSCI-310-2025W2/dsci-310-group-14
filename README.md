<!-- # dsci-310-group-14

## To download dataset:

```
curl -o "https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv"
``` -->

# Meteorite Landings Analysis

## Contributors

- Aryan Taneja (28975563)
- Rishabh (71497275)
- Allison Tao (41292483)
- Eva Ma (36961662)

## Project Summary

This project analyzes the **NASA Meteorite Landings dataset** to investigate how meteorite mass varies over time, location, and meteorite classification. Using data cleaning, exploratory visualization, and linear regression modeling in R, the project examines whether temporal trends and meteorite class interactions help explain variation in meteorite mass.

The dataset was obtained from NASA’s public meteorite database and includes variables such as meteorite mass, year of landing or discovery, geographic coordinates, meteorite classification, and fall status (Fell vs Found).

After cleaning and preprocessing the dataset, a linear regression model was fitted to predict the log-transformed meteorite mass using:

- year of observation  
- meteorite classification  
- geographic coordinates (latitude and longitude)  
- fall status  

The analysis explores how meteorite mass has changed over time and whether these trends differ across meteorite classes. Visualizations and model evaluation plots are used to interpret the results and assess predictive performance.

1. Downloads the NASA Meteorite Landings dataset.
2. Cleans and preprocesses the data.
3. Selects the five most common meteorite classes.
4. Fits a **Gaussian linear regression model** predicting:

$$
\log_{10}(mass) \sim year * recclass + reclat + reclong + fall
$$

5. Generates two visualizations:
   - **Regression lines by meteorite class over time**
   - **Predicted vs. actual log-mass values**

The analysis is implemented in **R** and can be run locally or through **Docker**.p

# How to Run the Analysis

## 1. Run Locally Using Rscript

### Step 1 — Clone the Repository

```bash
git clone https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-14.git
cd dsci-310-group-14
```

### Step 2 — Restore the R Environment

This project uses renv to manage package dependencies. Restore the project environment using:

```R
renv::restore()
```

Installs all required packages listed in the renv.lock file.

### Step 3: Run the Script

```bash
Rscript src/02_meteor-size-analysis.R
```

## 2. Run Using Docker (Pull from Dockerhub)

The analysis can also be run without installing R locally, through a docker image published on dockerhub.

### Step 1: Pull the docker image

```bash
docker pull babustudy/dsci-310-group14
```

### Step 2: Run the container

```bash
docker run --rm -p 8787:8787 -e PASSWORD=dsci310 babustudy/dsci-310-group14
```

### Step 3: Open RStudio

Open a browser and go to:

```url
http://localhost:8787
```

Login Credentials:

```bash
username: rstudio
password: dsci310
```

### Step 4: Run the script

```bash
Rscript src/02_meteor-size-analysis.R
```

## 3. Build Docker Image from Source

If you want to build the container locally instead of pulling it from DockerHub:

### Step 1: Clone the Repository

```bash
git clone https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-14.git
cd dsci-310-group-14
```

### Step 2: Build the Image

```bash
docker build -t dsci-310-group14
```

### Step 3: Run the Container

```bash
docker run --rm -p 8787:8787 -e PASSWORD=dsci310 dsci-310-group14
```

Login Credentials:

```bash
username: rstudio
password: dsci310
```

### Step 4: Run the script

```bash
Rscript src/02_meteor-size-analysis.R
```

## Output

The script will:

- Download the meteorite dataset
- Clean and process the data
- Train the regression model
- Generate plots

Output files will be saved in:

```bash
output/
├── regression_by_class.png
└── predicted_vs_actual.png
```

## Dependencies

This project is written in **R** and uses **renv** to manage package dependencies.  
All required packages are listed in the `renv.lock` file and can be installed by running:

renv::restore()

The main R packages used in this analysis include:

- ggplot2 (data visualization)
- dplyr (data manipulation)
- tidyr (data tidying)
- readr (data import)
- broom (model output tidying)
- renv (reproducible dependency management)

To run the containerized workflow, the following software is also required:

- Docker
- rocker/rstudio base image
