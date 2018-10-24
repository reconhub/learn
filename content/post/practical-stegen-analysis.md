---
title: "An outbreak of gastroenteritis in Stegen, Germany, June 1998 (part 3)"
author: "Janetta Skarp, Zhian N. Kamvar, Alexander Spina, and Patrick Keating"
authors: ["Janetta Skarp", "Zhian N. Kamvar", "Alexander Spina", "Patrick Keating"]
categories:
tags: ["level: beginner", "epicurve", "single variable analysis", "2x2 tables", "reproducible research", "gastroenteritis"]
date: 2918-10-06
slug: stegen-analysis
licenses: CC-BY
image: img/highres/graduation-1965-bw.jpg
showonlyimage: true
---

Univariable and stratified analysis
===================================

This practical is a continuation of the analysis concerning the outbreak
of gastroenteritis after a high school graduation dinner in Stegen,
Germany. The [introduction to this case is presented in part
1](./stegen-introduction.html), which focussed on initial data
inspection and cleaning. [Part 2](./stegen-descriptive.html)
focussed on descriptive statistics. This practical will focus on
univariable and stratified analysis. To identify (the) potential
vehicle(s) in the outbreak, proceed with an analytical study where you
use statistical tests to investigate the associations of some suspicious
food items with the disease.

> If you get stuck with any of the tasks in this practical, additional
> information for each task can be found in the [**Help** section](#help)

Preparing packages and data
---------------------------

``` r
library("epiR")
library("Hmisc")
library("epitools")
library("here")
library("incidence")
```

``` r
# Function to make tables with counts, proportions and cumulative sum
big_table <- function(data, useNA = "no") {
  count <- table(data, useNA = useNA)
  prop <- round(prop.table(count)*100, digits = 2)
  cumulative <- cumsum(prop)
  rbind(count,
        prop,
        cumulative) 
}

 # Function to provide counts, denominator and proportions (equivalent of attack rate)
attack_rate <- function(table) {
  prop <- round(prop.table(table, 1), digits = 2)
  denominator <- rowSums(table) 
  output <- cbind(Ill = table[, 2], N = denominator, Proportions = prop[, 2])
  return(output)
}
```

``` r
stegen_data <- read.csv(here::here("data", "stegen_clean.csv"), stringsAsFactors = FALSE)
```

Question 1: What is/are the vehicle/s for this outbreak?
--------------------------------------------------------

### a) Compute food-specific attack rates and % of cases exposed

### b) Choose the appropriate measure of association and the appropriate statistical tests and appropriate level of confidence

### c) Look at the proportion of cases exposed

What would be your suspected food item at this point?

### d) Compute the proportion of cases exposed for each exposure

### e) Search for any dose response if appropriate

Consider whether you would recode this variable so it has fewer
categories, and actually do it.

### f) Interpret the results and identify the outbreak vehicle if any.

Question 2: Assess whether the chocolate mousses were the vehicles of the illness.
----------------------------------------------------------------------------------

Consider effect modification and confounding.

Question 3: Assess whether beer had a protective effect on the occurrence of illness
------------------------------------------------------------------------------------

Help
====

Question 1
----------

<details>
<summary> <b> a)-d) </b> </summary>

As we are carrying out a cohort study, the appropriate measure of
association is relative risk.

The appropriate statistical test for determining a p-value is a
Chi-squared test of comparison of proportions.

For our analyses we will use a 95% confidence level, as this is the
standard used in public health.

The outputs required for a, c and d are provided by the same function as
described below. There are a number of ways to calculate food-specific
attack rates and the proportion of cases exposed to specific exposures
in R. Below you will see two approaches. The first approach gives us the
% of cases exposed to tiramisu.

``` r
# The first element will be rows and the 2nd will be columns
count <- table(tiramisu = stegen_data$tira,  ill = stegen_data$ill)

# Here we select row % of count by including ,1 in the prop.table section
prop <- round(prop.table(count, 1), digits = 2) 

# We obtain the denominator using the rowSums function
denominator <- rowSums(count) 

# We combine all the elements together using cbind (binding by columns)
tira <- cbind(Ill = count[, 2], N = denominator, Proportions = prop[, 2])
tira
```

    ##   Ill   N Proportions
    ## 0   7 165        0.04
    ## 1  94 121        0.78

