library(tidyverse)
library(readxl)
library(lubridate)
library(DT)

# ideally, write code to download the following rather than just referring to local copy

# the following would go in the download script

urls <- c("https://www.waterboards.ca.gov/water_issues/programs/hr2w/docs/data/hr2w_web_data_active.xlsx",
          "https://www.waterboards.ca.gov/water_issues/programs/hr2w/docs/data/hr2w_web_data_rtc.xlsx")
temp1 <- temp2 <- tempfile()
download.file(urls[1], temp1)
download.file(urls[2], temp2)
out_of_compliance <- read_excel(temp1)
return_to_compliance <- read_excel(temp2)

# the following would go psid_params, replacing the fixed instance '0310011' with params$psid

rtc <- filter(return_to_compliance, grepl('0310011', WATER_SYSTEM_NUMBER)) # grepl returns TRUE if found
ooc <- filter(out_of_compliance, grepl('0310011', WATER_SYSTEM_NUMBER)) 
data <- rbind(rtc, ooc)
# data[c('VIOL_BEGIN_DATE', 'VIOL_END_DATE', 'ENF_ACTION_TYPE_ISSUED')]
data %>% 
  select(VIOL_BEGIN_DATE, VIOL_END_DATE, ENF_ACTION_TYPE_ISSUED) %>% 
  mutate(VIOL_BEGIN_DATE = ymd(VIOL_BEGIN_DATE)) %>% 
  mutate(VIOL_END_DATE = ymd(VIOL_END_DATE)) %>% 
  datatable(., colnames = c('Begin Date', 'End Date', 'Action Taken'))



