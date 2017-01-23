## Data Extraction , Transformation , Loading

#################################################
## 
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

