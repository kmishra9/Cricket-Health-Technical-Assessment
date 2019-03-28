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
# Clean and subset data to what is relevant to analysis
################################################################################

# Combine beneficiary data as single dataset, keyed on (beneficiary_id, year)
beneficiary_2008 = beneficiary_2008 %>% mutate("year" = 2008)
beneficiary_2009 = beneficiary_2009 %>% mutate("year" = 2009)
beneficiary_2010 = beneficiary_2010 %>% mutate("year" = 2010)
beneficiary_combined = bind_rows(beneficiary_2008, beneficiary_2009, beneficiary_2010)

# Limit all data sets to only relevant columns and update column types
beneficiary_combined_limited = beneficiary_combined %>% 
  select(
    "beneficiary_id"           = DESYNPUF_ID,
    "birth_date"               = BENE_BIRTH_DT,
    "death_date"               = BENE_DEATH_DT,
    "sex"                      = BENE_SEX_IDENT_CD,
    "race"                     = BENE_RACE_CD,
    "esrd"                     = BENE_ESRD_IND,
    "state"                    = SP_STATE_CODE, 
    "county"                   = BENE_COUNTY_CD,
    "plan_d_coverage_length"   = PLAN_CVRG_MOS_NUM,
    "inpatient_reimbursement"  = MEDREIMB_IP,
    "outpatient_reimbursement" = MEDREIMB_OP,
    year
  ) %>%
  mutate(
    "birth_date"               = ymd(birth_date),
    "death_date"               = ymd(death_date)
  )

inpatient_2008_to_2010_limited = inpatient_2008_to_2010 %>%
  select(
    "beneficiary_id"       = DESYNPUF_ID,
    "provider_id"          = PRVDR_NUM,
    "claim_id"             = CLM_ID,
    "claim_start_date"     = CLM_FROM_DT,
    "claim_end_date"       = CLM_THRU_DT,
    "claim_payment_amount" = CLM_PMT_AMT
  ) %>%
  mutate(
    "claim_start_date"     = ymd(claim_start_date),
    "claim_end_date"       = ymd(claim_end_date),
    "year"                 = year(claim_end_date)
  )

outpatient_2008_to_2010_limited = outpatient_2008_to_2010 %>% 
  select(
    "beneficiary_id"       = DESYNPUF_ID,
    "provider_id"          = PRVDR_NUM,
    "claim_id"             = CLM_ID,
    "claim_start_date"     = CLM_FROM_DT,
    "claim_end_date"       = CLM_THRU_DT,
    "claim_payment_amount" = CLM_PMT_AMT
  ) %>%
  mutate(
    "claim_start_date"     = ymd(claim_start_date),
    "claim_end_date"       = ymd(claim_end_date),
    "year"                 = year(claim_end_date)
  )

prescription_2008_to_2010_limited = prescription_2008_to_2010 %>% 
  select(
    "beneficiary_id"       = DESYNPUF_ID,
    "product_id"           = PROD_SRVC_ID,
    "service_date"         = SRVC_DT,
    "gross_drug_cost"      = TOT_RX_CST_AMT,
    "patient_cost"         = PTNT_PAY_AMT
  ) %>% 
  mutate(
    "service_date" = ymd(service_date),
    "claim_payment_amount" = gross_drug_cost - patient_cost,
    "year"         = year(service_date)
  )

################################################################################
# Merge all data into one dataset
################################################################################

all_claims = bind_rows(
  inpatient_2008_to_2010_limited,
  outpatient_2008_to_2010_limited,
  prescription_2008_to_2010_limited
)

beneficiary_claims = beneficiary_combined_limited %>% 
  left_join(all_claims, by = c("beneficiary_id", "year"))

# Sanity check - Didn't lose any data
assert_that(beneficiary_claims %>% pull(beneficiary_id) %>% unique %>% length == 
              beneficiary_combined_limited %>% pull(beneficiary_id) %>% unique %>% length)

assert_that(beneficiary_combined_limited %>% nrow <= 
              beneficiary_claims %>% nrow)

# Some beneficiaries may not be associated with any claims and may thus add rows over all_claims
assert_that(all_claims %>% nrow <= beneficiary_claims %>% nrow)

################################################################################
# Export merged and limited datasets
################################################################################

write_rds(x = beneficiary_combined_limited, path = beneficiary_combined_path)
write_rds(x = inpatient_2008_to_2010_limited, path = inpatient_claims_path)
write_rds(x = outpatient_2008_to_2010_limited, path = outpatient_claims_path)
write_rds(x = prescription_2008_to_2010_limited, path = prescription_claims_path)

write_rds(x = all_claims, path = all_claims_path)
write_rds(x = beneficiary_claims, path = merged_data_path)

# At this point, each row of beneficiary_claims represents one of the three types of claims OR a beneficiary with no claims at all over the period 
