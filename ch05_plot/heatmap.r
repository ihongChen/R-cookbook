

nba <- read.csv("http://datasets.flowingdata.com/ppg2008.csv", sep=",")

nba_matrix <- data.matrix(nba)

library(d3heatmap)

d3heatmap(nba_matrix, scale = "column", dendrogram = "none",
          color = scales::col_quantile("Blues", NULL, 5))

d3heatmap(nba_matrix, scale = "column", dendrogram = "none",
          color = "Blues")

d3heatmap(nba_matrix, colors = "Blues", scale = "col",
          dendrogram = "row", k_row = 3)