Alternatively, we can use a user-written command called single variable
analysis.v.02 (developed by Daniel Gardiner Cohort 2015).

``` r
# This function needs to be saved in the same folder as the working directory
source(here::here("scripts", "single.variable.analysis.v0.2.R"))
```

``` r
# specify your exposures of interest i.e. tira-pork
vars <- c("tira", "wmousse", "dmousse", "mousse", "beer", "redjelly", "fruitsalad", "tomato", "mince", "salmon", "horseradish", "chickenwin", "roastbeef", "pork")
```

``` r
#NB. click on "sva" in your global environment to view Daniel's source code and read his explanations
a <- sva(stegen_data, outcome = "ill", exposures = vars, measure = "rr", verbose = TRUE)
a
```

    ##       exposure exp exp.cases exp.AR unexp unexp.cases unexp.AR     rr
    ## 1         tira 121        94   77.7   165           7      4.2 18.312
    ## 2      wmousse  72        49   68.1   205          49     23.9  2.847
    ## 3      dmousse 113        76   67.3   174          26     14.9  4.501
    ## 4       mousse 123        81   65.9   166          22     13.3  4.969
    ## 5         beer 106        30   28.3   165          69     41.8  0.677
    ## 6     redjelly  79        45   57.0   212          58     27.4  2.082
    ## 7   fruitsalad  71        46   64.8   220          57     25.9  2.501
    ## 8       tomato  83        35   42.2   208          68     32.7  1.290
    ## 9        mince  87        32   36.8   204          71     34.8  1.057
    ## 10      salmon 104        37   35.6   183          63     34.4  1.033
    ## 11 horseradish  72        30   41.7   217          72     33.2  1.256
    ## 12  chickenwin  84        33   39.3   207          70     33.8  1.162
    ## 13   roastbeef  29         8   27.6   262          95     36.3  0.761
    ## 14        pork 120        48   40.0   169          54     32.0  1.252
    ##    lower  upper  p.value
    ## 1  8.814 38.043 0.000000
    ## 2  2.128  3.809 0.000000
    ## 3  3.087  6.563 0.000000
    ## 4  3.299  7.483 0.000000
    ## 5  0.476  0.963 0.028064
    ## 6  1.556  2.786 0.000004
    ## 7  1.887  3.314 0.000000
    ## 8  0.938  1.774 0.136893
    ## 9  0.757  1.475 0.789388
    ## 10 0.745  1.433 0.897642
    ## 11 0.901  1.751 0.202601
    ## 12 0.838  1.611 0.417660
    ## 13 0.413  1.402 0.417293
    ## 14 0.918  1.708 0.170878

To calculate attack rates for age and sex, you can use the attack\_rate
function.

``` r
# the attack_rate function acts on tables and not data (as in the big_table function)
counts_sex <- table(stegen_data$sex, stegen_data$ill)
attack_rate(counts_sex)
```

    ##   Ill   N Proportions
    ## 0  53 139        0.38
    ## 1  50 152        0.33

``` r
# We will be using the same age group split as in section 2, <30 and >30
stegen_data$agegroup <- ifelse(stegen_data$age >= 30, 1, 0)

counts_age <- table(stegen_data$agegroup, stegen_data$ill)
attack_rate(counts_age)
```

    ##   Ill   N Proportions
    ## 0  75 215        0.35
    ## 1  25  68        0.37

</details>
<details>
<summary> <b> e) Search for any dose response if appropriate </b>
</summary>

Use the variable tportion and tabulate it. Consider whether you would
recode this variable so it has fewer categories, and actually do it.

``` r
# Tabulate tportion variable against illness using attack_rate function
counts_tportion <- table(tportion = stegen_data$tportion, ill = stegen_data$ill)
attack_rate(counts_tportion)
```

    ##   Ill   N Proportions
    ## 0   7 165        0.04
    ## 1  44  65        0.68
    ## 2  38  42        0.90
    ## 3  12  14        0.86

``` r
# Recode 3 portions of tportion as 2 portions
# Make a new variable called tportion2 that has the same values as tportion
stegen_data$tportion2 <- stegen_data$tportion
stegen_data$tportion2[stegen_data$tportion2 == 3] <- 2
```

``` r
# Calculate counts, proportions and sum of recoded tportion2
counts_tportion2 <- table(tportion2 = stegen_data$tportion2, ill = stegen_data$ill)
attack_rate(counts_tportion2)
```

    ##   Ill   N Proportions
    ## 0   7 165        0.04
    ## 1  44  65        0.68
    ## 2  50  56        0.89

