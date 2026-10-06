################################################################################
# Organization - WHO LAB
# Project - K01 Aim 1: Surface level PFAS exposure map
# Jordan Fischbach, Dr. Cindy Hu
# 2013-2015 UCMR3 and UCMR5 PFAS data management file for import, cleaning, and charactarization
################################################################################

################################################################################
# Import UCMR3 data and filter to only PFAS contaminants data 
################################################################################

# Import UCMR3 data and filter for PFAS contaminants
ucmr3 =  fread(file = here("data", "ucmr3", "UCMR3_All.txt")) %>% 
  filter(
    Contaminant %in%  
      c("PFBS","PFHpA","PFHxS","PFNA","PFOS","PFOA")
    )

################################################################################
# Investigate UCMR3 data
################################################################################
# Does each PWS facility have a reading each year for each PFAS? 
  # Filter by PWS  for unique readings of PFAS per year
pws_check <- ucmr3 %>% 
  mutate(
    year = as.numeric(substr(
      CollectionDate,
      nchar(CollectionDate)-3,
      nchar(CollectionDate)))
    ) %>% 
  mutate(
    PWSID_FID = paste0(PWSID,"_",FacilityID) 
  ) %>% 
  distinct(
   PWSID_FID, Contaminant, year
    ) %>% 
  count(
    PWSID_FID, 
    name = "n_pfas_sampled_in_3_yrs"
  ) 

hist(pws_check$n_pfas_sampled_in_3_yrs)

pws_outlier <- pws_check %>% 
  filter(
    !(n_pfas_sampled_in_3_yrs %in% c(6, 12))
  )


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

