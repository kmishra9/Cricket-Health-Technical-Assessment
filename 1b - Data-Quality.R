################################################################################
# Cricket Health Technical Assessment
# Medicare Claims Analysis
# Data Quality analysis file for verifying assumptions and examining data structure
################################################################################
source(here::here("Cricket-Health-Technical-Assessment", "0 - Config.R"))

################################################################################
# Import cleaned data
################################################################################



################################################################################
# Examine Data Quality of Cleaned Datsets
################################################################################

# Q: Are there any repeat entries for beneficiaries?
# A: 

# Assert that unique length and non unique length are the same


# Q: Do any beneficiaries have a death date prior to the year in which they were a beneficiary?
# A: 

# Do any beneficiaries have a death date prior to their listed birth date?
# A: 

# Are all listed Medicare beneficiaries of an appropriate age to be eligible + still alive?
# A:

# Are there instances of negative reimbursement payments?
# A:

################################################################################
# Make any further adjustments based on results
################################################################################

################################################################################
# Export cleaned data
################################################################################
