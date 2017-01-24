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








