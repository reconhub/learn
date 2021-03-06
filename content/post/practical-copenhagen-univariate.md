---
title: "Outbreak of gastroenteritis after a high school dinner in Copenhagen, Denmark,November 2006 (part 3)"
author: "Zhian N. Kamvar, Janetta Skarp, Alexander Spina, and Patrick Keating"
output:
  html_document
authors: ["Zhian N. Kamvar", "Janetta Skarp", "Alexander Spina", "Patrick Keating"]
categories: ["practicals"]
tags: ["epicurve", "single variable analysis", "2x2 tables"]
date: 6911-10-04
image: img/highres/van-der-helst-banquet-03.png
slug: copenhagen-univariate
showonlyimage: true
licenses: CC-BY
---

<img src="../img/under-review.png" alt="Under Review: this practical is currently being revised and may change in the future">

Univariable analysis (Cohort and case control)
==============================================

This practical is a continuation of the analysis concerning the outbreak
of gastroenteritis after a high school dinner in Copenhagen, Denmark.
The [introduction to this case is presented in part
1](./copenhagen-introduction.html), which focussed on initial data
inspection and cleaning. [Part 2](./copenhagen-descriptive.html)
focussed on descriptive statistics. This practical will focus on
univariable analysis. To identify (the) potential vehicle(s) in the
outbreak, proceed with an analytical study where you use statistical
tests to investigate the associations of some suspicious food items with
the disease.

Preparing packages and data
---------------------------

``` r
library("ggplot2")
library("skimr")
library("Hmisc")
library("epiR")
library("incidence")
library("here")
```

``` r
# read in your data from a csv file 
# Select separator as comma (sep=",")
# do not import 'string' variables as 'Factors' (stringsAsFactors=FALSE) 
# Factors are a special datatype, covered later - character variables are simpler
# data frame read in and saved in R as "cph"

cph <- read.csv(here::here("data", "copenhagen_univariable.csv"), stringsAsFactors = FALSE) 
```

``` r
# Functions required

# Adds a function to create a nice table for univariable analysis
source(here::here("scripts", "single.variable.analysis.v0.2.R")) 
```

There is more than one way to create univariable tables. One gives you a
two by two and quite a lot of info, and the other is user-written code
which will provide you with nicer output.

Think about which variables you might want to include when checking for
effect modification or confounding. One common strategy is to base this
decision on the univariable results obtained and a p-value threshold of
0.25. Also, food items that are known risk factors for gastroenteritis
could also be included regardless of their univariable p-value.

Detailed output (method 1)
--------------------------

In order to use the `epiR::epi.2by2()` function, we first need to
convert the outcome and exposure variables into factor variables to
facilitate interpretation.

Outcome and exposure variables of interest need to be factor variables
prior to using the function, in order to be relevelled from (0, 1) to
(1, 0) so that they can be correctly organised in 2-by-2 tables.

``` r
# We list the outcome/exposure variables
vars <- c("shrimps", "veal", "pasta", "sauce", "champagne", "rocket", "case")

# Convert all of those variables to factor variables and re-order the levels to aid interpretation
for (var in vars) {
  cph[[var]] <- factor(cph[[var]], levels = c(1, 0))
}
```

The `epi.2by2()` function from the *epiR* package can be used to
calculate both risk ratios (RRs) and odds ratios (ORs). You can find out
more information on the function by writing `?epiR::epi.2by2()` in the
console. The `epiR::epi.2by2()` function requires data to be in a table
format. We can specify that we want to calculate RRs or ORs by adding
**method = “cohort.count”** or **method = “case.control”**,
respectively. You can do that first for looking at the risk for being a
case by exposure to shrimp in a cohort study design.

``` r
# Create a table with exposure and outcome variables
counts <- table(cph$shrimps, cph$case)

# Apply epi.2by2 function to the table
shrimp <- epiR::epi.2by2(counts, method = "cohort.count")

# to view the output
shrimp
```

    ##              Outcome +    Outcome -      Total        Inc risk *
    ## Exposed +          149          106        255              58.4
    ## Exposed -           65           52        117              55.6
    ## Total              214          158        372              57.5
    ##                  Odds
    ## Exposed +        1.41
    ## Exposed -        1.25
    ## Total            1.35
    ## 
    ## Point estimates and 95 % CIs:
    ## -------------------------------------------------------------------
    ## Inc risk ratio                               1.05 (0.87, 1.27)
    ## Odds ratio                                   1.12 (0.72, 1.75)
    ## Attrib risk *                                2.88 (-7.97, 13.72)
    ## Attrib risk in population *                  1.97 (-8.34, 12.28)
    ## Attrib fraction in exposed (%)               4.92 (-15.24, 21.56)
    ## Attrib fraction in population (%)            3.43 (-10.41, 15.53)
    ## -------------------------------------------------------------------
    ##  X2 test statistic: 0.271 p-value: 0.602
    ##  Wald confidence limits
    ##  * Outcomes per 100 population units