Here you should be able to see that those who ate 2 or more portions of
tiramisu have a higher attack rate than those that ate only 1 portion of
tiramisu. Those who ate 1 portion of tiramisu have a higher attack rate
than those who ate no tiramisu.

</details>
<details>
<summary> <b> f) Interpret the results and identify the outbreak vehicle
if any </b> </summary>

Refer to the results of the **sva** output and identify likely vehicles.

Several food items seemed to be associated with the occurrence of
illness; tiramisu, dark and white chocolate mousse, fruit salad, and red
jelly. They can potentially explain up to 94, 76, 49, 46, and 45 of the
103 cases respectively. Investigators decided to identify their
respective role in the occurrence of illness.

From the crude analysis, epidemiologists noticed that the occurrence of
gastroenteritis was lower among those attendants who had drunk beer.
They also decided to assess if beer had a protective effect on the
occurrence of gastroenteritis.

</details>
Question 2 and 3
----------------

<details>
<summary> <b> Details </b> </summary>

Identify the variables which are potential effect modifiers and
confounders.

The `epi.2by2()` function in the epiR package can be used to to identify
effect modifiers/confounders. Outcome and exposure variables of interest
need to be **factor/categorical variables** prior to performing
stratified analysis with this function and also need to be **relevelled
from (0, 1) to (1,0)** so that they can be correctly organised in a 2 by
2 table.

``` r
# Convert outcome/exposure variables to factor variables and reorder them
# The variables of interest are identified by their column number but variable names could equally be used
vars <- colnames(stegen_data[, c(2, 6, 8:10, 12:21)])

for (var in vars) {
  stegen_data[[var]] <- factor(stegen_data[[var]], levels = c(1, 0)) # levels of the variable are now (1, 0) instead of (0, 1)
}
```

Stratify key exposure variables by exposure to tiramisu. We will use
exposure to **wmousse** stratified by tiramisu as an example of the
steps required and then run a loop over all variables of interest.

``` r
# Make a 3-way table with exposure of interest, the outcome and the stratifying variable in that order
a <- table(wmousse = stegen_data$wmousse, 
           ill = stegen_data$ill, 
           tiramisu = stegen_data$tira)

# Use the epi.2by2 function to calculate RRs (by stating method = "cohort.count")
mh1 <- epiR::epi.2by2(a, method = "cohort.count")

# View the output of mh1
mh1
```

    ##              Outcome +    Outcome -      Total        Inc risk *
    ## Exposed +           22           47         69              31.9
    ## Exposed -          155           49        204              76.0
    ## Total              177           96        273              64.8
    ##                  Odds
    ## Exposed +       0.468
    ## Exposed -       3.163
    ## Total           1.844
    ## 
    ## 
    ## Point estimates and 95 % CIs:
    ## -------------------------------------------------------------------
    ## Inc risk ratio (crude)                       0.42 (0.29, 0.60)
    ## Inc risk ratio (M-H)                         0.77 (0.57, 1.03)
    ## Inc risk ratio (crude:M-H)                   0.55
    ## Odds ratio (crude)                           0.15 (0.08, 0.27)
    ## Odds ratio (M-H)                             0.44 (0.20, 0.99)
    ## Odds ratio (crude:M-H)                       0.33
    ## Attrib risk (crude) *                        -44.10 (-56.56, -31.64)
    ## Attrib risk (M-H) *                          -11.47 (-23.10, 0.15)
    ## Attrib risk (crude:M-H)                      3.84
    ## -------------------------------------------------------------------
    ##  Test of homogeneity of IRR: X2 test statistic: 12.558 p-value: < 0.001
    ##  Test of homogeneity of  OR: X2 test statistic: 7.233 p-value: 0.007
    ##  Wald confidence limits
    ##  M-H: Mantel-Haenszel
    ##  * Outcomes per 100 population units

``` r
# We can select specific elements of mh1 using the $ twice as below
# Crude RR
mh1$massoc$RR.crude.wald 
```

    ##         est     lower     upper
    ## 1 0.4196353 0.2947084 0.5975189

