
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

library(dplyr)

## filter 
quantity.over.3<-filter(order_dt,Quantity>=3)
head(quantity.over.3)

quantity.price.filter <- filter(order_dt,Quantity>=3,Price>1000)
head(quantity.price.filter)
#
head(order_dt,3)
quantity.price.in.filter <- filter(order_dt,Product %in% c('P0006944501','P0006018073'))
head(quantity.price.in.filter)

## slice 

slice(order_dt,1:10)
slice(order_dt,(n()-4):n()) # n() last row


#################################
### RSQLite (dplyr)   ###########
#################################
library(RSQLite)

orderdt <- fread("purchase_order.tab",header=TRUE, sep="\t")

my_db <- src_sqlite("order.sqlite",create=T)
order_sqlite <- copy_to(my_db,orderdt,temporary = FALSE)

ordertbl_from_sqlite <- tbl(my_db,sql("select product from orderdt"))
head(ordertbl_from_sqlite)
class(ordertbl_from_sqlite)
## as.data.table(orderdf_from_sqlite) ## convert tbl type 



#################################################
# Sampling data with dplyr
#################################################

set.seed(123)
sample_n(order_dt,6,replace = TRUE)
sample.dt <- sample_frac(order_dt,0.1,replace = FALSE)
nrow(sample.dt)
ncol(sample.dt)

df <- data.frame(a=seq(1,10,1),b=c(rep(1,8),rep(2,2)))
sample_n(df,5,weight=df$b)
#################################################
# Selecting columns with dplyr
#################################################

##
select.quantity.price<-select(order_dt,Quantity,Price)
head(select.quantity.price)

## -  :exclude
select(order_dt,-Price)
head(order_dt)

## select ,everything
select.everything <-select(order_dt,everything())
head(select.everything,3)

## 
select.from.user.to.quantity <- select(order_dt,User:Quantity)
head(select.from.user.to.quantity) ## head(select(order_dt,3:5)) ## same

## select, contain('?')
select.contains.p <- select(order_dt,contains('P'))
head(select.contains.p)

## select + filter

filter(order_dt,Price>=1000) %>%
  select(contains('P')) %>%
  head()
## same as head(filter(select(...)),Price>=1000)

## num_range
set.seed(123)
df <-data.frame(a1=rnorm(3),a2=rnorm(3),b1=1,b2=NA,b3="str")
df
select(df,num_range("a",1:2))
select(df,contains("a"))
#################################################
# Chaining operations in dplyr
#################################################

sum(1:10)

1:10 %>% sum()

select(order_dt,contains('P')) %>%
  filter(Price>=1000) %>%
  select(Price) %>%
  sum()



#################################################
# Arranging rows with dplyr
#################################################

##
order_dt %>% 
  arrange(Price) %>% ## ascend by default
  head(3)

##
order_dt %>%
  arrange(desc(Price)) %>% # or -Price
  head(3)

## sort data by two column variables
order_dt %>%
  arrange(Price,desc(Quantity)) %>%
  head(6)


#################################################
# Eliminating duplicated rows with dplyr
#################################################
## distinct
order_dt %>%
  select(Product) %>%
  distinct() %>%
  head(6)

distinct.product.user.dt <- {
  order_dt %>%
    select(Product,User) %>%
    distinct()
  }

nrow(order_dt)
nrow(distinct.product.user.dt)


#################################################
# Adding new columns with dplyr
#################################################

## mutate
order_dt %>%
  select(Quantity, Price) %>%
  mutate(avg_price=Price/Quantity) %>%
  # arrange(desc(avg_price)) %>%
  head()

## transmute

transmute(order_dt,Avg_Price=Price/Quantity) %>% head()


## transform (Base)

order_dt %>%
  select(Quantity,Price) %>%
  transform(Avg_Price = Price/Quantity) %>%
  head()

#################################################
# Summarizing data with dplyr
#################################################


## summarise, group by  
## select User,sum(Price) from orderdt group by User
order_dt %>% 
  select(User,Price) %>%
  group_by(User) %>%
  summarise(sum(Price)) %>%
  head()


## summarise_each ,

order_dt %>%
  select(User,Price,Quantity) %>%
  filter(!is.na(Price)) %>%
  group_by(User) %>%
  summarise_each(funs(sum),Price,Quantity) %>%
  head()


## summarise_each

order_dt %>%
  select(User,Price) %>%
  filter(!is.na(Price)) %>%
  group_by(User) %>%
  summarise_each(funs(max(.,na.rm=TRUE),min(.,na.rm=TRUE)),
                 Price) %>%
  head()

## n() : count numbers

purchase_dt %>%
  select(User,Product) %>%
  group_by(Product) %>%
  summarise_each(funs(n())) %>%
  head()

## n_distinct
purchase_dt %>%
  select(User,Product) %>%
  group_by(Product) %>%
  summarise_each(funs(n_distinct(User))) %>%
  arrange(desc(User)) %>%
  head()

## 

sample.df <- data.frame(user=c('U1','U1','U1','U3'),
                        product=c("A","B","A","B"),
                        price=c(200,100,300,300))

sample.df %>%
  group_by(user,product) %>%
  summarise(price_sum=sum(price)) %>%
  arrange(price_sum)


#################################################
# Merging data with dplyr
#################################################

product.dt <- order_dt[,.(Buy=length(Action)),by=Product] 
head(product.dt[order(-Buy)])

## above same as ##
order_dt %>%
  group_by(Action,Product) %>%
  summarise(Buy=n()) %>%
  arrange(desc(Buy)) %>%
  head()
##

view.dt <-purchase_dt[,.(n_views=length(User)),by=Product]
head(view.dt)

# inner_join
merged.dt <- inner_join(view.dt,product.dt,by="Product")
head(merged.dt)

## left_join
left_join.dt <- left_join(view.dt,product.dt,by="Product")
head(left_join.dt)

## right_join
right_join.dt <- right_join(view.dt, product.dt, by="Product")
head(right_join.dt)


## full join 
full_join(view.dt,product.dt,by="Product") %>%
  head()

## anti_join
anti_join(view.dt,product.dt,by="Product") %>%
  head()
