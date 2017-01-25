
#################################################
# Enhancing a data.frame with a data.table
#################################################

# download data
setwd('d:/ihong/resource/data_book/R/R_Cookbook_EX/ch04_manipulation/')
url1 <- 'https://raw.githubusercontent.com/ywchiu/rcookbook/master/chapter6/purchase_view.tab'
url2 <- "https://github.com/ywchiu/rcookbook/raw/master/chapter6/purchase_order.tab"
download.file(url1,'purchase_view.tab')
download.file(url2,'purchase_order.tab')

list.files('./')

# data.table
install.packages("data.table")
library(data.table)

purchase <- read.table("purchase_view.tab",header = TRUE,sep = "\t")
order <- read.table("purchase_order.tab",header = TRUE,sep="\t")
dim(purchase)
dim(order)

head(purchase)

purchaseT <- as.data.table(purchase) # data.table 
class(purchaseT) 
head(purchaseT)
## create data.table 
dt <-data.table(product=c('p1','p2','p3'),
                price = c(100,200,300),
                category = 'beverage')
dt

## setnames
setnames(dt,c('Product','Price','Drink'))
head(dt)

## fread : read from file
purchase_dt <- fread("purchase_view.tab",header = TRUE,sep="\t")
order_dt <- fread("purchase_order.tab",header = TRUE,sep="\t")

## compare loading time (data.table vs data.frame)
system.time(purchase <-read.table("purchase_view.tab",header = TRUE,sep = "\t"))
system.time(purchase_dt <-fread("purchase_view.tab",header = TRUE,sep="\t"))

## readr package

install.packages("readr")
library(readr) ## implement with c++ and rcpp , bit slower than fread

order_readr <- read_tsv("purchase_order.tab")
head(order_readr)
class(order_readr)

#################################################
# Managing data with a data.table
#################################################

head(purchaseT[1:3])
head(purchase[1:3])

purchaseT[1:3,User]
purchase[1:3,"User"]


## slicing multiple col
user.price<-order[1:3,c('User','Price')]
dt.user.price<-order_dt[1:3,list(User,Price)] # with list
dt.user.price2 <-order_dt[1:3,.(User,Price)] # with .()
head(dt.user.price2)
##
dt.price <-order_dt[Quantity>3,Price]
head(dt.price)

price <- order[order$Quantity >3,"Price"]

## 
dt.omit.price <-order_dt[,na.omit(Price)]
head(dt.omit.price)
omit.price <- order[!is.na(order$Price),"Price"]
head(omit.price)

## 

dt.omit.price2 <-order_dt[na.omit(Price)]
head(dt.omit.price2,3)

## :=

dt.omit.price2[,Avg_Price:=Price/Quantity]
head(dt.omit.price2,10)
head(dt.omit.price2[Quantity>=2],3)

## := null

dt.omit.price2[,Avg_Price:=NULL]
head(dt.omit.price2,3)

## copy 
dt.omit.price3 <-copy(dt.omit.price2) # in data.table <- is only ref not a copy.
## last User
purchase_dt[.N,User] 



#################################################
# Performing fast aggregation with a data.table
#################################################
order_dt[,mean(na.omit(Price))] # mean(order_dt$Price,na.rm = TRUE)

## avg order per user
mean.price.by.user <- order_dt[,mean(na.omit(Price)),User]
head(mean.price.by.user)

## name, 
mean.price.by.user2 <- order_dt[,.(Price=mean(na.omit(Price))),User]
head(mean.price.by.user2)

## 
mean.price.by.date <- order_dt[,.(Price=mean(na.omit(Price))),
                               by = as.Date(Time)]

head(mean.price.by.date)

## sum of price,N_users by date
head(order_dt)
price_sum_n_users.by.date <- order_dt[,.(Price_Sum=sum(na.omit(Price)),
                                      N_Users = uniqueN(User)),
                                      by = as.Date(order_dt$Time)]
head(price_sum_n_users.by.date)

## calculate average cost per user to date

price_avg.by.date <- order_dt[,.(Price_Avg=sum(na.omit(Price))/uniqueN(User)),
                              by=.(Date=as.Date(Time))]

head(price_avg.by.date,10)

## Date,Product, Price_Sum
Price_Sum.by.Date_N_Product <- order_dt[,.(Price_Sum =
                                             na.omit(sum(Price* Quantity))),
                                        by=.(Date = as.Date(Time),Product)]

head(Price_Sum.by.Date_N_Product)

## sort

sorted.price.desc <- Price_Sum.by.Date_N_Product[order(-Price_Sum)]

head(sorted.price.desc)

###  :=

order_dt[,':='(Avg_P_By_U= mean(na.omit(Price)) ), by=User]

head(order_dt,3)



#################################################
# Merging large datasets with a data.table
#################################################

##
product.dt <- order_dt[,.(Buy = length(Action)),by=Product]
head(product.dt[order(-Buy)],3)

## sort n_views of product
view.dt <- purchase_dt[,.(n_views=length(User)),by=Product]
head(view.dt[order(-n_views)])


## merge dt
merged.dt <- merge(view.dt,product.dt,by="Product")
head(merged.dt[order(-n_views)])
head(merged.dt[order(-Buy)])

## merge dt : setkey ??? failed
setkey(view.dt,Product)
setkey(product.dt,Product)
inner_join.dt <- view.dt[product.dt, nomatch=0]


## left join

left_join <- merge(view.dt, product.dt, by="Product", all.x=TRUE)
head(left_join)

## right join
righ_join <- merge(view.dt,product.dt,by="Product",all.y=TRUE)

## full outer join
full_outer_join <-merge(view.dt,product.dt,by="Product",all=TRUE)
head(full_outer_join)


#################################################
# Subsetting and slicing data with dplyr
#################################################











#################################################
# Sampling data with dplyr
#################################################


#################################################
# Selecting columns with dplyr
#################################################


#################################################
# Chaining operations in dplyr
#################################################


#################################################
# Arranging rows with dplyr
#################################################






#################################################
# Eliminating duplicated rows with dplyr
#################################################

#################################################
# Adding new columns with dplyr
#################################################

#################################################
# Summarizing data with dplyr
#################################################




#################################################
# Merging data with dplyr
#################################################