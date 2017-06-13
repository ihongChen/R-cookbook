#### unsupervised ####

####download

url = 'https://raw.githubusercontent.com/ywchiu/rcookbook/master/chapter12/taipei_hotel.csv'

download.file(url,destfile = 'taipei_hotel.csv')

hotel <- read.csv('taipei_hotel.csv',header = TRUE)
str(hotel)
####
plot(hotel$lon,hotel$lat,col=hotel$district)

hotel.dist <- dist(hotel[,c('lat','lon')],method='euclidean')

### hclust ###
hc <- hclust(hotel.dist,method = "ward.D2")
hc
plot(hc,hang=-0.01,cex=0.7)
hc2<-hclust(hotel.dist,method="single")
plot(hc2,hang=-0.01,cex=0.5)

fit <- cutree(hc,k=3)
table(fit)
plot(hotel$lon,hotel$lat,col=fit)

plot(hc)
rect.hclust(hc,k=3,border="red")
rect.hclust(hc,k=3,which=2,border="red")

### kmeans ####
set.seed(22)
fit <- kmeans(hotel[,c("lon","lat")],3)
str(fit)
plot(hotel$lon,hotel$lat, col=fit$cluster)
### density based cluster 

installed.packages("dbscan")
library(dbscan)
## cosine similarity ###

cos.sim <- function(ix){
  A = X[ix[1],]
  B = X[ix[2],]
  return (sum(A*B)/sqrt(sum(A^2)*sum(B^2)))
}

df_lonlat <- hotel[,c('lon',"lat")]
X <- df_lonlat
n <- nrow(df_lonlat)
cmb<-expand.grid(i=1:n,j=1:n)
matrix(apply(cmb,1,cos.sim),n,n)

####################################################################
### silhouette information ####
####################################################################
## The silhouette coefficient combines the measurement of intra-cluster distance
## and inter-cluster distance, The output value typically ranges from 0 to 1 ; the closer to 1 , the
## better the cluster is
## 

library(cluster)
km <- kmeans(hotel[,c('lon', 'lat')], 3)
hotel.dist <- dist(hotel[,c('lat', 'lon')] , method="euclidean")
kms <- silhouette(km$cluster, hotel.dist)
str(kms)
attributes(kms)
summary(kms)
plot(kms)
####################################################################
### compare clustering method with "fpc" package(custer.stat) ####
####################################################################
# install.packages("fpc")
library(fpc)
hotel.dist <- dist(hotel[,c('lat', 'lon')] , method="euclidean")
single_c <- hclust(hotel.dist, method="single")
hc_single <- cutree(single_c, k = 3)
complete_c <- hclust(hotel.dist,method="complete")
hc_complete <- cutree(complete_c, k = 3)
set.seed(22)
km <- kmeans(hotel[,c('lon', 'lat')], 3)
cs <- cluster.stats(hotel.dist,km$cluster)
cs[c("within.cluster.ss","avg.silwidth")]

list_model_clusters <- list(kmeans = km$cluster,hc_single=hc_single,hc_complete=hc_complete)
sapply(list_model_clusters,function(c){
  cluster.stats(hotel.dist,c)[c("within.cluster.ss","avg.silwidth")]
})

km$withinss

######################################################
##### PCA 
#######################################################

eco.freedom <- read.csv('index2015_data.csv',header=T)
eco.measure <- eco.freedom[,5:14]
eco.pca <- prcomp(eco.measure,center = T,scale=T)
eco.pca
summary(eco.pca)

screeplot(eco.pca,type="barplot")
###########################################################
### Kaiser method 
## In this method, the selection criteria retain eigenvalues greater than 1.

which((eco.pca$sdev)**2 >1)
screeplot(eco.pca,type="line") 
abline(h=1,col="red",lty=3)
eco.pca$x[,1]
plot(eco.pca$x[,1], eco.pca$x[,2], xlim=c(-6,6), ylim = c(-4,3))
text(eco.pca$x[,1], eco.pca$x[,2], eco.freedom[,2], cex=0.7,
     pos=4)
