---
title: "An outbreak of gastroenteritis in Stegen, Germany, June 1998 (part 2)"
author: "Janetta Skarp, Zhian N. Kamvar, Alexander Spina, and Patrick Keating"
authors: ["Janetta Skarp", "Zhian N. Kamvar", "Alexander Spina", "Patrick Keating"]
categories:
tags: ["level: beginner", "epicurve", "single variable analysis", "2x2 tables", "reproducible research", "gastroenteritis"]
date: 2918-10-06
slug: stegen-descriptive
licenses: CC-BY
image: img/highres/graduation-1965-grey.jpg
showonlyimage: true
---

Descriptive analysis in *R*
===========================

This practical is a continuation of the analysis concerning the outbreak
of gastroenteritis after a high school graduation dinner in Stegen,
Germany. The [introduction to this case is presented in part
1](./stegen-introduction.html), which focussed on initial data
inspection and cleaning. This practical will focus on descriptive stats
including 2x2 tables and epicurves.

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

Descriptive Analysis
====================

What are the main characteristics of your study population?

### a) Describe your dataset

Look at:

-   the number of observations and variable types
-   mean, median, and maximum values for each variable

### b) Create summary tables with counts and proportions

For each variable in the dataset.

### c) Make a box plot and histogram of age

### d) Produce a table of the number of cases by date of onset

### e) Create an epicurve for this outbreak

-   Use the incidence package, providing information on daily incidence
-   Make sure the dates of onset are stored as “Date” objects

Help
====

<details>
<summary> <b> a) Describe your dataset </b> </summary>

You can view the structure of your data set using the following
commands:

``` r
# str provides an overview of the number of observations and variable types
str(stegen_data)
```

    ## 'data.frame':    291 obs. of  22 variables:
    ##  $ X          : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ uniquekey  : int  210 12 288 186 20 148 201 106 272 50 ...
    ##  $ ill        : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ dateonset  : chr  "1998-06-27" "1998-06-27" "1998-06-27" "1998-06-27" ...
    ##  $ sex        : int  1 0 1 0 1 0 0 0 1 0 ...
    ##  $ age        : int  18 57 56 17 19 16 19 19 40 53 ...
    ##  $ tira       : int  1 1 0 1 1 1 1 1 1 1 ...
    ##  $ tportion   : int  3 1 0 1 2 2 3 2 2 1 ...
    ##  $ wmousse    : int  0 0 0 1 0 1 0 1 1 1 ...
    ##  $ dmousse    : int  1 1 0 0 0 1 1 1 1 1 ...
    ##  $ mousse     : int  1 1 0 1 0 1 1 1 1 1 ...
    ##  $ mportion   : int  1 1 0 NA 0 1 1 1 2 1 ...
    ##  $ beer       : int  0 0 0 0 1 0 0 0 1 0 ...
    ##  $ redjelly   : int  0 0 0 1 0 0 0 1 0 1 ...
    ##  $ fruitsalad : int  0 1 0 0 0 1 1 1 0 0 ...
    ##  $ tomato     : int  0 0 1 0 0 0 0 0 1 0 ...
    ##  $ mince      : int  0 1 1 0 0 1 0 0 0 0 ...
    ##  $ salmon     : int  0 1 1 NA 0 1 0 0 1 1 ...
    ##  $ horseradish: int  0 1 0 0 0 0 0 1 0 1 ...
    ##  $ chickenwin : int  0 0 0 0 0 1 0 1 0 1 ...
    ##  $ roastbeef  : int  0 0 0 0 0 0 0 0 1 0 ...
    ##  $ pork       : int  1 0 0 NA 0 0 0 0 0 0 ...

