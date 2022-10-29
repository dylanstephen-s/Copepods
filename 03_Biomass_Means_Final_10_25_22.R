### 10/25/22
##  I'm taking this code below and using the Rdata file, volbio_all_no0.Rdata as the source
## file, because it was recently updated and includes all the necesarry columns. Also trying
##  to streamline all the crazy amounts of scripts I have

### 9/2/22
###  This code is for calculating the total counts of each
##   organism and the mean biomass per organism/sample.
##   Uses bmass_final_exp  (biomass for everything EXCEPT site water samples)
##   from Biomass_All_Final.R. It contains all the columns needed for
##  nearly all the calculations (18). This is the cleaned up version 
##   originally written in Bmass_Mn_Ct.R, which contains lots of notes.


library(tidyverse)
library(readxl)
library(writexl)


load("volbio_all_no0.Rdata")
names(volbio_all_no0)

## Calculate total counts of specific organism per sample 
##  (i.e., SJR1 FC centric diatom 24.5 x 24.5)
count_sum_rep_fin <- volbio_all_no0 %>% 
  group_by(samp_date, samp_ev, exp, Group, type, sa, la, wi)%>% 
  summarize(tot_ct = sum(counts)) %>% 
  ungroup()
#write_xlsx(count_sum_rep, "count_sum_rep.xlsx")

## Calculate the mean biomass of specific organism per sample 
##  (i.e., SJR1 FC centric diatom 24.5 x 24.5)

bmean_rep_fin <- volbio_all_no0 %>% 
  group_by(samp_date, samp_ev, exp, Group, type, sa, la, wi)%>% 
  summarize(bmn_pgml = mean(bio_per_vol_pgc_ml)) %>% 
  ungroup()

## Format the biomass column so that it has no decimal places

library(formattable) #found here https://www.tutorialspoint.com/how-to-format-all-decimal-places-in-an-r-vector-and-data-frame
bmean_rep_fin$bmn_pgml<-formattable(bmean_rep_fin$bmn_pgml,format="f",digits=0)
#write_xlsx(bmean_rep, "bmean_rep.xlsx")

##  Left_join to join the two data frames so that both total
##   counts and mean biomass are on the same data frame

ct_bmn_fin <- left_join(count_sum_rep_fin, bmean_rep_fin)
save(ct_bmn_fin, file = "data/ct_bmn_fin.Rdata")
write_xlsx(ct_bmn_fin, "ct_bmn_fin.xlsx")

## Format the biomass column so that it has no decimal places
## Note: this seemed to change the format it was shown in, but when
## saving as an excel doc, it showed many decimal places, so I
## just changed the decimal places on that column. So I'm not sure
## this is the best function for this.


## Combine group, type, sa, la, wi, into one column and call it "category"
ct_bmn_fin$category <- paste(ct_bmn_fin$Group, ct_bmn_fin$type,
                             ct_bmn_fin$sa, ct_bmn_fin$la)

### Get rid of the columns I no longer need and order the columns
all_sta_categories <- select(ct_bmn_fin, -Group, -type, -sa, -la, -wi) %>% 
  select(samp_ev, exp, category, tot_ct, bmn_pgml)
save(all_sta_categories,  file = "all_sta_categories")
load("all_sta_categories")
write_xlsx(all_sta_categories, "all_sta_categories.xlsx")

## Make a file with just one station
sjr1_categories <- all_sta_categories %>% 
  filter(samp_ev == "SJR1")
## Get a list of all the unique organism categories
unique(sjr1_categories$category)

## Ciliates only, just for fun
sjr1_cil <- sjr1_categories %>% 
  filter(grepl("ciliate", category))

#save(sjr1_categories, file = "sjr1_categories")
#write_xlsx(sjr1_categories, "sjr1_categories.xlsx")




