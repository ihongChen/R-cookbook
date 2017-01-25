# Data processing and preparation

#################################################
## Renameing data variable
#################################################

download.file("https://github.com/ywchiu/rcookbook/raw/master/
chapter3/employees.csv", "employees.csv")

download.file("https://github.com/ywchiu/rcookbook/raw/master/
chapter3/salaries.csv", "salaries.csv")

employees <- read.csv('employees.csv', head=FALSE)
salaries <- read.csv('salaries.csv', head=FALSE)

names(employees) <- c("emp_no", "birth_date", "first_name",
                      "last_name", "gender", "hire_date")
names(salaries) <- c("emp_no", "salary", "from_date","to_date")

View(employees)
colnames(salaries)
colnames(employees)

rownames(salaries) <-salaries$emp_no
rownames(salaries)

dimnames(employees) <- list(c(1:10),
                            c("emp_no","birth_date","first_name","last_name","gender","hire_data"))

#################################################
## Converting data types
#################################################
colnames(employees)
str(employees)
class(employees$birth_date)

employees$birth_date <- as.Date(employees$birth_date)
employees$hire_data <- as.Date(employees$hire_data)
employees$first_name <- as.character(employees$first_name)
employees$last_name <- as.character(employees$last_name)

str(employees)

salaries$from_date <- as.Date(salaries$from_date)
salaries$to_date <- as.Date(salaries$to_date)

## assign data type when loading 
employees <- read.csv('./employees.csv',colClasses = c(NA,"Date","character",
                                                       "character","factor","Date"),header = FALSE)

str(employees)


#################################################
## Working with date format
#################################################

employees$hire_date + 30 # date adding 
employees$hire_date - employees$birth_date # time differences

difftime(employees$hire_date,employees$birth_date,units = "weeks") # unit in weeks

## use lubridate packages

install.packages("lubridate")
library(lubridate)

## converting to POSIX format 

ymd(employees$hire_date) # parse data as Year Month Day

span <-interval(ymd(employees$birth_date),ymd(employees$hire_date))
time_period <- as.period(span) # y m d h s 
now()

time_period

span2 <- interval(now(),ymd(employees$birth_date))
years <- as.period(span2)
years

#################################################
## adding new records 
#################################################

## rbind, cbind
employees<-rbind(employees,c(10011,'1960-01-01','Jhon','Doe','M','1988-01-01'))
cbind(employees,position=NA)


span <- interval(ymd(employees$birth_date),now())

time_period <-as.period(span)
employees$age<-year(time_period)

## transform
transform(employees,age=year(time_period),position='RD',marrital=NA)


## with 
with(employees,year(birth_date))
employees$birth_year <- with(employees,year(birth_date))
employees



#################################################
## Filtering data
#################################################

## head
head(employees,3)
## tail
tail(employees,3)

##
employees[1:3,]

employees[1:3,2:4]


employees[c(2,5),c(1,3)]

employees[1:3,c("first_name","last_name")]
## exclude , - 
employees[1:3,-6] 


## using  %in%

employees[1:3,!names(employees) %in% c("last_name","first_name")]

## set equal condition

employees[employees$gender =='M',]

## 
salaries[salaries$salary>=60000 & salaries$salary <70000,]

## substr

substr(employees$first_name,0,2)

employees[substr(employees$first_name,0,2)=='Ge',]

## regx 

employees[grep('[aeiou]$',employees$first_name),]



## subset 

subset(employees,employees$gender=='M') # same as :,employees[employees$gender=='M',]


#################################################
## dropping data
#################################################
# drop no.5 col
employees[,-5]
# hire_date drop
employees$hire_date <-NULL # drop
# drop rows
employees[c(-2,-4,-6),] 

## within ,rm 

within(employees,rm(birth_date,emp_no))


#################################################
## Merging data
#################################################
## merge / table join 
employees_salary <- merge(employees,salaries,by="emp_no") # like SQL join

head(employees_salary,3)
##  left join (all.x=TRUE) , right join(all.y=TRUE) 
merge(employees,salaries,by="emp_no",all.x = TRUE) 

## join
library(plyr)
join(employees,salaries,by="emp_no")


## join_all , recursive join tables;
join_all(list(employees,salaries),by="emp_no")

#################################################
## Merging data
#################################################

a<-c(5,1,4,3,2,6,9)
sort(a)
sort(a,decreasing = TRUE)

order(a) # return sorting index


## 
sorted_salaries <-salaries[order(salaries$salary,decreasing = TRUE),]
head(sorted_salaries)

## sort by two columns

sorted_salaries2 <-salaries[order(salaries$salary,salaries$from_date,decreasing = TRUE),]

head(sorted_salaries2,3)



## arrange (in plyr)

head(arrange(salaries,salary,desc(from_date)))

#################################################
## Reshaping data
#################################################

library(reshape2)
## dcast (long -> wide table)
wide_salaries <- dcast(salaries,emp_no~year(ymd(from_date)),
                       value.var='salary')

wide_salaries[1:3,1:7]
head(wide_salaries)

## multiple columns
wide_employees_salary <-dcast(employees_salary,
                              emp_no+paste(first_name,last_name)~year(ymd(from_date)),
                              value.var = 'salary',variable.names='condition')
head(wide_employees_salary)


## melt
long_salaries <- melt(wide_employees_salary,id.vars = c("emp_no"))
head(long_salaries)

## na.omit
na.omit(long_salaries)


###use plyr , stack,unstack
library(plyr)

un_salaries<-unstack(long_salaries[,c(3,1)])
head(stack(un_salaries))


#################################################
## detecting missing data
#################################################

salaries[salaries$to_date>"2100-01-01","to_date"] =NA
is.na(salaries$to_date)

sum(is.na(salaries$to_date)) # sum of NA

# percentage of NA
sum(is.na(salaries$to_date))/length(salaries$to_date) # 0.081

head(salaries)

## missing value 
sapply(salaries,function(df){
  sum(is.na(df))/length(df)
})

## 
wide_salaries <- dcast(salaries,emp_no~year(from_date),value.var = 'salary')
View(wide_salaries)

sapply(wide_salaries,function(df){
  sum(is.na(df))/length(df)
})


## visualization 
install.packages('Amelia')
library('Amelia')

missmap(wide_salaries, main="Missingness Map of Salary")


#################################################
## Imputing missing data
#################################################

testEmp<-salaries[salaries$emp_no==10001,]
testEmp[8,c('salary')] = NA
## na.omit
na.omit(testEmp)

mean_salary <-mean(salaries$salary[salaries$emp_no==10001],na.rm = TRUE)

testEmp[is.na(testEmp$salary),]

## predict NA salary
attach(testEmp)
fit = lm(salary~from_date) # linear regression

na_date <- testEmp$from_date[is.na(testEmp$salary)] 
predict(fit,data.frame(from_date=na_date))  ## predict NA salary

## use package : mice
install.packages("mice")
library(mice)
testEmp$from_date <- year(ymd(testEmp$from_date))
testEmp$to_date <- year(ymd(testEmp$to_date))
imp <- mice(testEmp,meth=c('norm'),set.seed=7) # Bayesian linear regression
complete(imp)


