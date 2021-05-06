# ------------------------------------------
# Cleaning experiment
# Hamadi Mwamlavya, Ewout Knoester
# Created 24-Mar-2021
# ------------------------------------------

# Set R and packages
rm(list=ls()) # Clear workspace
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) #Set directory at current directory

library(readxl) # Import excel sheets
library(openxlsx) # Create excel sheets
library(tidyverse) # tidy data
library(panelr) # Convert data from wide to long

# Import excel sheet
raw.data <- read_excel("cleaning_exp.xlsx", sheet = "RAW DATA")

# Insert new columns 'Treatment, Size, Cause_death.S1 & s_g_r.S1
raw.data.1 <- as.data.frame(append(raw.data,list(Treatment = "",Size = ""),after = 7))
raw.data.1 <- as.data.frame(append(raw.data.1,
                                   list(Cause_death.S1 = "",s_g_r.S1 = ""),after = 14))

# Fill in the newly created variable 'Size' with conditional values from 'Length'
raw.data.1$Size <- ifelse(
  raw.data.1$Length.S1 < 3.4, "Small",
  ifelse(raw.data.1$Length.S1 < 6.4, "Medium","Large"))

# Fill in the newly created variable 'Treatment' with conditional values from 'Structure'
# There's need to identify the control group i.e. trees with no cleaning

raw.data.1$Treatment <- ifelse(
  raw.data.1$Structure %in% c("Tree 095", "Tree 089","Tree 079"),"Weekly",
  ifelse(raw.data.1$Structure %in% c("Tree 092", "Tree 093", "Tree 088"), "Monthly",
         ifelse(raw.data.1$Structure %in% c("Tree 099", "Tree 098", "Tree 094"), "Quarterly","Never")))

# Convert to dataframe for use with dplyr
raw.data.2 <- as.data.frame(
  long_panel(raw.data.1, prefix = ".S", begin = 1, end = 7, label_location = "end"))

# Drop some columns

clean.data <- raw.data.2 %>%
  select(-c("Origin","Batch", "Select","Alive","Condition","Comments")) 

# Create a new excel sheet

write.xlsx(clean.data, file = "clean_data.xlsx",
           sheetName = "cleaning_exp", append = FALSE)