Now that we know how to create this table, we can create a function with
two arguments that will return the 2x2 table:

``` r
epi_2by2 <- function(var, case) {
  counts <- table(var, case)
  res <- epiR::epi.2by2(counts, method = "cohort.count")
  res
}
```

Now we can use this function to calculate the epi tables for each
variable:

``` r
# vector of variables you want to run
vars    <- c("pasta", "veal", "champagne", "sauce", "shrimps")
my2by2s <- lapply(cph[vars], epi_2by2, case = cph$case)
```

Because the output is large, we can view them one by one with the `$`
operator:

``` r
my2by2s$veal
```

    ##              Outcome +    Outcome -      Total        Inc risk *
    ## Exposed +          200          138        338              59.2
    ## Exposed -           14           22         36              38.9
    ## Total              214          160        374              57.2
    ##                  Odds
    ## Exposed +       1.449
    ## Exposed -       0.636
    ## Total           1.337
    ## 
    ## Point estimates and 95 % CIs:
    ## -------------------------------------------------------------------
    ## Inc risk ratio                               1.52 (1.00, 2.31)
    ## Odds ratio                                   2.28 (1.13, 4.61)
    ## Attrib risk *                                20.28 (3.52, 37.05)
    ## Attrib risk in population *                  18.33 (1.63, 35.03)
    ## Attrib fraction in exposed (%)               34.28 (0.08, 56.77)
    ## Attrib fraction in population (%)            32.04 (-0.55, 54.06)
    ## -------------------------------------------------------------------
    ##  X2 test statistic: 5.468 p-value: 0.019
    ##  Wald confidence limits
    ##  * Outcomes per 100 population units

``` r
my2by2s$shrimps
```

    ##              Outcome +    Outcome -      Total        Inc risk *
    ## Exposed +          149          106        255              58.4
    ## Exposed -           65           52        117              55.6
    ## Total              214          158        372              57.5
    ##                  Odds
    ## Exposed +        1.41
    ## Exposed -        1.25
    ## Total            1.35
    ## 
    ## Point estimates and 95 % CIs:
    ## -------------------------------------------------------------------
    ## Inc risk ratio                               1.05 (0.87, 1.27)
    ## Odds ratio                                   1.12 (0.72, 1.75)
    ## Attrib risk *                                2.88 (-7.97, 13.72)
    ## Attrib risk in population *                  1.97 (-8.34, 12.28)
    ## Attrib fraction in exposed (%)               4.92 (-15.24, 21.56)
    ## Attrib fraction in population (%)            3.43 (-10.41, 15.53)
    ## -------------------------------------------------------------------
    ##  X2 test statistic: 0.271 p-value: 0.602
    ##  Wald confidence limits
    ##  * Outcomes per 100 population units

Simplified output (method 2)
----------------------------

A much more straight forward way is to simply apply a user-written
function which requires much less input from you. The *sva* function
(Daniel Gardner, PHE) basically integrates the steps from above to
create a nice output table.

``` r
# You already sourced the function at the begining of this case study 
# if you haven't then type: source(here::here("scripts", "single.variable.analysis.v0.2.R"))
# nb. click on "sva" in your global environment to view source code and read explanations

# cohort study
sva(cph, outcome = "case", exposures = vars, measure = "rr", verbose = TRUE)
```

    ##    exposure exp exp.cases exp.AR unexp unexp.cases unexp.AR    rr lower
    ## 1     pasta  36        23   63.9   338         137     40.5 1.576 1.194
    ## 2      veal  36        22   61.1   338         138     40.8 1.497 1.119
    ## 3 champagne  48        27   56.2   316         130     41.1 1.367 1.031
    ## 4     sauce 198        92   46.5   149          59     39.6 1.173 0.915
    ## 5   shrimps 117        52   44.4   255         106     41.6 1.069 0.833
    ##   upper  p.value
    ## 1 2.080 0.008027
    ## 2 2.001 0.021785
    ## 3 1.813 0.060220
    ## 4 1.504 0.229176
    ## 5 1.372 0.651744

