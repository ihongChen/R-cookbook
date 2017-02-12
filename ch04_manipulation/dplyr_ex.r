## dplyr ###

url <- "https://raw.githubusercontent.com/genomicsclass/dagdata/master/inst/extdata/msleep_ggplot2.csv"
download.file(url,'msleep_ggplot2.csv')

msleep = read.csv('msleep_ggplot2.csv')
head(msleep)

library(dplyr)
sleepData = select(msleep,name,sleep_total)
head(sleepData)

head(select(msleep,-name))

head(select(msleep,name:order))
head(select(msleep,starts_with("sl")))


filter(msleep,sleep_total>=16)
filter(msleep,sleep_total>=16,bodywt>=1)
head(msleep)
filter(msleep, order %in% c('Prissodactyla','Primates'))

msleep %>%
  select(name,order,sleep_total) %>%
  arrange(order,sleep_total) %>%
  filter(sleep_total>=16) %>%
  head()


msleep %>%
  mutate(rem_proportion = sleep_rem/sleep_total) %>%
  head

msleep %>%
  summarise(avg_sleep=mean(sleep_total),
            min_sleep=min(sleep_total),
            max_sleep=max(sleep_total),
            total = n())

msleep %>%
  group_by(order) %>%
  summarise(avg_sleep=mean(sleep_total),
            min_sleep=min(sleep_total),
            max_sleep=max(sleep_total),
            total = n())

### 
library("nycflights13")
sample_n(flights,10)
head(flights)

filter(flights,month==1,day==2)
target = filter(flights,dep_delay>0)
nrow(target)

?grepl

filter(flights,grepl(pattern="AA",x=tailnum,fix=T)) %>%
  select(tailnum)

slice(flights,1:6)
slice(flights,100:200)

arrange(flights,month,day,dep_time)
min(flights$dep_time,na.rm=T)

arrange(flights,month,day,desc(dep_time))

colnames(flights)

select(flights,-(year:day))

flights %>%
  filter(is.na(dep_time)) %>%
  select(year:day)

flights %>%
  select(year:day) %>%
  distinct

flights %>%
  mutate(gain=arr_delay-dep_delay) %>%
  select(gain)

sample_n(flights,10)
sample_frac(flights,0.01)

## 算出一月份平均gain值(gain=arr_dely-dep_delay)
filter(flights,month==1) %>%
  mutate(gain=arr_delay-dep_delay) %>%
  summarise(mean(gain,na.rm=T)) %>%
  `[[`(1)

## carrier為AA的飛機是否tailnum都有AA?
flights %>%
  filter(carrier=="AA",!grepl("AA",tailnum)) %>%
  select(carrier,tailnum) %>%
  View
  # nrow
  
## dep_time介於2301~2400之間的平均dep_delay為何?
flights %>%
  filter(2301<=dep_time,dep_time<=2400) %>%
  summarise(mean(dep_delay),na.rm=T) %>%
  `[[`(1)

##
df = group_by(flights,month)

df %>%
  mutate(gain=arr_delay-dep_delay) %>%
  summarise(monthly_mean = mean(gain,na.rm=T))
##