``` r
# Stratum-specific RR
mh1$massoc$RR.strata.wald
```

    ##         est     lower    upper
    ## 1 0.7809762 0.5993152 1.017701
    ## 2 0.7417582 0.3501903 1.571161

``` r
# Adjusted RR
mh1$massoc$RR.mh.wald
```

    ##         est     lower    upper
    ## 1 0.7690576 0.5748915 1.028802

``` r
# We can combine all of those elements in to a single table using rbind
results <- rbind(mh1$massoc$RR.crude.wald, 
                 mh1$massoc$RR.strata.wald, 
                 mh1$massoc$RR.mh.wald)


# We can label the rows of this table as below
rownames(results) <- c("Crude", "Strata 1", "Strata 0", "Adjusted")

results
```

    ##                est     lower     upper
    ## Crude    0.4196353 0.2947084 0.5975189
    ## Strata 1 0.7809762 0.5993152 1.0177012
    ## Strata 0 0.7417582 0.3501903 1.5711607
    ## Adjusted 0.7690576 0.5748915 1.0288023

We can write a function incorporating all these steps and run all of the
variables of interest in one go.

``` r
strata_risk <- function(var, case, strat) {
  a <- table(var, case, strat)

  mhtable <- epiR::epi.2by2(a, method = "cohort.count")
  
  results <- rbind(
    mhtable$massoc$RR.crude.wald,
    mhtable$massoc$RR.strata.wald,
    mhtable$massoc$RR.mh.wald
  )

  rownames(results) <- c("Crude", "Strata 1", "Strata 0", "Adjusted")

  results
}
```

``` r
# List the exposure variables
vars <- c("wmousse", "dmousse", "mousse", "beer", "redjelly", "fruitsalad", "tomato", "mince", "salmon", "horseradish", "chickenwin", "roastbeef", "pork") 

# Run strata_risk for each one using tiramisu as strata
lapply(stegen_data[vars], strata_risk, case = stegen_data$ill, strat = stegen_data$tira)
```

    ## $wmousse
    ##                est     lower     upper
    ## Crude    0.4196353 0.2947084 0.5975189
    ## Strata 1 0.7809762 0.5993152 1.0177012
    ## Strata 0 0.7417582 0.3501903 1.5711607
    ## Adjusted 0.7690576 0.5748915 1.0288023
    ## 
    ## $dmousse
    ##                est     lower     upper
    ## Crude    0.3851577 0.2925087 0.5071523
    ## Strata 1 0.7838457 0.6243614 0.9840679
    ## Strata 0 0.8636364 0.4202994 1.7746108
    ## Adjusted 0.8028532 0.6271774 1.0277367
    ## 
    ## $mousse
    ##               est     lower    upper
    ## Crude    2.536585 1.9647228 3.274897
    ## Strata 1 1.220152 1.0103822 1.473473
    ## Strata 0 1.218519 0.5774323 2.571362
    ## Adjusted 1.219823 0.9858767 1.509283
    ## 
    ## $beer
    ##                est     lower    upper
    ## Crude    1.2133603 1.0154722 1.449811
    ## Strata 1 0.9982788 0.9289763 1.072751
    ## Strata 0 2.1341463 1.0914926 4.172800
    ## Adjusted 1.1214879 0.9974879 1.260903
    ## 
    ## $redjelly
    ##                est     lower     upper
    ## Crude    0.5779154 0.4384193 0.7617962
    ## Strata 1 0.9910072 0.8912662 1.1019101
    ## Strata 0 1.0778061 0.5543018 2.0957285
    ## Adjusted 1.0151157 0.8271120 1.2458530
    ## 
    ## $fruitsalad
    ##                est     lower     upper
    ## Crude    0.4551561 0.3234825 0.6404276
    ## Strata 1 0.7654110 0.5762731 1.0166255
    ## Strata 0 0.9122596 0.4630631 1.7972014
    ## Adjusted 0.8134168 0.6031483 1.0969887
    ## 
    ## $tomato
    ##                est     lower    upper
    ## Crude    0.8472959 0.6871452 1.044772
    ## Strata 1 0.9555785 0.8700010 1.049574
    ## Strata 0 1.1064426 0.5574216 2.196211
    ## Adjusted 0.9808444 0.8490679 1.133073
    ## 
    ## $mince
    ##                est     lower    upper
    ## Crude    0.9586366 0.7917417 1.160712
    ## Strata 1 0.9672968 0.8899311 1.051388
    ## Strata 0 1.3921875 0.7140189 2.714474
    ## Adjusted 1.0274672 0.9020905 1.170269
    ## 
    ## $salmon
    ##                est     lower    upper
    ## Crude    0.9941176 0.8316108 1.188380
    ## Strata 1 1.0106456 0.9469702 1.078603
    ## Strata 0 1.2166667 0.6150316 2.406832
    ## Adjusted 1.0390341 0.9254198 1.166597
    ## 
    ## $horseradish
    ##                est     lower    upper
    ## Crude    0.8655395 0.6933977 1.080417
    ## Strata 1 1.0569106 1.0144450 1.101154
    ## Strata 0 0.5952381 0.2443088 1.450248
    ## Adjusted 0.9705922 0.8480626 1.110825
    ## 
    ## $chickenwin
    ##                est     lower    upper
    ## Crude    0.9152452 0.7507684 1.115755
    ## Strata 1 0.9636752 0.8838649 1.050692
    ## Strata 0 1.1911765 0.6015907 2.358583
    ## Adjusted 0.9983989 0.8725598 1.142386
    ## 
    ## $roastbeef
    ##                est      lower    upper
    ## Crude    1.1347771 0.89017541 1.446590
    ## Strata 1 0.9937888 0.89785206 1.099977
    ## Strata 0 0.5432692 0.08422248 3.504307
    ## Adjusted 0.9536259 0.81508117 1.115720
    ## 
    ## $pork
    ##               est     lower    upper
    ## Crude    1.157659 0.9656774 1.387808
    ## Strata 1 1.037831 0.9643538 1.116906
    ## Strata 0 1.037037 0.5244022 2.050803
    ## Adjusted 1.037712 0.9209216 1.169314