``` r
# cohort count
sva(cph, outcome = "case", exposures = vars, measure = "or", verbose = TRUE)
```

    ##    exposure cases cases.exp %cases.exp controls controls.exp %controls.exp
    ## 1     pasta   160        23       14.4      214           13           6.1
    ## 2      veal   160        22       13.8      214           14           6.5
    ## 3 champagne   157        27       17.2      207           21          10.1
    ## 4     sauce   151        92       60.9      196          106          54.1
    ## 5   shrimps   158        52       32.9      214           65          30.4
    ##      or lower upper  p.value
    ## 1 2.596 1.271 5.300 0.008027
    ## 2 2.277 1.126 4.606 0.021785
    ## 3 1.840 0.997 3.395 0.060220
    ## 4 1.324 0.860 2.037 0.229176
    ## 5 1.125 0.723 1.749 0.651744

Different statistical tests in *R*
==================================

Note that for the below tests, no tables are printed alongside, however
you could create these tables using the table and propstable (for
percentages) functions.

Is gender associated with being a case?
---------------------------------------

``` r
# using a chi-squared test
  # chisq.test funciton requires you to input a table
chisq.test(table(cph$sex, cph$case))
```

    ## 
    ##  Pearson's Chi-squared test with Yates' continuity correction
    ## 
    ## data:  table(cph$sex, cph$case)
    ## X-squared = 1.0888, df = 1, p-value = 0.2967

``` r
# using a fisher's exact test
fisher.test(table(cph$sex, cph$case))
```

    ## 
    ##  Fisher's Exact Test for Count Data
    ## 
    ## data:  table(cph$sex, cph$case)
    ## p-value = 0.294
    ## alternative hypothesis: true odds ratio is not equal to 1
    ## 95 percent confidence interval:
    ##  0.5082282 1.2113269
    ## sample estimates:
    ## odds ratio 
    ##   0.785681

Is class associated with being a case?
--------------------------------------

Here you can either compare proportions, using the chi-squared test, or
use the Wilcoxon-Mann-Whitney test to compare distributions. For the
Wilcoxon-Mann-whitney test to work, all variables need to be numeric -
however it is not possible to go directly from a factor to a numeric.
The intermediate is to turn it in to a character and then to a numeric.

``` r
# Using chi-squared
chisq.test(table(cph$class, cph$case))
```

    ## 
    ##  Pearson's Chi-squared test
    ## 
    ## data:  table(cph$class, cph$case)
    ## X-squared = 4.9513, df = 2, p-value = 0.08411

``` r
# using the wilcoxon test 
  # this is a ranksum test and the function pulls the counts numbers by itself

# change case from a factor to numeric
cph$case <- as.numeric(as.character(cph$case))

# run the wilcoxon 
wilcox.test(cph$class, cph$case)
```

    ## 
    ##  Wilcoxon rank sum test with continuity correction
    ## 
    ## data:  cph$class and cph$case
    ## W = 115230, p-value < 2.2e-16
    ## alternative hypothesis: true location shift is not equal to 0

Is there a difference between age in males and females?
-------------------------------------------------------

``` r
# Using a wilcoxon test
wilcox.test(cph$age, cph$sex)
```

    ## 
    ##  Wilcoxon rank sum test with continuity correction
    ## 
    ## data:  cph$age and cph$sex
    ## W = 142130, p-value < 2.2e-16
    ## alternative hypothesis: true location shift is not equal to 0

``` r
# Using a t-test to see difference in mean if normally distributed 
  # shapiro tests if significantly different from normal distribution
shapiro.test(cph$age)
```

    ## 
    ##  Shapiro-Wilk normality test
    ## 
    ## data:  cph$age
    ## W = 0.31302, p-value < 2.2e-16

``` r
t.test(cph$age ~ cph$sex)
```

    ## 
    ##  Welch Two Sample t-test
    ## 
    ## data:  cph$age by cph$sex
    ## t = -0.96089, df = 262.72, p-value = 0.3375
    ## alternative hypothesis: true difference in means is not equal to 0
    ## 95 percent confidence interval:
    ##  -1.9864380  0.6835066
    ## sample estimates:
    ## mean in group 0 mean in group 1 
    ##        18.03756        18.68902

