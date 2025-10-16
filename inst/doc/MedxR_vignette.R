## ----include = FALSE--------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  echo = TRUE,
  message = FALSE,
  warning = FALSE
)

# Save original user options
old_options <- options(
  width = 150,
  tibble.width = Inf,
  pillar.width = Inf
)


## ----setup------------------------------------------------------------------------------------------------------------------------------------------
library(MedxR)
library(ggplot2)
library(dplyr)

## ----fda-adverse-events-----------------------------------------------------------------------------------------------------------------------------


aspirin_adverse_event <- get_fda_adverse_events("aspirin")
aspirin_adverse_event %>% 
  select(report_id, date_received, country, serious, patient_sex) %>%
  head(6)


## ----fda-approved-drugs-----------------------------------------------------------------------------------------------------------------------------

lipitor_drugs_approved <- get_fda_drugs_approved("lipitor")
lipitor_drugs_approved %>% 
  select(application_number, brand, generic, approval_date, strength, form)


## ----health-canada-din------------------------------------------------------------------------------------------------------------------------------

hc_drug_din <- get_hc_drug_by_din("00000213")
hc_drug_din %>% 
  select(drug_code, class_name, din, brand_name, company_name)


## ----health-canada-products-companies, message=FALSE, warning=FALSE, fig.width=10, fig.height=5-----------------------------------------------------

# Retrieve data from Health Canada APIs
drug_products <- get_hc_drug_products()
companies <- get_hc_companies()

# Combine both datasets by company name
merged_data <- drug_products %>%
  left_join(companies, by = "company_name") %>%
  filter(!is.na(company_name)) %>%
  group_by(company_name) %>%
  summarise(total_products = n()) %>%
  arrange(desc(total_products)) %>%
  slice_head(n = 10)

# Plot: Top 10 companies by number of registered drug products
ggplot(merged_data, aes(x = reorder(company_name, total_products), y = total_products)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(
    title = "Top 10 Canadian Companies by Number of Registered Drug Products",
    x = "Company Name",
    y = "Number of Drug Products",
    caption = "Source: Health Canada Drug Product Database (via MedxR)"
  ) +
  theme_minimal(base_size = 13)


## ----cleanup, include = FALSE-------------------------------------------------
# Restore original user options

options(old_options)