``` r
# summary provides mean, median and max values of your variables
summary(stegen_data)
```

    ##        X           uniquekey          ill         dateonset        
    ##  Min.   :  1.0   Min.   :  1.0   Min.   :0.000   Length:291        
    ##  1st Qu.: 73.5   1st Qu.: 73.5   1st Qu.:0.000   Class :character  
    ##  Median :146.0   Median :146.0   Median :0.000   Mode  :character  
    ##  Mean   :146.0   Mean   :146.0   Mean   :0.354                     
    ##  3rd Qu.:218.5   3rd Qu.:218.5   3rd Qu.:1.000                     
    ##  Max.   :291.0   Max.   :291.0   Max.   :1.000                     
    ##                                                                    
    ##       sex              age             tira           tportion     
    ##  Min.   :0.0000   Min.   :12.00   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.0000   1st Qu.:18.00   1st Qu.:0.0000   1st Qu.:0.0000  
    ##  Median :1.0000   Median :20.00   Median :0.0000   Median :0.0000  
    ##  Mean   :0.5223   Mean   :26.66   Mean   :0.4231   Mean   :0.6678  
    ##  3rd Qu.:1.0000   3rd Qu.:27.00   3rd Qu.:1.0000   3rd Qu.:1.0000  
    ##  Max.   :1.0000   Max.   :80.00   Max.   :1.0000   Max.   :3.0000  
    ##                   NA's   :8       NA's   :5        NA's   :5       
    ##     wmousse          dmousse           mousse          mportion     
    ##  Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000  
    ##  Median :0.0000   Median :0.0000   Median :0.0000   Median :0.0000  
    ##  Mean   :0.2599   Mean   :0.3937   Mean   :0.4256   Mean   :0.6523  
    ##  3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:1.0000  
    ##  Max.   :1.0000   Max.   :1.0000   Max.   :1.0000   Max.   :3.0000  
    ##  NA's   :14       NA's   :4        NA's   :2        NA's   :12      
    ##       beer           redjelly        fruitsalad        tomato      
    ##  Min.   :0.0000   Min.   :0.0000   Min.   :0.000   Min.   :0.0000  
    ##  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.000   1st Qu.:0.0000  
    ##  Median :0.0000   Median :0.0000   Median :0.000   Median :0.0000  
    ##  Mean   :0.3911   Mean   :0.2715   Mean   :0.244   Mean   :0.2852  
    ##  3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:0.000   3rd Qu.:1.0000  
    ##  Max.   :1.0000   Max.   :1.0000   Max.   :1.000   Max.   :1.0000  
    ##  NA's   :20                                                        
    ##      mince           salmon        horseradish       chickenwin    
    ##  Min.   :0.000   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000  
    ##  1st Qu.:0.000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000  
    ##  Median :0.000   Median :0.0000   Median :0.0000   Median :0.0000  
    ##  Mean   :0.299   Mean   :0.3624   Mean   :0.2491   Mean   :0.2887  
    ##  3rd Qu.:1.000   3rd Qu.:1.0000   3rd Qu.:0.0000   3rd Qu.:1.0000  
    ##  Max.   :1.000   Max.   :1.0000   Max.   :1.0000   Max.   :1.0000  
    ##                  NA's   :4        NA's   :2                        
    ##    roastbeef            pork       
    ##  Min.   :0.00000   Min.   :0.0000  
    ##  1st Qu.:0.00000   1st Qu.:0.0000  
    ##  Median :0.00000   Median :0.0000  
    ##  Mean   :0.09966   Mean   :0.4152  
    ##  3rd Qu.:0.00000   3rd Qu.:1.0000  
    ##  Max.   :1.00000   Max.   :1.0000  
    ##                    NA's   :2

