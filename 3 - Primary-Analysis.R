################################################################################
# Cricket Health Technical Assessment
# Medicare Claims Analysis
# Analysis file to answer and validate technical assessment questions
################################################################################
source(here::here("Cricket-Health-Technical-Assessment", "0 - Config.R"))

################################################################################
# Import cleaned data
################################################################################

beneficiary_claims = read_rds(path = merged_data_path)

################################################################################
# Question 1: Which state spends the most, and which state spends the least per ESRD patient (Combining inpatient, outpatient and RX drugs). Answer separately for 2008, 2009, and 2010?
################################################################################

medicare_spending_on_esrd_by_state = beneficiary_claims %>% 
  filter(esrd == "Y", claim_payment_amount >= 0) %>%
  group_by(year, state) %>% 
  summarize("total_esrd_costs" = sum(claim_payment_amount)) %>% 
  arrange(year, total_esrd_costs)

# 2008: most: 05 (spent: $8,642,950), least: 41 (spent: $92,020)
# 2009: most: 05 (spent: $8,799,100), least: 53 (spent: $41,020)
# 2010: most: 05 (spent: $3,947,640), least: 02 (spent: $29,380)

qplot(
  x = total_esrd_costs,
  data = medicare_spending_on_esrd_by_state,
  geom = "density",
  facets = . ~ year
)

# This faceted density plot indicates the esrd spending of states drastically compressed (somewhat resembling a poisson distribution) in 2010 after staying consistent from 2008 to 2009. Let's examine a longitudinal plot at the state level

qplot(x = year %>% as.factor, y = total_esrd_costs, group = state %>% as.factor, data = medicare_spending_on_esrd_by_state, geom = "line")

# This longitudinal spaghetti plot indicates many of the highest spending states saw dramatic reductions in esrd spending from 2009 to 2010, though their relative ordering remained similar. A final useful question would be to understand whether the *number* of esrd patients decreased, or if the *per capita spending* was responsible for the large downtick

esrd_patients_per_year = beneficiary_claims %>%
  filter(esrd == "Y", claim_payment_amount >= 0) %>%
  group_by(year) %>%
  summarize(
    "total_esrd_patients" = n(),
    "esrd_per_capita_spending" = sum(claim_payment_amount) / n()
  )

# So yes, it looks like our drop in spending in 2010 can be attributable to a large drop in the number of esrd patients making claims on medicare *and* decreasing per capita spending on the esrd patients who remained. This forces me to question the validity of our data as ESRD prevalence continued to grow (despite a slight decline in incidence) in 2010 nationally (https://www.niddk.nih.gov/health-information/health-statistics/kidney-disease)

################################################################################
# Question 2: What is the average amount spent per patient on claims that were initiated in the final 180 days of life? (Combining inpatient, outpatient and RX drugs
################################################################################

beneficiary_claims %>%
  filter(
    death_date - 180 < claim_start_date |
      death_date - 180 < service_date,
    claim_payment_amount >= 0
  ) %>%
  group_by(beneficiary_id) %>%
  summarize("medicare_spending_in_last_180_days" = sum(claim_payment_amount)) %>%
  summarize(
    "mean_per_capita_spending_in_last_180_days" = mean(medicare_spending_in_last_180_days)
  )

# Mean Per Capita Spending in last 180 days: $1948
# Limitations: calculations were made under the assumption that claim payment amounts < 0 were invalid 

# Has the per capita spending changed over time? 
end_of_life_spending_over_time = beneficiary_claims %>%
  filter(
    death_date - 180 < claim_start_date |
      death_date - 180 < service_date,
    claim_payment_amount >= 0
  ) %>%
  group_by(year, beneficiary_id) %>%
  summarize("medicare_spending_in_last_180_days" = sum(claim_payment_amount)) %>%
  summarize(
    "mean_per_capita_spending_in_last_180_days" = mean(medicare_spending_in_last_180_days)
  )

qplot(x = year, y = mean_per_capita_spending_in_last_180_days, data = end_of_life_spending_over_time, geom = "line")

# We again see drastically lower per capita spending in 2010 which doesn't make a whole lot of sense. One thing I'd be interested in examining is whether our dataset's spending in the last 180 days matches the proportion of their total medicare expenditures, which would be a defense for its validity (~25%, as stated by the KFF http://files.kff.org/attachment/Data-Note-Medicare-Spending-at-the-End-of-Life). If this proportion is drastically different from 25%, it is increasingly likely our data shouldn't be used to answer the questions we've asked here

end_of_life_beneficiary_spending = beneficiary_claims %>%
  filter(
    death_date - 180 < claim_start_date |
      death_date - 180 < service_date,
    claim_payment_amount >= 0
  ) %>%
  group_by(beneficiary_id) %>%
  summarize("medicare_spending_in_last_180_days" = sum(claim_payment_amount))

total_life_beneficiary_spending = beneficiary_claims %>%
  filter(claim_payment_amount >= 0) %>%
  group_by(beneficiary_id) %>%
  summarize("medicare_spending_in_life" = sum(claim_payment_amount))

merged_beneficiary_spending = end_of_life_beneficiary_spending %>% 
  left_join(total_life_beneficiary_spending) %>%
  filter(medicare_spending_in_life > 0) %>% 
  mutate("proportion_of_spending_in_last_180_days" = medicare_spending_in_last_180_days / medicare_spending_in_life)

merged_beneficiary_spending %>% 
  pull(proportion_of_spending_in_last_180_days) %>% 
  mean()

# The mean was 43.1% which is solid evidence that our data isn't very representive of reality (which we already knew) and not a great source of information for answering these questions. At this point its difficult to conclude why such a big drop occurred, and I think talking to a domain expert or researcher in this area about my results, why I might've observed what I did, and whether its still possible the data is valid or not would be the optimal next step 

################################################################################
# Generate PDF Report of this script for later review of results
################################################################################

# NOTE: A report of this script has been generated and left in the Reports directory
