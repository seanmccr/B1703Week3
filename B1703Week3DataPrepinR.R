# ----- B1703 Week 3 | Data Preparation in R | 31.01.2024 -----

# ----- 1. Loading libraries and datasets -----
library(tibble)
library(tidyr)

Athlete_events <- as.tibble(read.csv("/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/Practical 2&3 Files/athlete_events2.csv"))

NOC_region <- as.tibble(read.csv("/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/Practical 2&3 Files/noc_regions.csv"))

Population <- as.tibble(read.csv("/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/Practical 2&3 Files/world_pop.csv", check.names=FALSE))

# ----- 2. Long Format Data Pivot -----

Population<-Population[,c(-3,-4)]
Population<-Population %>%
  pivot_longer(cols=c(3:59),
               names_to='Year',
               values_to="Population")


