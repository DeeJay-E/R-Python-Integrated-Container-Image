# R package management setup with renv
# This script helps initialize and manage R packages using renv

# Initialize renv if not already done
if (!file.exists("renv.lock")) {
  cat("Initializing renv for this project...\n")
  renv::init(bare = TRUE)
} else {
  cat("renv already initialized. Use renv::restore() to install packages.\n")
}

# Define common data science packages
data_science_packages <- c(
  # Core tidyverse
  "tidyverse",
  "ggplot2", 
  "dplyr", 
  "readr", 
  "tidyr",
  "stringr",
  "forcats",
  "lubridate",
  "purrr",
  
  # Development tools
  "devtools", 
  "roxygen2",
  "testthat",
  "usethis",
  "pkgdown",
  
  # Data manipulation and analysis
  "data.table",
  "dtplyr",
  "janitor",
  "skimr",
  
  # Machine Learning
  "caret",
  "randomForest",
  "e1071",
  "glmnet",
  
  # Visualization
  "plotly",
  "ggthemes",
  "RColorBrewer",
  "viridis",
  
  # Reporting and documentation
  "knitr",
  "rmarkdown",
  "DT",
  "htmltools",
  
  # Web applications
  "shiny",
  "shinydashboard",
  "shinyWidgets",
  
  # Database connections
  "DBI",
  "RSQLite",
  
  # Python integration
  "reticulate",
  
  # IDE support
  "httpgd",
  "languageserver"
)

# Function to install common packages
install_common_packages <- function() {
  cat("Installing common data science packages...\n")
  renv::install(data_science_packages)
  renv::snapshot()
  cat("Packages installed and snapshot created!\n")
}

# Function to install specific packages
install_packages <- function(packages) {
  renv::install(packages)
  renv::snapshot()
}

# Print helpful information
cat("\n=== renv R Package Management ===\n")
cat("Useful commands:\n")
cat("- renv::status()           # Check package status\n")
cat("- renv::install('pkg')     # Install a package\n") 
cat("- renv::remove('pkg')      # Remove a package\n")
cat("- renv::snapshot()         # Save current state\n")
cat("- renv::restore()          # Restore from renv.lock\n")
cat("- renv::update()           # Update packages\n")
cat("- install_common_packages() # Install common data science packages\n")
cat("\nFor more help: ?renv or https://rstudio.github.io/renv/\n")