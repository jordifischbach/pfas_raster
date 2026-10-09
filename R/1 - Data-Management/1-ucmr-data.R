################################################################################
# Organization - WHO LAB
# Project - K01 Aim 1: Surface level PFAS exposure map
# Jordan Fischbach, Claude
# This file imports UCMR3 and UCMR5 data and conducts manipulation, cleaning, and characterization
################################################################################
source(here::here("R/0-config.R")) #??? why source config file at beginning of scripts???

################################################################################
# Investigate UCMR data 
################################################################################
# Does each PWS facility have a reading each year for each PFAS? A: No.
## Filter by individual PWS facility for unique readings of PFAS per year
### UCMR3
check3 <- ucmr3 %>%
  mutate(
    year = year(mdy(CollectionDate))
      ) %>%
  mutate(
    PWSID_FID = paste0(PWSID, "_", FacilityID)
  ) %>%
  distinct(
    PWSID_FID, Contaminant, year
  ) %>%
  count(
    PWSID_FID,
    name = "ucmr3_n_pfas_sampled_in_3_yrs"
    )

#### Check distribution of unique yearly readings
hist(check3$n_pfas_sampled_in_3_yrs)

#### Check n facilities with more than 2 unique years of data
outlier3 <- check3 %>% 
  filter(
    !(ucmr3_n_pfas_sampled_in_3_yrs %in% c(6, 12))
  )

#### n NAs 
nas <- ucmr3 %>% 
  group_by(Contaminant) %>% 
  count(is.na(AnalyticalResultValue))

### UCMR5
check5 <- ucmr5 %>%
  mutate(
    year = year(mdy(CollectionDate))
  ) %>%
  mutate(
    PWSID_FID = paste0(PWSID, "_", FacilityID)
  ) %>%
  distinct(
    PWSID_FID, Contaminant, year
  ) %>%
  count(
    PWSID_FID,
    name = "ucmr5_n_pfas_sampled_in_3_yrs"
  )

#### Check distribution of unique yearly readings
hist(check5$ucmr5_n_pfas_sampled_in_3_yrs)

#### Check n facilities with more than 2 unique years of data
outlier5 <- check5 %>% 
  filter(
    !(ucmr5_n_pfas_sampled_in_3_yrs %in% c(29, 58))
  )

#### n NAs 
nas <- ucmr5 %>% 
  group_by(Contaminant) %>% 
  count(is.na(AnalyticalResultValue))

################################################################################
# Average values for each facility, then average for each PWS
################################################################################
# Impute NA values as DL/sqrt 2 (Hu 2021 - Table 1)
## Create table of MRL/√2 values for each PFAS
DL <- tibble(
  pfas = pfas,
  mrl  = c(0.09, 0.01, 0.03, 0.02, 0.02, 0.04)
) %>% 
  mutate(
    "mrlrt2" = mrl / sqrt(2))

## Impute mrl/√2 for NAs
ucmr3_imp <- ucmr3 %>%  
  left_join(
    DL, by = c("Contaminant"="pfas")) %>%
  mutate(
    na = is.na(AnalyticalResultValue),
    AnalyticalResultValue = (if_else(
      na, mrlrt2, AnalyticalResultValue))) %>% 
  select(-MRL)
## check if impute correct - n values near "mcl/√2" for each PFAS, compare to "nas"
mclrt2 <- ucmr3_imp %>% 
  count(
    Contaminant, near(AnalyticalResultValue, mrlrt2))


# Average values for each facility 
ucmr3_imp <- ucmr3_imp %>% 
  

  
  







