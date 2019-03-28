################################################################################
# Cricket Health Technical Assessment
# Medicare Claims Analysis
# EDA file to stimulate hypothesis generation and understand pieces of the data
################################################################################
source(here::here("Cricket-Health-Technical-Assessment", "0 - Config.R"))

################################################################################
# Import cleaned data
################################################################################

# inpatient_2008_to_2010_limited = read_rds(path = inpatient_claims_path)
# outpatient_2008_to_2010_limited = read_rds(path = outpatient_claims_path)
# prescription_2008_to_2010_limited = read_rds(path = prescription_claims_path)
# 
# all_claims = read_rds(path = all_claims_path)

beneficiary_combined_limited = read_rds(path = beneficiary_combined_path)
beneficiary_claims = read_rds(path = merged_data_path)

################################################################################
# Generate EDA report of merged dataset
################################################################################

configure_report(add_plot_prcomp = NULL, plot_prcomp_args = NULL)

# This actually took forever to run because of how big the data is (and I'm on a supercomputer rn) so we'll report on a sample for now
create_report(data = beneficiary_claims %>% slice(1:nrow(beneficiary_claims) %>% sample(size = 10000)),
              output_file = "beneficiary_claims_report.html", 
              report_title = "Medicare Beneficiary Claims (2008-2010)")

################################################################################
# EDA on Specific Questions
################################################################################

# What proportion of beneficiaries are present over all three years? 
beneficiary_combined_limited %>%
  group_by(beneficiary_id) %>%
  summarize(present_three_years = n() == 3) %>%
  pull(present_three_years) %>%
  sum / (beneficiary_combined_limited %>% pull(beneficiary_id) %>% unique %>% length)

# What does the distribution of # of claims per beneficiary look like?
num_claims = beneficiary_claims %>% 
  group_by(beneficiary_id) %>% 
  summarize("number_of_claims" = n())

qplot(x = number_of_claims , data = num_claims, geom = "histogram")

# How much heterogeneity in the number of claims from year to year is there?
qplot(
  x = year,
  data = beneficiary_claims %>% filter(!is.na(claim_payment_amount)) %>% mutate("year" = as.factor(year)),
  geom = "bar"
)

# What proportion of beneficiaries are enrolled in part D? Over time, does this change? Is that at all related to the number of PDE claims?
beneficiary_combined_limited %>%
  filter(plan_d_coverage_length != "00") %>% nrow / (beneficiary_combined_limited %>% nrow)

beneficiary_combined_limited %>% 
  group_by(year) %>% 
  summarize("proportion_on_plan_d" = sum(plan_d_coverage_length != "00")/ n())
  
# More questions that I'd usually love to answer but I already have a feeling this is overkill

# Are the Medicare reimbursement amounts correlated with beneficiary responsibility amounts and/or the number of claims a beneficiary makes?

# Are longer claims correlated with larger payment amounts?

# What was the longest claim length for each type of claim (just curious)

# Is end stage renal disease correlated with increased claims?


