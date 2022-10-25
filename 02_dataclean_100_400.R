####################################################################
############ 100x AND 400X RAW DATA CLEANED FOR ANALYSIS ###########
####################################################################

### This script starts with the raw counts data, and prepares it to be able
#  to use for calculations such as volume, biomass, clearance rate, feeding
#  rate, etc.

library(tidyverse)
library(writexl)

### Load the excel csv data file. This is just the organism details, counts,
# and sampling event names. Later code will add the header that includes
# "samp_date"  "cnt_date" "sample" "pres_fact"  "vol_set_ml"
# "n_bugs"     "time_d" 

raw100 <- read_csv("data/100x_RawCount_R.csv")

#Convert to long format

raw100_long <- pivot_longer(data = raw100,
                            cols = c(9:68),
                            names_to = "sample",
                            values_to = "counts")

### Rearrange the column orders to have the station/sample column first, 
##  using the select function, and then change the NAs to 0s using the 
##  mutate function.

raw100_fin <- mutate(raw100_long, counts = ifelse(is.na(counts), 0, counts)) %>% 
  select(sample, Organism, Group, type, name, shp, sa, la, wi, counts)

# Add the headers column to include the other data, see above for names
headers_100 <- read_csv("data/100xHeaders.csv")
# join headers to raw100_fin
raw100_fin_hd <- left_join(raw100_fin, headers_100, by = "sample")
# Separate the sampling event names into three columns: sampling event, 
# experimental and replicate
### First, make a separate column for the sampling event 
raw100_sampev <- mutate(raw100_fin_hd, samp_ev = ifelse(grepl("SJR1", sample), "SJR1",
                                                 ifelse(grepl("WLD2", sample), "WLD2", 
                                                 ifelse(grepl("YBP1", sample), "YBP1",
                                                 ifelse(grepl("LSZ2", sample), "LSZ2",
                                                 ifelse(grepl("SJR2", sample), "SJR2",
                                                 ifelse(grepl("YBP2", sample), "YBP2", "??")))))))
# then, using the above file, make a separate column for the expriement type
raw100_exp <- mutate(raw100_sampev, exp = ifelse(grepl("site", sample), "site",
                                          ifelse(grepl("IC-1", sample), "IC-1",
                                          ifelse(grepl("IC-2", sample), "IC-2",
                                          ifelse(grepl("IC-3", sample), "IC-3",
                                          ifelse(grepl("FC-1", sample), "FC-1",
                                          ifelse(grepl("FC-2", sample), "FC-2",
                                          ifelse(grepl("FC-3", sample), "FC-3",
                                          ifelse(grepl("T24-1", sample), "T24-1",
                                          ifelse(grepl("T24-2", sample), "T24-2",
                                                                                                       ifelse(grepl("T24-3", sample), "T24-3","??")))))))))))
# Then using the above file, make a separate column for the replicate
# the N/A will be filled in where the experiment was "site" and there were
#  no replicates
raw100_rep <- mutate(raw100_exp, rep = ifelse(grepl("1", exp), "1",
                                     ifelse(grepl("2", exp), "2", 
                                     ifelse(grepl("3", exp), "3","N/A"))))
# Then, separate the expriement type from the replicate number
raw100_rep["exp"][raw100_rep["exp"] == "IC-1"] <- "IC"
raw100_rep["exp"][raw100_rep["exp"] == "IC-2"] <- "IC"
raw100_rep["exp"][raw100_rep["exp"] == "IC-3"] <- "IC"
raw100_rep["exp"][raw100_rep["exp"] == "FC-1"] <- "FC"
raw100_rep["exp"][raw100_rep["exp"] == "FC-2"] <- "FC"
raw100_rep["exp"][raw100_rep["exp"] == "FC-3"] <- "FC"
raw100_rep["exp"][raw100_rep["exp"] == "T24-1"] <- "T24"
raw100_rep["exp"][raw100_rep["exp"] == "T24-2"] <- "T24"
raw100_rep["exp"][raw100_rep["exp"] == "T24-3"] <- "T24"

## Reorder the columns and remove sample, Organism, name, count dates, n_bugs, time_d,
names(raw100_rep)
raw100_final <- subset(raw100_rep, select=c(11,17, 18, 19, 3, 4, 6, 7, 8, 9, 10, 13, 14))
## Correct the date format. See https://epirhandbook.com/en/working-with-dates.html
Sys.Date()
class(raw100_final$samp_date)
#bmass_final <- bmass_fin %>% 
raw100_final<- raw100_final %>% 
  mutate(samp_date = as.Date(samp_date, format ="%m/%d/%y"))
#class(bmass_fin_dt$samp_date)
#names(bmass_fin)
save(raw100_final, file = "data/raw100_final.Rdata")

