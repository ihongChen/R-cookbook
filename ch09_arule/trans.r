
# ch09 --------------------------------------------------------------------
library(tidyverse)
library(arules)
load('product_by_user.RData')
prod_user <- product_by_user  %>% as_tibble()
str(prod_user)
prod_user$Product %>% class()
## use arules package
trans <- as(prod_user$Product,"transactions")
trans

tr_list <- list(c("Apple","Bread","Cake"),
                c("Apple","Bread","Milk"),
                c("Bread","Cake","Milk"))
names(tr_list) <- paste("Tr",c(1:3),sep="")
tr_list

trans1 <-as(tr_list,"transactions")
trans1

tr_matrix <- matrix(
  c(1,1,1,0,
    1,1,0,1,
    0,1,1,1),ncol=4
)

dimnames(tr_matrix) <- list(
  paste0("Tr",c(1:3)),
  c("Apple","Bread","Cake","Milk")
)

trans2 <- as(tr_matrix,"transactions")
trans2
####################################################
######### Display transactions , associations ######
####################################################

LIST(trans)
summary(trans)
inspect(trans[1:3])

filter_trans <- trans[size(trans)>=3]
inspect(filter_trans[1:3])

image(trans[1:300,1:300])
itemFrequencyPlot(trans,topN=10,type="absolute")

####################################################
#########   Arule 
####################################################

rules <- apriori(trans,parameter=list(supp=0.001,conf=0.1,target="rules"))
summary(rules)

inspect(rules)
rules <- sort(rules,by="confidence",decreasing = T)
inspect(rules)


rules.sorted <- sort(rules,by="lift")
inspect(rules.sorted)
subset.matrix = is.subset(x=rules.sorted,y=rules.sorted)
# subset.matrix = is.subset(rules.sorted, rules.sorted)
subset.matrix
subset.matrix[lower.tri(subset.matrix, diag=T)] <- NA
# 計算每個column中TRUE的個數，若有一個以上的TRUE，代表此column是多餘的
redundant <- colSums(subset.matrix, na.rm=T) >= 1
rules.pruned = rules.sorted[!redundant]

inspect(rules.pruned)
