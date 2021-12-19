
.libPaths(new = "/packages")
library(markdown)

source("./R/clustering.R")
rmarkdown::render("./R/report_clustering.Rmd")