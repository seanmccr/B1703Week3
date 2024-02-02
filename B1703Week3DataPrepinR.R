# ----- B1703 Week 3 | Data Preparation in R | 31.01.2024 -----

# ----- 1. Loading libraries and datasets -----
library(tibble)
library(tidyr)
library(dplyr)

Athlete_events <- as.tibble(read.csv("/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/Practical 2&3 Files/athlete_events2.csv"))

NOC_region <- as.tibble(read.csv("/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/Practical 2&3 Files/noc_regions.csv"))

Population <- as.tibble(read.csv("/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/Practical 2&3 Files/world_pop.csv", check.names=FALSE))

# ----- 2. Long Format Data Pivot -----
# Code to pivot data, removing variables unwanted and showing the first 10 rows of our Athlete_events dataset
Population<-Population[,c(-3,-4)]
Population<-Population %>%
  pivot_longer(cols=c(3:59),
               names_to='Year',
               values_to="Population")

head(Athlete_events, 10)

# ----- 3. Data Cleaning -----
# Seeing where our NA values are registering
colSums(is.na(Athlete_events))

# Check if missing data is year related
Athlete_events %>% 
  group_by(Year)%>%
  summarize(MissingAge=sum(is.na(Age)),
            MissingHeight=sum(is.na(Weight)),
            MissingWeight=sum(is.na(Height)),
            .groups="drop")

# replace N/A with "No Medal"
Athlete_events$Medal[is.na(Athlete_events$Medal)]<- "No Medal"

# could have also used the ifelse statement for this: 
# Athlete_events$Medal <- ifelse(is.na(Athlete_events$Medal), "No Medal", Athlete_events$Medal)

Merged_data <- merge(Athlete_events,NOC_region,by="NOC", all.x=TRUE)

# Merging data, filtering for NA within 'region' and listing all the unique 'NA' region names
MissingRegion<-Merged_data %>%
  filter(is.na(region))

unique(MissingRegion$NOC)

# Replace missing 'regions' based on their NOC code
Merged_data<-Merged_data %>%
  mutate(region=replace(region,NOC=="ROT", "Refugee Olympic Athletes"),
         region=replace(region,NOC=="SGP", "Singapore"),
         region=replace(region,NOC=="TUV", "Tuvalu"),
         region=replace(region,NOC=="UNK", "Unknown"))

#Again this could also be done with an ifelse statement within the mutate function.

# Renaming the region variable to country, filtering for only 1986 'Year' data onwards
col_number <- which(colnames(Merged_data) == "region") #this is useful if you have a very large dataset and don't know the column number of the variable you want to rename.
colnames(Merged_data)[col_number]<-"Country"
Merged_data <- Merged_data %>%
  filter(Year>=1986)

# Code to save both new .csv files
write.csv(Merged_data,"/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/R Outputs/P3_output1.csv")
write.csv(Population,"/Users/seanmccrone/Desktop/MASTERS DEGREE/Course Material/B1703/Week 3/R Outputs/P3_output2.csv")

