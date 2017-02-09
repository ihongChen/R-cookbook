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