Is there a dose-response relationship between the food items and being sick?
----------------------------------------------------------------------------

Look at the food items that seem most suspicious to you. Hint: it’s
pasta and veal

There are two possible ways to do this. The first is to use the
wilcox.test again, and the second is to calculate ORs using the
`epi.2by2()` function. Using the `epi.2by2()` function for dose
responses is a bit more dense (traditionally this would be done using
regression), so we have not shown it here; if you would like to see the
code for this it is available in the appendix.

Here, we present a function in a different form to test this. Instead of
taking in two vectors, we are taking the names of both columns to make
sure we don’t include any missing data.

``` r
test_DR <- function(var, case = "case", dataset) {
  # var is the name of the variable of interest
  # case is the name of the case definition. Here we set the default to "case"
  # dataset is the data frame with the variable and case definition
  # selects only those cases where dose response is filled out (not empty) and saves as a dataset
  dataset <- dataset[is.na(dataset[var]) == FALSE, ]
  
  # saves in "form" as a text
  # e.g. "pastaD ~ case" which can then be inserted in the wilcox.test to get dose response
  form <- as.formula(paste0(var, "~", "case"))
  
  # put your formula above into wilcox using the reduced dataset
  res <- wilcox.test(form, data = dataset)
  
  res
}
test_DR("vealD", case = "case", dataset = cph)
```

    ## 
    ##  Wilcoxon rank sum test with continuity correction
    ## 
    ## data:  vealD by case
    ## W = 15856, p-value = 0.1554
    ## alternative hypothesis: true location shift is not equal to 0

``` r
test_DR("pastaD", case = "case", dataset = cph)
```

    ## 
    ##  Wilcoxon rank sum test with continuity correction
    ## 
    ## data:  pastaD by case
    ## W = 14376, p-value = 0.004311
    ## alternative hypothesis: true location shift is not equal to 0

Conclusions of univariate analyses
----------------------------------

The interesting results here are that the two food items that are most
suspicious are pasta and veal. In particular, the dose response
relationship that was found for pasta points towards pasta as the
potential vehicle. Pasta as such is unlikely to be contaminated, but as
you can see in the label, it was served with pesto! Before you jump to
conclusions, be aware that this result could be due to confounding!
Maybe pasta was clean but eaten by all the people who ate the food item
that actually was contaminated!

Part 4
======

The analysis continues with [stratified analyses in part
4](./copenhagen-stratified.html)

About this document
===================

This code has been adapted to *R* for learning purposes. The initial
contributors and copyright license are listed below. All copyrights and
licenses of the original document apply here as well.

**Contributors to *R* code:**  
Zhian N. Kamvar, Daniel Gardiner (PHE), and Lukas Richter (AGES)

Citation
--------

Pakalniskiene, J., G. Falkenhorst, M. Lisby, S. B. Madsen, K. E. P.
Olsen, E. M. Nielsen, A. Mygh, Jeppe Boel, and K. Mølbak. “A foodborne
outbreak of enterotoxigenic E. coli and Salmonella Anatum infection
after a high-school dinner in Denmark, November 2006.” Epidemiology &
Infection 137, no. 3 (2009): 396-401. [doi:
10.1017/S0950268808000484](https://doi.org/10.1017/S0950268808000484)

Copyright and license
---------------------

This case study was designed under an ECDC service contract for the
development of training material (2010). The data were slightly modified
for training purposes.

**Source :** This case study is based on an investigation conducted by
Jurgita Pakalniskiene, Gerhard Falkenhorst (Statens Serum Institut,
Copenhagen) and colleagues

**Authors:** Jurgita Pakalniskiene, Gerhard Falkenhorst, Esther
Kissling, Gilles Desvé.

**Reviewers:** Marta Valenciano, Alain Moren.

**Adaptions for previous modules:** Irina Czogiel, Kristin Tolksdorf,
Michaela Diercke, Sybille Somogyi, Christian Winter, Sandra
Dudareva-Vizule with the help of Katharina Alpers, Alicia Barrasa,
Androulla Efstratiou, Steen Ethelberg, Annette Heißenhuber, Aftab Jasir,
Ioannis Karagiannis and Pawel Stefanoff

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
    <a href="http://creativecommons.org/licenses/by-sa/3.0/" class="uri">http://creativecommons.org/licenses/by-sa/3.0/</a>
