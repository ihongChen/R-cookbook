## Data Extraction , Transformation , Loading

#################################################
## Download files, read csv files
#################################################
setwd('d:/ihong/resource/data_book/R/R_Cookbook_EX/ch02_ETL/')
url = 'http://chart.finance.yahoo.com/table.csv?s=^GSPC&a=11&b=23&c=2016&d=0&e=23&f=2017&g=d&ignore=.csv'
download.file(url,'snp500.csv')

getwd()
list.files('./')
url2 = 'https://nycopendata.socrata.com/api/views/jd4g-ks2z/rows.csv?accessType=DOWNLOAD'
download.file(url2,'nyc.csv')

## read.table

stock_data <- read.table('snp500.csv',sep = ',',header = TRUE)
View(stock_data)
subset_data <- stock_data[1:6,c('Date','Open','High','Low','Close','Volume')]
head(subset_data)

## read.csv

stock_data2 <-read.csv('snp500.csv',header=TRUE)
head(stock_data2)


lvr_price <-read.csv('shinchiu.csv',header=TRUE)
head(lvr_price)

## Rcurl 

rows <-getURL(url2)
wifi_hotspot <-read.csv(text=rows)
head(wifi_hotspot)


#################################################
## scanning text files
#################################################

stock_data3 <-scan('snp500.csv',sep=',',what=list(Date='',Open=0,
                                                  High=0,Low=0,Close=0,Volumn=0,Adj_Close=0),
                   skip=1,fill=T)

mode(stock_data3)
stock_data3
str(stock_data3)

## read.fwf ## fix width format

download.file("https://github.com/ywchiu/rcookbook/raw/master/chapter2/weather.op",
              "weather.op")
weather<-read.fwf("weather.op",widths = c(6,6,10,11,9,8),
                  col.names = c("STN","WBAN","YEARMODA","TEMP","MAX","MIN"),skip=1)

head(weather)
names(weather)


#################################################
## Excel files
#################################################

install.packages("xlsx")
library(xlsx)

download.file("http://api.worldbank.org/v2/en/topic/3?downloadformat=excel",
              "worldbank.xls", mode="wb")

options(java.parameters = "-Xmx4096m")
wb <-read.xlsx("worldbank.xls",sheetIndex = 1,startRow = 4) ## out of memory

library(readxl)
df <-read_excel("worldbank.xls",sheet=1,skip=3)

wb2 <- df[names(df)[1:4]]
dim(wb2)
head(wb2)

write.xlsx2(wb2,"wbdata.xlsx",sheetName = "標題一")


#################################################
## Reading Data from db (Mysql)
#################################################

## jdbc
install.packages("RJDBC")
library(RJDBC)

drv <-JDBC('com.mysql.jdbc.Driver',
           '~/Dropbox/AWS/mysql-connector-java-5.1.40/mysql-connector-java-5.1.40-bin.jar')
conn <- dbConnect(drv,
                  "jdbc:mysql://ihongchen.ctbx4pq8or72.us-west-2.rds.amazonaws.com:3306/test",
                  "username",
                  "password")

dbListTables(conn) ## show tables
iris_data <- dbGetQuery(conn,"select * from iris") ## sql query
iris_data

dbDisconnect(conn)


## RMySQL

install.packages("RMySQL")
library(RMySQL)

mydb <-dbConnect(MySQL(),user='user',
                 password='password',
                 host='ihongchen.ctbx4pq8or72.us-west-2.rds.amazonaws.com',
                 port=3306)
dbSendQuery(mydb,"use test;")
fetch(dbSendQuery(mydb,"select * from iris;"))



