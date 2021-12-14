
.libPaths(new = "/packages")

library(ggcorrplot)
library(MASS)
library(keras)
library(NeuralNetTools)
library(kableExtra)
library(fpc)
library(psych)
library(Hmisc)
library(cluster)
library(mclust)

# functions ############
add_legend <- function(...) {
  opar <- par(fig=c(0, 1, 0, 1), oma=c(0, 0, 0, 0),
              mar=c(0, 0, 0, 0), new=TRUE)
  on.exit(par(opar))
  plot(0, 0, type='n', bty='n', xaxt='n', yaxt='n')
  legend(...)
}

frequency_table = function(x){
  # computes frequency table for clusters
  freq_single = table(x)
  data_check = cbind(boston$medv, x)
  high = data_check[ data_check[, 1] >= 34.80, ]
  freq_double = table(high[, 2])
  percentage = 100*freq_double/nrow(high)
  
  table =  rbind(round( freq_single ), round( freq_double ), paste0( round(percentage), "%")) 
  rownames(table) = c("number of houses", "expensive houses", "in %")
  colnames(table) = paste0("cluster ", seq(1:K))
  
  return(table)
  
}

# Boston dataset  ##########
boston = Boston

fts = c("medv","lstat", "ptratio","tax", "rm","nox")

db_sel = boston[, fts]
tolog = c("medv", "lstat")
db_log = db_sel
db_log[, tolog] = log(db_sel[, tolog])

tosquare = c("nox", "rm")
db_log[, tosquare] = db_sel[, tosquare]^2
dataset = db_log[, fts]

# descriptive statistics ######
descriptive = psych::describe(boston$medv) # descriptive statistics on medv
percentiles = Hmisc::describe(boston$medv)

outliers = boxplot.stats(boston$medv)$out # find outliers

perc_outliers = 100*( length( outliers )/nrow(boston) ) # percentage of outliers

# K means #########

features = dataset[, -which(colnames(dataset) == "medv")] # exclude target variable
X = scale(features) # normalize features

k_max = 10 # set maximum number of clusters
dissimilarity = matrix(0, nrow = k_max, ncol = 1) # within-cluster dissimilarity
clusters = matrix(1, ncol = k_max, nrow = nrow(X)) # clusters

means = colMeans(X) # feature means (zero since normalized)
dissimilarity[1] = sum(colSums(X^2)) # dissimilarity for 1 cluster

all_kmeans = list()

set.seed(123)
for(k in 2:k_max){
  # form clusters for k = 2, ..., k_max
  if(k == 2){
    # kmeans for 2 clusters
    k_mean = kmeans(X, k)
    
  } else {
    # kmeans with initial centroid values
    k_mean = kmeans(X, k_centers)
  }
  
  all_kmeans[[k]] = k_mean
  dissimilarity[k] = sum(k_mean$withins)
  clusters[, k] = k_mean$cluster
  k_centers = matrix(0, nrow = k+1, ncol = ncol(X)) # initial centroid values
  k_centers[1:k, ] = k_mean$centers # centroids for k
  k_centers[k+1, ] = means # feature means for k+1
}

# cluster frequency table kmeans
K = 3
opt_cluster = clusters[, K]
table_km = frequency_table(opt_cluster)


# kmeans vs pca
PCA = prcomp(X)
dati_pca = cbind( X %*% PCA$rotation[, 1], # 1st and 2nd principal component
                  X %*% PCA$rotation[, 2] )

dati_pca2 = cbind( X %*% PCA$rotation[, 4], # last two principal components
                   X %*% PCA$rotation[, 5] )


km_centroids = cbind( all_kmeans[[K]]$centers %*% PCA$rotation[, 1], # estimate centroids
                      all_kmeans[[K]]$centers %*% PCA$rotation[, 2] )

# k-medoids ##########
set.seed(123)
k_med = pam(X, k = K, metric = "manhattan", diss = F, pamonce = F)
table_kmed = frequency_table(k_med$clustering)


# GMM ##########
set.seed(123)
k_gmm = Mclust(X, G = K, modelNames = "EEI")

gmm_centroids = cbind( t( k_gmm$parameters$mean) %*% PCA$rotation[, 1], # estimate centroids
                       t( k_gmm$parameters$mean) %*% PCA$rotation[, 2] )

table_gmm = frequency_table(k_gmm$classification)


# hierarchical clustering #######
set.seed(123)
k_hc = hclust(dist(X), method = "complete")
hc_cluster = cutree(k_hc, k = K)

table_hier = frequency_table(hc_cluster)

# cluster evaluation ##########

# silhouette score
sil_km <- silhouette(clusters[, K], dist(X))
sil_kmed <- silhouette(k_med$clustering, dist(X))
sil_gmm <- silhouette(k_gmm$classification, dist(X))
sil_hc = silhouette(hc_cluster, dist(X))

# dunn index
stats_km = fpc::cluster.stats(d = dist(X), clustering = clusters[, K])
stats_kmed = fpc::cluster.stats(d = dist(X), clustering = k_med$clustering)
stats_gmm = fpc::cluster.stats(d = dist(X), clustering = k_gmm$classification)
stats_hc = fpc::cluster.stats(d = dist(X), clustering = hc_cluster)


save.image("./report/clustering.RData")

