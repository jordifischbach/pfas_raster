################################################################################
# Organization - WHO LAB
# Project - K01 Aim 1: Surface level PFAS exposure map
# Jordan Fischbach, Dr. Cindy Hu
# 2013-2015 UCMR3 and UCMR5 PFAS data management file for import and cleaning
################################################################################

################################################################################
# Import UCMR3 data and filter to only PFAS contaminants data and add zip codes
################################################################################

# Import UCMR3 data and filter for PFAS contaminants
ucmr3 =  fread(file = here("data", "ucmr3", "UCMR3_All.txt")) %>% 
  filter(
    Contaminant %in%  
      c("PFBS","PFHpA","PFHxS","PFNA","PFOS","PFOA")
    )

# Join ZIP codes by 
ucmr3_zip = fread(file = here("data", "ucmr3", "UCMR3_ZIPCodes.txt"))

ucmr3_spatial = ucmr3 %>% 
  left_join(
    ucmr3_zip,
    by = "PWSID"
    )