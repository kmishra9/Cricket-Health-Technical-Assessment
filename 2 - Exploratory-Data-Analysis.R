################################################################################
# Cricket Health Technical Assessment
# Medicare Claims Analysis
# EDA file to stimulate hypothesis generation and understand pieces of the data
################################################################################
source(here::here("Cricket-Health-Technical-Assessment", "0 - Config.R"))

################################################################################
# Import cleaned data
################################################################################

beneficiary_combined = read_rds(path = beneficiary_combined_path)
beneficiary_claims = read_rds(path = merged_data_path)

# How many beneficiaries are present over all three years? 
# Use the intersect function

# What does the distribution of # of claims per beneficiary look like?

# What does the distribution of claims per provider look like?

# How much heterogeneity in the number of claims from year to year is there? Faceting on type of claim per year?

# What proportion of beneficiaries are enrolled in part D? Over time, does this change, and is that at all related to the number of PDE claims

# Did Medicare beneficaries not enrolled in part D (i.e. PLAN_CVRG_MOS_NUM == 0 months)

# Are the Meidcare reimbursement amounts correlated with beneficiary responsibility amounts and/or the number of claims a beneficiary makes?

# Are longer claims correlated with larger payment amounts?

# What was the longest claim length for each type of claim (just curious)

# Is end stage renal disease (Cricket Health specific interest) correlated with increased claims?


