################################################################################
# Cricket Health Technical Assessment
# Medicare Claims Analysis
# Data Management file for raw dataset import, cleaning, and export
################################################################################
source(here::here("Cricket-Health-Technical-Assessment", "0 - Config.R"))

################################################################################
# Import CMS data
################################################################################

beneficiary_2008          = read_csv(file = beneficiary_2008_path)
beneficiary_2009          = read_csv(file = beneficiary_2009_path)
beneficiary_2010          = read_csv(file = beneficiary_2010_path)
inpatient_2008_to_2010    = read_csv(file = inpatient_2008_to_2010_path)
outpatient_2008_to_2010   = read_csv(file = outpatient_2008_to_2010_path)
prescription_2008_to_2010 = read_csv(file = prescription_2008_to_2010_path)

################################################################################
# Merge, clean and subset data to what is relevant to analysis
################################################################################


################################################################################
# Export cleaned data
################################################################################

