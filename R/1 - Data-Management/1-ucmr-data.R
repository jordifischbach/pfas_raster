################################################################################
# Organization - WHO LAB
# Project - K01 Aim 1: Surface level PFAS exposure map
# Jordan Fischbach, Dr. Cindy Hu
# 2013-2015 UCMR3 and UCMR5 PFAS data management file for import and cleaning
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
# Does each PWS have a reading each year for each PFAS
pws_check <- ucmr3 %>% 
  mutate(
    year = as.numeric(substr(
      CollectionDate,
      nchar(CollectionDate)-3,
      nchar(CollectionDate)))
    ) %>% 
  distinct(
    PWSID, Contaminant, year
    ) %>% 
  count(
    PWSID, 
    name = "n_pfas_sampled_in_3_yrs"
  )

################################################################################
# Add zip codes
################################################################################
# Join ZIP codes by 
ucmr3_zip = fread(file = here("data", "ucmr3", "UCMR3_ZIPCodes.txt"))

ucmr3 = ucmr3 %>% 
  left_join(
    ucmr3,
    ucmr3_zip,
    by = "PWSID"
    )

