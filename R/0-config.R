################################################################################
# Organization - WHO LAB
# Project - K01 Aim 1: Surface level PFAS exposure map
# Jordan Fischbach, Dr. Cindy Hu
# Configuration file for setup and filepath specification
################################################################################
#restore r environment
renv::restore()
################################################################################

# Load libraries
library(here)
library(renv)

library(tidyverse)
library(data.table)

#global variables
pfas <- c("PFBS","PFHpA","PFHxS","PFNA","PFOS","PFOA")





