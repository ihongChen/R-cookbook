#### unsupervised ####

####download

url = 'https://raw.githubusercontent.com/ywchiu/rcookbook/master/chapter12/taipei_hotel.csv'

download.file(url,destfile = 'taipei_hotel.csv')

hotel <- read.csv('taipei_hotel.csv',header = TRUE)
str(hotel)

plot(hotel$lon,hotel$lat,col=hotel$district)

hotel.dist <- dist(hotel[,c('lat','lon')],method='euclidean')


### hclust ###


### kmeans ####
fit <- kmeans(hotel[,c("lon","lat")],3)

plot(hotel$lon,hotel$lat, col=fit$cluster)

## cosine similarity

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
