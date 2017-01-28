##########################################
# Creating basic plots with ggplot2
##########################################


download.file("https://github.com/ywchiu/rcookbook/raw/master/chapter7/superstore_sales.csv","superstore_sales.csv")

list.files('./')

library(ggplot2)
library(data.table)
library(dplyr)

superstore <-fread("superstore_sales.csv",header=T,sep=",")
head(superstore)

superstore$`Order Date` <- as.Date(superstore$`Order Date`)
str(superstore)

as.data.frame(superstore)

sum_price_by_province <-{
  superstore %>%
    filter(`Order Date`>'2012-01-01') %>%
    select(Sales,Province,`Order Date`) %>%
    group_by(Year_Month= as.Date(strftime(`Order Date`,"%Y/%m/01")),Province) %>%
    summarise(Total_Sales=sum(Sales))
}

head(sum_price_by_province)

## canvas
sample_sum <-sum_price_by_province %>%
  filter(Year_Month>'2012-07-01',Province %in% c('Alberta','British Columbia'))

g <- ggplot(data=sample_sum,
            mapping = aes(x=Year_Month,y=Total_Sales,color=Province)) + ggtitle("Pure Canvas")
g

## geom_point
g<- g + geom_point() + ggtitle("With Point Geometry")
g

## geom_line
g<- g + geom_line() + ggtitle("With line Geometry")
g

## label 
g<- g + xlab("年月") + ylab("Sales Amount/賣出量") + ggtitle("銷售量(區)")
g


##########################################
# Changing aesthetics mapping
##########################################
##
g<-ggplot(data=sample_sum,mapping = aes(x=Year_Month,y=Total_Sales,
                                        color=Province)) + ggtitle("With geom_point")
g+geom_point()
##
g2 <-ggplot(data=sample_sum) + geom_point(mapping=aes(x=Year_Month,y=Total_Sales,
                                                      color=Province)) + 
                                ggtitle("With Aesthetics Mapping")

g2

##

g + geom_point(aes(size=5)) + ggtitle("Adjust Point Size")

g + geom_point(size=5,color="blue") + geom_line()

g + geom_point(aes(y=Total_Sales/10000),size=5,color="blue") + ggtitle("Override y-axes")

g + geom_point(aes(color=NULL)) + ggtitle("Remove Aesthetic Property")

g + geom_point(aes(colour="blue")) # fail 
##########################################
# Introducing geometric objects
##########################################

g <- ggplot(data=sample_sum,mapping = aes(x=Year_Month,y=Total_Sales,col=Province)) + ggtitle("Scatter Plot")
    
g+geom_point()

g + geom_line(linetype = "twodash") ## linetype to blank ,solid , dashed , dotted , dotdash , lingdash , and twodash .


## bar plot 
g + geom_bar(stat="identity", aes(fill=Province), position="stack") + ggtitle("Stack Position")

g + geom_bar(stat="identity",aes(fill=Province),position="fill") + ggtitle("Fill position")

g + geom_bar(stat="identity",aes(fill=Province),position="dodge") + ggtitle("Dodge Position")

## box plot
g+geom_boxplot(aes(x=Province)) + xlab("Province") + ggtitle("Boxplot")

## density , histogram
set.seed(123)
norm.sample = data.frame(val=rnorm(1000))
ggplot(norm.sample,aes(val)) + geom_histogram(binwidth = 0.1) + ggtitle("Histogram")

ggplot(norm.sample,aes(val)) + geom_density() + ggtitle('Density Plot')

## pie chart 

sample_stat <- sum_price_by_province %>%
  select(Province,Total_Sales) %>%
  group_by(Province) %>%
  summarise(sales_stat = sum(Total_Sales)) 

head(sample_stat)

g<- ggplot(sample_stat, aes(x="",y=sales_stat,fill=Province)) + 
    geom_bar(stat="identity") + ggtitle("bar chart with geom_bar")
g + coord_polar("y",start=0) + ggtitle("Pie chart")

##########################################
# Performing transformations
##########################################

sample_sum2 <-sum_price_by_province %>%
  filter(Province %in% c('Alberta','British Columbia')) 

g <- ggplot(data=sample_sum2,
            mapping=aes(x=Year_Month,y=Total_Sales,col=Province))
g + geom_point(size=3) + geom_smooth() + ggtitle('Adding Smoother')

g + geom_point() + stat_smooth()

g + geom_point() + geom_point(stat="summary",fun.y="mean",color="red",size=4)
##########################################
# Adjusting plot scales
##########################################
##
g<-ggplot(data=sample_sum,
          mapping=aes(x=Year_Month,y=Province,
                      size=Total_Sales,color=Province))
##
g + geom_point(aes(size=Total_Sales)) +
  scale_size_continuous(range=c(1,10)) + ggtitle('Resize the point')
##
g + geom_point(aes(shape=Province)) + scale_shape_manual(values=c(5,10)) +
  ggtitle("Adjust The shape of the Point")
##
g2 <- ggplot(data=sample_sum, mapping=aes(x=Year_Month,y=Total_Sales,color=Province))

g2 + geom_bar(stat="identity",aes(fill=Province),position="dodge") +
  scale_fill_brewer(palette = 1) + ggtitle("Refill Bar color")

g2 + geom_bar(stat="identity",aes(fill=Province),position="dodge") + 
  scale_y_continuous(limits=c(1,1e5),trans="log10") + ggtitle("Rescale y Axes")
##########################################
# Faceting
##########################################



##########################################
# Adjusting themes
##########################################



##########################################
# Combining plots
##########################################



##########################################
# Creating maps
##########################################