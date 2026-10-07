################################################################################
# Organization - WHO LAB
# Project - K01 Aim 1: Surface level PFAS exposure map
# Jordan Fischbach, Dr. Cindy Hu
# This file imports UCMR3 and UCMR5 data and conducts manipulation, cleaning, and characterization
################################################################################
source(here::here("R/0-config.R")) #??? why source config file at beginning of scripts???
################################################################################
# Import UCMR3 data and filter to only PFAS contaminants data 
################################################################################

# Import UCMR3 data and filter for PFAS contaminants
ucmr3 =  fread(file = here("data", "ucmr3", "UCMR3_All.txt")) %>% 
  filter(
    Contaminant %in% pfas
    )

################################################################################
# Investigate UCMR3 data
################################################################################
# Does each PWS facility have a reading each year for each PFAS? 
  # Filter by individual PWS facility for unique readings of PFAS per year
pws_check <- ucmr3 %>%
  mutate(
    year = as.numeric(
      substr(
        CollectionDate, nchar(CollectionDate) - 3, nchar(CollectionDate)
      ))) %>%
  mutate(
    PWSID_FID = paste0(PWSID, "_", FacilityID)
  ) %>%
  distinct(
    PWSID_FID, Contaminant, year
  ) %>%
  count(
    PWSID_FID,
    name = "n_pfas_sampled_in_3_yrs"
  )

# Check distribution of unique yearly readings
hist(pws_check$n_pfas_sampled_in_3_yrs)

# Check n facilities with more than 2 unique years of data
pws_outlier <- pws_check %>% 
  filter(
    !(n_pfas_sampled_in_3_yrs %in% c(6, 12))
  )

# n NAs 
nas <- ucmr3 %>% 
  count(is.na(AnalyticalResultValue))

################################################################################
# Average values - 
################################################################################



################################################################################
# Add zip codes
################################################################################
# Join ZIP codes by 
ucmr3_zip = fread(file = here("data", "ucmr3", "UCMR3_ZIPCodes.txt"))

# WRONG - multiple ZIP for each PWS
ucmr3 = ucmr3 %>% 
  left_join(
    ucmr3,
    ucmr3_zip,
    by = "PWSID"
    )

