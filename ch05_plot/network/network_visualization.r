## network visualization ## 
## from http://kateto.net/network-visualization

## install packages ##

install.packages("igraph")
install.packages("network")
install.packages("sna")
install.packages("ndtv")
install.packages("visNetwork")

####################################
## color and fonts ## 
####################################
plot(x=1:10,y=rep(5,10),pch=10,cex=3,col="dark red")  ## pch: point symbole shape,cex:point size
points(x=1:10,y=rep(6,10),pch=19,cex=3,col="557799")
points(x=1:10,y=rep(4,10),pch=11,cex=3,col=rgb(.25,.5,.3))

plot(x=1:5,y=rep(5,5),pch=19,cex=12,col=rgb(.25,.5,.3,alpha=.5),xlim=c(0,6))

par(bg="gray40")
col.tr = grDevices::adjustcolor("557799",alpha=0.7)
plot(x=1:5,y=rep(5,5),pch=19,cex=12,col=col.tr,xlim=c(0,6))


colors() # list all built-in colors
grep("blue",colors(),value=T) # all blues in colors


pal1 = heat.colors(5,alpha = 1)
pal2 = rainbow(5,alpha = .5)
plot(x=1:10,y=1:10, pch=19,cex=5,col=pal1)
plot(x=1:10,y=1:10, pch=19,cex=5,col=pal2)

palf = colorRampPalette(c("gray80","dark red")) # 色階
plot(x=1:10,y=1:10, pch=19,cex=5,col=palf(5)) # 5等分

# 透明度
palf = colorRampPalette(c(rgb(1,1,1,.2),rgb(.8,0,0,.7)), alpha=TRUE)
plot(x=1:10,y=1:10, pch=19,cex=5,col=palf(10)) 


## RcolorBrewer 
install.packages("RColorBrewer")
library('RColorBrewer')
display.brewer.all()

display.brewer.pal(8,"Set3")
display.brewer.pal(8,'Spectral')
display.brewer.pal(8,'Blues')

pal3 = brewer.pal(10,"Set3")
plot(x=10:1,y=10:1,pch=19,cex=10,col=pal3)
plot(x=10:1,y=10:1,pch=19,cex=10,col=rev(pal3)) # reverse

####################################
## data format, size ,preparation
####################################

nodes = read.csv("Data files/Dataset1-Media-Example-NODES.csv",header=T,as.is=T)
links = read.csv("Data files/Dataset1-Media-Example-EDGES.csv",header=T,as.is=T)

head(nodes)
head(links)
nrow(nodes);length(unique(nodes$id))
nrow(links);nrow(unique(links[,c("from","to")]))

links = aggregate(links[,3],links[,-3],sum)
links = links[order(links$from,links$to),]

colnames(links)[4] = "weight"
rownames(links) = NULL

links

## dataset2: matrix(adjacent)

nodes2 = read.csv("Data files/Dataset2-Media-User-Example-NODES.csv",header=T,as.is=T)
links2 = read.csv("Data files/Dataset2-Media-User-Example-EDGES.csv",header=T,as.is = T)

head(nodes2)
head(links2)

links2 = as.matrix(links2)
dim(links2)
dim(nodes2)

####################################
## plot network with igraph
####################################

library(igraph)
View(links)
View(nodes)
net = graph_from_data_frame(d=links,vertices=nodes,directed=T)
net

E(net)       # The edges of the "net" object
V(net)       # The vertices of the "net" object
E(net)$type  # Edge attribute "type"
V(net)$media # Vertex attribute "media"

# Find nodes and edges by attribute:
# (that returns oblects of type vertex sequence/edge sequence)
V(net)[media=="BBC"]
E(net)[type=="mention"]

# You can also examine the network matrix directly:
net[1,]
net[5,7]

##Get an edge list or a matrix
as_edgelist(net,names = T)
as_adjacency_matrix(net,attr="weight")

## or datframe
as_data_frame(net,what="edge")
as_data_frame(net,what="vertices")

## plot
plot(net)

## 
net = simplify(net,remove.multiple=F,remove.loops=T)
plot(net,edge.arrow.size=.4,vertex.label=NA)


###### dataset2 #######

head(nodes2)
head(links2)

net2 = graph_from_incidence_matrix(links2)
table(V(net2)$type)
plot(net,edge.arrow.size=.4,edge.curved=.2)


##### plotting parameters #######

# Set edge color to light gray, the node & border color to orange 
# Replace the vertex label with the node names stored in "media"

plot(net, edge.arrow.size=.2, edge.color="orange",
     vertex.color="orange", vertex.frame.color="#ffffff",
     vertex.label=V(net)$media, vertex.label.color="black") 


# Generate colors based on media type:
colrs <- c("gray50", "tomato", "gold")
V(net)$color <- colrs[V(net)$media.type]

# Compute node degrees (#links) and use that to set node size:
deg <- degree(net, mode="all")
V(net)$size <- deg*3
# We could also use the audience size value:
V(net)$size <- V(net)$audience.size*0.6

# The labels are currently node IDs.
# Setting them to NA will render no labels:
V(net)$label <- NA

# Set edge width based on weight:
E(net)$width <- E(net)$weight/6

#change arrow size and edge color:
E(net)$arrow.size <- .2
E(net)$edge.color <- "gray80"
E(net)$width <- 1+E(net)$weight/12
plot(net) 