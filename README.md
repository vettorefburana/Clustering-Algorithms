# Clustering-Algorithms

Clustering algorithms are used for partitioning a dataset into a certain number of homogenous clusters in an unsupervised manner. The R script in this repository implements and compares different centroid-based, distribution-based and hierarchial clustering algorithms:

* K-means
* K-medoids
* Gaussian Mixture Models
* Agglomerative hierarchical clustering

The selected algorithms are applied to data on the Boston real estate market. The homogeneity of the clusters is measured using the Euclidean distance as the dissimilarity function to be minimized in order to find the optimal partition. 

The repsitory contains: 

* The R script for the computations in ```r_script```
* The Rmarkdown script for generating the report in ```report```
* The Dockerfile for running RStudio Server to ensure reproducibility of results 

See https://github.com/vettorefburana/Run-Rstudio-Server-from-Docker for instructions on how to run the Docker container. 
