# Cricket-Health-Technical-Assessment
Technical Assessment for Healthcare Data Analyst Position @ Cricket Health

## Resources
- [Codebook](https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/SynPUF_Codebook.pdf)
- [FAQ](https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/Downloads/SynPUF_FAQ.pdf)
- [Data Source](https://www.cms.gov/Research-Statistics-Data-and-Systems/Downloadable-Public-Use-Files/SynPUFs/DESample01.html)

## Primary Analysis Questions
1. Which state spends the most, and which state spends the least per ESRD patient (Combining inpatient, outpatient and RX drugs). Answer separately for 2008, 2009, and 2010.
2. What is the average amount spent per patient on claims that were initiated in the final 180 days of life? (Combining inpatient, outpatient and RX drugs)

## Key Assumptions
- Claims with negative medicare reimbursement amounts were dropped, due to a lack of familiarity with the conventional method of working with this type of Medicare claims data
- Similarly, presription claims in which the amount the patient paid exceeded the gross cost of the drug (leading to a negative medicare reimbursement amount) were also dropped when answering Primary Analysis questions
- Question 2 refers to the average amount _spent by Medicare_

## Repository Structure & Results
Each file listed serves a discrete function, documented in the header of the file. Data flows from its raw sources through the scripts in sequential order. 

A slightly modified reproducible and interactive [RStudio environment](https://rstudio.cloud/project/285535) has been generated for this project, alongside the _cleaned_ data, enabling scripts `1b` and beyond to be run, simply by opening and sourcing them in the environment. For non-interactive examination of output, several crude PDF reports have been generated and placed in the `Reports/` directory. The `Reports` directory also contains the a `DataExplorer` EDA report generated using a small sample of the data (generating a report on the whole dataset would've taken several hours due to its size and so the EDA report is simply a taste of what that might look like).

Finally, [slides](https://docs.google.com/presentation/d/18Lsv_CyfEqEaCTqmR9nLoTF_VRgVahWOBf6XH3c6cTQ/edit?usp=sharing) walking through some of the results of the primary analysis have been published.