``` r
# describe (from Hmisc package) provides no. of observations, missing values, unique levels of each variable
Hmisc::describe(stegen_data) 
```

    ## stegen_data 
    ## 
    ##  22  Variables      291  Observations
    ## ---------------------------------------------------------------------------
    ## X 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##      291        0      291        1      146    97.33     15.5     30.0 
    ##      .25      .50      .75      .90      .95 
    ##     73.5    146.0    218.5    262.0    276.5 
    ## 
    ## lowest :   1   2   3   4   5, highest: 287 288 289 290 291
    ## ---------------------------------------------------------------------------
    ## uniquekey 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##      291        0      291        1      146    97.33     15.5     30.0 
    ##      .25      .50      .75      .90      .95 
    ##     73.5    146.0    218.5    262.0    276.5 
    ## 
    ## lowest :   1   2   3   4   5, highest: 287 288 289 290 291
    ## ---------------------------------------------------------------------------
    ## ill 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.686      103    0.354   0.4589 
    ## 
    ## ---------------------------------------------------------------------------
    ## dateonset 
    ##        n  missing distinct 
    ##      131      160       11 
    ## 
    ## 1998-06-26 (1, 0.008), 1998-06-27 (56, 0.427), 1998-06-28 (51, 0.389),
    ## 1998-06-29 (10, 0.076), 1998-06-30 (3, 0.023), 1998-07-01 (3, 0.023),
    ## 1998-07-02 (3, 0.023), 1998-07-04 (1, 0.008), 1998-07-05 (1, 0.008),
    ## 1998-07-06 (1, 0.008), 1998-07-09 (1, 0.008)
    ## ---------------------------------------------------------------------------
    ## sex 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.749      152   0.5223   0.5007 
    ## 
    ## ---------------------------------------------------------------------------
    ## age 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##      283        8       46     0.99    26.66    13.75       16       17 
    ##      .25      .50      .75      .90      .95 
    ##       18       20       27       52       57 
    ## 
    ## lowest : 12 13 14 15 16, highest: 60 62 64 65 80
    ## ---------------------------------------------------------------------------
    ## tira 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      286        5        2    0.732      121   0.4231   0.4899 
    ## 
    ## ---------------------------------------------------------------------------
    ## tportion 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##      286        5        4    0.793   0.6678   0.8993 
    ##                                   
    ## Value          0     1     2     3
    ## Frequency    165    65    42    14
    ## Proportion 0.577 0.227 0.147 0.049
    ## ---------------------------------------------------------------------------
    ## wmousse 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      277       14        2    0.577       72   0.2599   0.3861 
    ## 
    ## ---------------------------------------------------------------------------
    ## dmousse 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      287        4        2    0.716      113   0.3937   0.4791 
    ## 
    ## ---------------------------------------------------------------------------
    ## mousse 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      289        2        2    0.733      123   0.4256   0.4906 
    ## 
    ## ---------------------------------------------------------------------------
    ## mportion 
    ##        n  missing distinct     Info     Mean      Gmd 
    ##      279       12        4    0.777   0.6523   0.8902 
    ##                                   
    ## Value          0     1     2     3
    ## Frequency    166    55    47    11
    ## Proportion 0.595 0.197 0.168 0.039
    ## ---------------------------------------------------------------------------
    ## beer 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      271       20        2    0.714      106   0.3911   0.4781 
    ## 
    ## ---------------------------------------------------------------------------
    ## redjelly 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.593       79   0.2715   0.3969 
    ## 
    ## ---------------------------------------------------------------------------
    ## fruitsalad 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.553       71    0.244   0.3702 
    ## 
    ## ---------------------------------------------------------------------------
    ## tomato 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.612       83   0.2852   0.4091 
    ## 
    ## ---------------------------------------------------------------------------
    ## mince 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.629       87    0.299   0.4206 
    ## 
    ## ---------------------------------------------------------------------------
    ## salmon 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      287        4        2    0.693      104   0.3624   0.4637 
    ## 
    ## ---------------------------------------------------------------------------
    ## horseradish 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      289        2        2    0.561       72   0.2491   0.3754 
    ## 
    ## ---------------------------------------------------------------------------
    ## chickenwin 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.616       84   0.2887   0.4121 
    ## 
    ## ---------------------------------------------------------------------------
    ## roastbeef 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      291        0        2    0.269       29  0.09966   0.1801 
    ## 
    ## ---------------------------------------------------------------------------
    ## pork 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      289        2        2    0.728      120   0.4152   0.4873 
    ## 
    ## ---------------------------------------------------------------------------

“Summary” and “describe” can be applied to:

-   the whole dataset
-   specific variables of interest

In the example below we look at sex, age and pork in the
**stegen\_data** dataset. You can examine a variable within a dataset
using the ‘`$`’ sign followed by the variable name.

``` r
# table will give a very basic frequency table (counts), 
table(stegen_data$sex)
```

    ## 
    ##   0   1 
    ## 139 152

``` r
# summary gives the mean, median and max values of the specified variable
summary(stegen_data$age)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   12.00   18.00   20.00   26.66   27.00   80.00       8

``` r
# describe gives the number of data points, missing values and number of categories
describe(stegen_data$pork)
```

    ## stegen_data$pork 
    ##        n  missing distinct     Info      Sum     Mean      Gmd 
    ##      289        2        2    0.728      120   0.4152   0.4873

</details>
<details>
<summary> <b> b) Create summary tables with counts and proportions </b>
</summary>

We can create individual tables for each variable with the following
steps:

``` r
# Assign the counts of stegen_data$sex to the object "sex"
sex <- table(stegen_data$sex)

# Assign the proportion of stegen_data$sex to the object "prop" and round the values to 2 decimal places
prop <- round(prop.table(sex)*100, digits = 2)

# Assign the cumulative sum of stegen_data$sex to the object "cumul"
cumul <- cumsum(prop)

# Append/row bind the results of the three objects together and assign to the object table1
table1 <- rbind(sex,prop,cumul)
```

``` r
table1
```

    ##            0      1
    ## sex   139.00 152.00
    ## prop   47.77  52.23
    ## cumul  47.77 100.00

We could also use the big\_table function (on page 2), which does all of
the above steps in one line.

``` r
big_table(stegen_data$sex)
```

    ##                 0      1
    ## count      139.00 152.00
    ## prop        47.77  52.23
    ## cumulative  47.77 100.00

``` r
big_table(stegen_data$beer)
```

    ##                 0      1
    ## count      165.00 106.00
    ## prop        60.89  39.11
    ## cumulative  60.89 100.00

We could use lapply to apply `big_table()` to each of our variables.

``` r
# List the variables of interest and use c() to combine the elements into a vector
vars <- c("ill", "tira", "beer", "pork", "salmon")

