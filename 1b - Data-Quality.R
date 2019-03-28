################################################################################
# Cricket Health Technical Assessment
# Medicare Claims Analysis
# Data Quality analysis file for verifying assumptions and examining data structure
################################################################################
source(here::here("Cricket-Health-Technical-Assessment", "0 - Config.R"))

################################################################################
# Import cleaned data
################################################################################

beneficiary_combined = read_rds(path = beneficiary_combined_path)
beneficiary_claims = read_rds(path = merged_data_path)

################################################################################
# Examine Data Quality of Cleaned Datsets
################################################################################

# Q: Are there any repeat entries for beneficiaries in our original unmerged yearly beneficiary datasets?
# A: Nope
beneficiary_combined %>%
  group_by(year) %>%
  summarize(
    "total_recorded_beneficiaries" = n(),
    "unique_recorded_beneficiares" = beneficiary_id %>% unique %>% length
  )

# Q: Do any beneficiaries have a death date prior to the year in which they were a beneficiary?
# A: Nope
beneficiary_combined %>% 
  filter(
    (year == 2008 & death_date < ymd(20080101)) |
    (year == 2009 & death_date < ymd(20090101)) |
    (year == 2010 & death_date < ymd(20100101))
  )

# Do any beneficiaries have a death date prior to their listed birth date?
# A: Nope
beneficiary_combined %>% filter(birth_date >= death_date)

# Do any beneficiaries have an anomalous age (i.e. before its possible to become Medicare eligible or longer than the span on a typical human life?)
# A: Ah. So one thing I forgot is that folks on disability or those with ESRD (https://www.medicareinteractive.org/get-answers/medicare-basics/medicare-eligibility-overview/medicare-eligibility-for-those-under-65) become eligible for Medicare too (I mistakenly had thought it was Medicaid that covered them). Still, looks like a pretty valid age histogram for Medicare recipients, though I'm super surprised at the number of below 65 folks
ages_added = beneficiary_combined %>% 
  mutate(age = time_length(interval(start = birth_date, end = ymd(20080101)), unit = "year")) %>% 
  arrange(age)

qplot(x = age, data = ages_added, geom = "histogram")

# Q: What is the proportion of people under 65 on Medicare who have ESRD is, compared to the overall proportion in the population?
# A: Interesting... I would've thought that the under 65 population would have a much larger proportion of ESRD patients given that its one of the criteria required to become eligible for Medicare. This is fake data so its possible (and even likely) that this column was randomly permuted, which would explain the lack of heterogeneity between the two groups
ages_added %>%
  mutate(
    "under_65" = age < 65,
    "esrd" = str_replace(
      string = esrd,
      pattern = "Y",
      replacement = "1"
    ) %>% as.numeric
  ) %>%
  group_by(under_65) %>%
  summarize("esrd_proportion" = mean(esrd))

# Are there instances of negative Medicare reimbursement payments?
# A: So... this is a little weird. There are around 300,000 rows using our most inclusive criteria with negative claim payments. One thing I immediately noticed was that there are some instances of the gross_drug_cost being lower than the patient_cost, and this turned our claim_payment_amount for some prescription drug claims (claim_payment_amount = gross_drug_cost - patient_cost) negative in some cases. This is also weird, but I may just be missing some nuance in the data or it could be the result of the data synthesizers randomly permuting values in those two columns. Using less selective criteria that ignores prescription drug claims, the number of negative claim_payment_ammounts falls to around ~6500 cases, which is still a bit weird (reasons are included in the documentation), but far less worrying given the size of the data.
beneficiary_claims %>%
  filter(
    inpatient_reimbursement < 0 |
      outpatient_reimbursement < 0 |
      claim_payment_amount < 0 |
      gross_drug_cost < 0 | 
      patient_cost < 0
  ) %>% 
  select(
    inpatient_reimbursement,
    outpatient_reimbursement,
    claim_payment_amount,
    gross_drug_cost,
    patient_cost
  )

# Ignoring prescription drug claims
beneficiary_claims %>% 
  filter(
    inpatient_reimbursement < 0 |
      outpatient_reimbursement < 0 |
      (claim_payment_amount < 0 & is.na(gross_drug_cost) & is.na(patient_cost))
  ) %>% 
  select(
    inpatient_reimbursement,
    outpatient_reimbursement,
    claim_payment_amount,
    gross_drug_cost,
    patient_cost
  )

################################################################################
# Generate PDF Report of this script for later review of results
################################################################################

# NOTE: A report of this script has been generated and left in the Reports directory