### 10/17/22 Test to see if obs. number is 952 if I take out the zero counts
##  at this point instead of at the beginning like I did in 03_calcs_volume.R

#raw100final_test_no0_counts <- raw100_final %>% 
 # rowwise() %>% 
  #filter(counts != 0) 

###############################################################################
#################### REPEAT THE ABOVE FOR THE 400X RAW COUNTS ##################
###############################################################################

raw400 <- read_csv("data/400x_RawCount_R.csv")

#Convert to long format

raw400_long <- pivot_longer(data = raw400,
                            cols = c(9:68),
                            names_to = "sample",
                            values_to = "counts")

### Rearrange the column orders to have the station/sample column first, 
##  using the select function, and then change the NAs to 0s using the 
##  mutate function.

raw400_fin <- mutate(raw400_long, counts = ifelse(is.na(counts), 0, counts)) %>% 
  select(sample, Organism, Group, type, name, shp, sa, la, wi, counts)

# Add the headers column to include the other data, see above for names
headers_100 <- read_csv("data/100xHeaders.csv")
# join headers to raw400_fin
raw400_fin_hd <- left_join(raw400_fin, headers_100, by = "sample")
# Separate the sampling event names into three columns: sampling event, 
# experimental and replicate
### First, make a separate column for the sampling event 
raw400_sampev <- mutate(raw400_fin_hd, samp_ev = ifelse(grepl("SJR1", sample), "SJR1",
                                                ifelse(grepl("WLD2", sample), "WLD2", 
                                                ifelse(grepl("YBP1", sample), "YBP1",
                                                ifelse(grepl("LSZ2", sample), "LSZ2",
                                                ifelse(grepl("SJR2", sample), "SJR2",
                                                ifelse(grepl("YBP2", sample), "YBP2", "??")))))))
# then, using the above file, make a separate column for the experiment type
raw400_exp <- mutate(raw400_sampev, exp = ifelse(grepl("site", sample), "site",
                                          ifelse(grepl("IC-1", sample), "IC-1",
                                          ifelse(grepl("IC-2", sample), "IC-2",
                                          ifelse(grepl("IC-3", sample), "IC-3",
                                          ifelse(grepl("FC-1", sample), "FC-1",
                                          ifelse(grepl("FC-2", sample), "FC-2",
                                          ifelse(grepl("FC-3", sample), "FC-3",
                                          ifelse(grepl("T24-1", sample), "T24-1",
                                          ifelse(grepl("T24-2", sample), "T24-2",
                                          ifelse(grepl("T24-3", sample), "T24-3","??")))))))))))
# Then using the above file, make a separate column for the replicate
# the N/A will be filled in where the experiment was "site" and there were
#  no replicates
raw400_rep <- mutate(raw400_exp, rep = ifelse(grepl("1", exp), "1",
                                       ifelse(grepl("2", exp), "2", 
                                       ifelse(grepl("3", exp), "3","N/A"))))
# Then, separate the expriement type from the replicate number
raw400_rep["exp"][raw400_rep["exp"] == "IC-1"] <- "IC"
raw400_rep["exp"][raw400_rep["exp"] == "IC-2"] <- "IC"
raw400_rep["exp"][raw400_rep["exp"] == "IC-3"] <- "IC"
raw400_rep["exp"][raw400_rep["exp"] == "FC-1"] <- "FC"
raw400_rep["exp"][raw400_rep["exp"] == "FC-2"] <- "FC"
raw400_rep["exp"][raw400_rep["exp"] == "FC-3"] <- "FC"
raw400_rep["exp"][raw400_rep["exp"] == "T24-1"] <- "T24"
raw400_rep["exp"][raw400_rep["exp"] == "T24-2"] <- "T24"
raw400_rep["exp"][raw400_rep["exp"] == "T24-3"] <- "T24"

## Reorder the columns and remove sample, count dates, total volumes, total biomass
names(raw400_rep)
raw400_final <- subset(raw400_rep, select=c(11,17, 18, 19, 3, 4, 6, 7, 8, 9, 10, 13, 14))
## Correct the date format. See https://epirhandbook.com/en/working-with-dates.html
raw400_final<- raw400_final %>% 
  mutate(samp_date = as.Date(samp_date, format ="%m/%d/%y"))
#class(bmass_fin_dt$samp_date)
#names(bmass_fin)

save(raw400_final, file = "data/raw400_final.Rdata")

### 10/17/22 Test to see if obs. number is 952 if I take out the zero counts
##  at this point instead of at the beginning like I did in 03_calcs_volume.R

#raw400final_test_no0_counts <- raw400_final %>% 
  #rowwise() %>% 
  #filter(counts != 0) 