lapply(stegen_data[, vars, drop = FALSE], FUN = big_table)
```

    ## $ill
    ##                0     1
    ## count      188.0 103.0
    ## prop        64.6  35.4
    ## cumulative  64.6 100.0
    ## 
    ## $tira
    ##                 0      1
    ## count      165.00 121.00
    ## prop        57.69  42.31
    ## cumulative  57.69 100.00
    ## 
    ## $beer
    ##                 0      1
    ## count      165.00 106.00
    ## prop        60.89  39.11
    ## cumulative  60.89 100.00
    ## 
    ## $pork
    ##                 0      1
    ## count      169.00 120.00
    ## prop        58.48  41.52
    ## cumulative  58.48 100.00
    ## 
    ## $salmon
    ##                 0      1
    ## count      183.00 104.00
    ## prop        63.76  36.24
    ## cumulative  63.76 100.00

</details>
<details>
<summary> <b> c) Make box plot and histogram of age </b> </summary>

You can use the following to examine the age distribution among people
who attended the party, as well as only those and who fell ill.

``` r
# Boxplot of the age of all who attended the party
boxplot(stegen_data$age)
```

![](practical-stegen-descriptive_files/figure-markdown_github/stegen-13-1.png)

``` r
# Histogram of the ages of those who attended the party and who fell ill

# Here we use the hist function to plot the age of cases only (ill == 1)
# You will see that RStudio creates a jpeg file in your working directory with the above path and filename.
age_hist_all <- hist(stegen_data$age[stegen_data$ill == 1],
                     xlab = "Age",
                     ylab = "No. of cases",
                     main = "Histogram of the ages of cases")
```

![](practical-stegen-descriptive_files/figure-markdown_github/stegen-15-1.png)

If we believe that there are two identifiable age groups, then we can
create a new age group variable using **one** of the following
approaches:

``` r
# by using ifelse (similar to Excel if statements)
stegen_data$agegroup <- ifelse(stegen_data$age >= 30, 1, 0)
```

``` r
# Two alternative approaches
# The below are particularly useful when you want to create more than 2 categories
# by using cut
stegen_data$agegroup <- cut(stegen_data$age, c(0, 30, 150), labels = FALSE) - 1
# by using findInterval
stegen_data$agegroup <- findInterval(stegen_data$age, c(30, 150))
```

</details>
<details>
<summary> <b> d) Number of cases by date of onset </b> </summary>

You can produce summary tables by person and time (no place variable
provided) using the big\_table function.

``` r
# Table 1: Descriptive epidemiology: Study population by sex
big_table(stegen_data$sex)
```

    ##                 0      1
    ## count      139.00 152.00
    ## prop        47.77  52.23
    ## cumulative  47.77 100.00

``` r
# Table 2: Descriptive epidemiology: Study population by age group
# useNA ="always" here allows you to see the proportion of NAs for this variable
big_table(stegen_data$agegroup, useNA = "always")
```

    ##                 0     1   <NA>
    ## count      215.00 68.00   8.00
    ## prop        73.88 23.37   2.75
    ## cumulative  73.88 97.25 100.00

``` r
summary(stegen_data$age)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##   12.00   18.00   20.00   26.66   27.00   80.00       8

``` r
# Table 3: Descriptive epidemiology: Attack rate
big_table(stegen_data$ill)
```

    ##                0     1
    ## count      188.0 103.0
    ## prop        64.6  35.4
    ## cumulative  64.6 100.0

``` r
# Table 4: Descriptive epidemiology: Cases by date of onset of illness
big_table(stegen_data$dateonset)
```

    ##            1998-06-26 1998-06-27 1998-06-28 1998-06-29 1998-06-30
    ## count            1.00      56.00      51.00      10.00       3.00
    ## prop             0.76      42.75      38.93       7.63       2.29
    ## cumulative       0.76      43.51      82.44      90.07      92.36
    ##            1998-07-01 1998-07-02 1998-07-04 1998-07-05 1998-07-06
    ## count            3.00       3.00       1.00       1.00       1.00
    ## prop             2.29       2.29       0.76       0.76       0.76
    ## cumulative      94.65      96.94      97.70      98.46      99.22
    ##            1998-07-09
    ## count            1.00
    ## prop             0.76
    ## cumulative      99.98

</details>
<details>
<summary> <b> e) Create an epicurve for this outbreak </b> </summary>

``` r
# Make sure the dates are "Date" objects
stegen_data$dateonset <- as.Date(stegen_data$dateonset)

# Create the epicurve
stegen_incidence <- incidence::incidence(stegen_data$dateonset, interval = 1)
plot(stegen_incidence)
```

![](practical-stegen-descriptive_files/figure-markdown_github/stegen-19-1.png)

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
