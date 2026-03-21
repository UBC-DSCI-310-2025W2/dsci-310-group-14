.PHONY: all clean help install render data docker docker-build docker-run

# Default target
all: QuartoDSCIProject.html

# Help target
help:
    @echo "Available targets:"
    @echo "  make all          - Render the final HTML report"
    @echo "  make render       - Render Quarto document"
    @echo "  make data         - Download raw data"
    @echo "  make install      - Restore R environment"
    @echo "  make docker-build - Build Docker image"
    @echo "  make docker-run   - Run Docker container"
    @echo "  make clean        - Remove generated outputs"

# Main output target
QuartoDSCIProject.html: QuartoDSCIProject.qmd data/raw/meteorite_landings.csv
    quarto render QuartoDSCIProject.qmd

# Render alias (convenient shortcut)
render: QuartoDSCIProject.html

# Data download target
data/raw/meteorite_landings.csv:
    mkdir -p data/raw
    curl -L "https://data.nasa.gov/docs/legacy/meteorite_landings/Meteorite_Landings.csv" \
        -o data/raw/meteorite_landings.csv

# Data convenience target
data: data/raw/meteorite_landings.csv

# Install R dependencies
install:
    R --vanilla -e "renv::restore()"

# Docker targets
docker-build:
    docker build -t dsci-310-group14 .

docker-run:
    docker run --rm -p 8787:8787 -e PASSWORD=dsci310 dsci-310-group14

docker: docker-build docker-run

# Clean targets
clean:
    rm -f QuartoDSCIProject.html
    rm -rf QuartoDSCIProject_files

clean-all: clean
    rm -rf data/raw/meteorite_landings.csv
    rm -rf output/*