Have a look at the association between beer and the illness. By
stratifying the analysis on tiramisu consumption we can measure the
potential protective effect of beer among those who ate tiramisu. It
seems that consumption of beer may reduce the effect of tiramisu
consumption on the occurrence of gastroenteritis. The RR does not
significantly differ between the two strata (0.8 vs. 1.0 and confidence
intervals overlap). But, effect modification may be present. A similar
stratification was conducted assessing dose response for tiramisu
consumption among beer drinkers and no-beer drinkers.

After stratifying beer consumption by the amount of tiramisu consumed,
it appeared that beer consumption reduced the effect of tiramisu on the
occurrence of gastroenteritis only among those who had eaten an average
amount of tiramisu. This is suggesting that, if the amount of tiramisu
was large, consumption of beer no longer reduced the risk of illness
when eating tiramisu.

</details>
Copyright and license
---------------------

**Source:** This case study was first designed by Alain Moren and Gilles
Desve, EPIET. It is based on an investigation conducted by Anja Hauri,
RKI, Berlin, 1998.

**Authors:** Alain Moren and Gilles Desve

**Reviewers:** Marta Valenciano, Alain Moren

**Adaptations for previous modules:** Alicia Barrasa, Ioannis
Karagiannis

**You are free:**

-   to Share - to copy, distribute and transmit the work
-   to Remix - to adapt the work Under the following conditions:
-   Attribution - You must attribute the work in the manner specified by
    the author or licensor (but not in any way that suggests that they
    endorse you or your use of the work). The best way to do this is to
    keep as it is the list of contributors: sources, authors and
    reviewers.
-   Share Alike - If you alter, transform, or build upon this work, you
    may distribute the resulting work only under the same or similar
    license to this one. Your changes must be documented. Under that
    condition, you are allowed to add your name to the list of
    contributors.
-   You cannot sell this work alone but you can use it as part of a
    teaching. With the understanding that:
-   Waiver - Any of the above conditions can be waived if you get
    permission from the copyright holder.
-   Public Domain - Where the work or any of its elements is in the
    public domain under applicable law, that status is in no way
    affected by the license.
-   Other Rights - In no way are any of the following rights affected by
    the license:
-   Your fair dealing or fair use rights, or other applicable copyright
    exceptions and limitations;
-   The author’s moral rights;
-   Rights other persons may have either in the work itself or in how
    the work is used, such as publicity or privacy rights.
-   Notice - For any reuse or distribution, you must make clear to
    others the license terms of this work by keeping together this work
    and the current license. This licence is based on
    <http://creativecommons.org/licenses/by-sa/3.0/>
