# Clustering-Algorithms

Clustering algorithms are used for partitioning a dataset into a certain number of homogenous clusters in an unsupervised manner. The R script in this repository implements and compares different centroid-based, distribution-based and hierarchial clustering algorithms:

* K-means
* K-medoids
* Gaussian Mixture Models
* Agglomerative hierarchical clustering

The selected algorithms are applied to data of the Boston real estate market. The homogeneity of the clusters is measured using the Euclidean distance as the dissimilarity function to be minimized in order to find the optimal partitions. 

The repository contains: 
* The R script for the computations the  Rmarkdown script for generating the report in ```R``` 
* A Docker image with RStudio to ensure reproducibility of results 

See https://github.com/vettorefburana/Run-Rstudio-Server-from-Docker for instructions on how to run the Docker container. 
