################################################################################
# Cricket Health Technical Assessment
# Medicare Claims Analysis
# Configuration file for setup and filepath specification
################################################################################

# Load libraries
library(tidyverse)
library(assertthat)
library(DataExplorer)
library(lubridate)
library(here)

# File paths
project_dir                    = here("Cricket-Health-Technical-Assessment/")
data_dir                       = here("..", "Individual Projects - Data", "Cricket-Health-Data/")

reports_dir                    = paste(project_dir, "EDA Reports/")

# Raw Dataset Paths
beneficiary_2008_path          = paste0(data_dir, "1.1-DE1_0_2008_Beneficiary_Summary_File_Sample_1.csv")
beneficiary_2009_path          = paste0(data_dir, "1.2-DE1_0_2009_Beneficiary_Summary_File_Sample_1.csv")
beneficiary_2010_path          = paste0(data_dir, "1.3-DE1_0_2010_Beneficiary_Summary_File_Sample_1.csv")

inpatient_2008_to_2010_path    = paste0(data_dir, "1.4-DE1_0_2008_to_2010_Inpatient_Claims_Sample_1.csv")
outpatient_2008_to_2010_path   = paste0(data_dir, "1.5-DE1_0_2008_to_2010_Outpatient_Claims_Sample_1.csv")
prescription_2008_to_2010_path = paste0(data_dir, "1.6-DE1_0_2008_to_2010_Prescription_Drug_Events_Sample_1.csv")

# Merged and Cleaned Dataset Paths
beneficiary_combined_path      = paste0(data_dir, "2.1-Beneficiary_2008_to_2010_Sample1.RDS")
inpatient_claims_path          = paste0(data_dir, "2.2-Inpatient_Claims_2008_to_2010_Sample1.RDS")
outpatient_claims_path         = paste0(data_dir, "2.3-Outpatient_Claims_2008_to_2010_Sample1.RDS")
prescription_claims_path       = paste0(data_dir, "2.4-Prescription_Claims_2008_to_2010_Sample1.RDS")
all_claims_path                = paste0(data_dir, "2.5-All_Claims_2008_to_2010_Sample1.RDS")
merged_data_path               = paste0(data_dir, "2.6-Beneficiary_Claims_2008_to_2010_Sample1.RDS")
