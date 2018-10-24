---
title: "Outbreak of gastroenteritis after a high school dinner in Copenhagen, Denmark,November 2006 (part 1)"
author: "Zhian N. Kamvar, Janetta Skarp, Alexander Spina, and Patrick Keating"
authors: ["Zhian N. Kamvar", "Janetta Skarp", "Alexander Spina", "Patrick Keating"]
categories: ["practicals"]
tags: ["level: beginner", "epicurve", "single variable analysis", "2x2 tables", "reproducible research", "gastroenteritis"]
date: 6911-10-04
image: img/highres/van-der-helst-banquet.jpg
slug: copenhagen-introduction
showonlyimage: true
licenses: CC-BY
---


<img src="../img/under-review.png" alt="Under Review: this practical is currently being revised and may change in the future">

The Alert
=========

On November 14th 2006 the director of a high school in Greater
Copenhagen, Denmark, contacted the regional public health authorities to
inform them about an outbreak of diarrhoea and vomiting among
participants from a school dinner party held on the 11th of November
2006. Almost all students and teachers of the school (750 people)
attended the party. The first people fell ill the same night and by the
November 14th the school had received reports of diarrhoeal illness from
around 200 - 300 students and teachers, many of whom also reported
vomiting.

The epidemiologists in the outbreak team decided to perform a
retrospective cohort study in order to identify the food item that was
the vehicle of the outbreak. The cohort was defined as students and
teachers who had attended the party at the high school on 11th of
November 2006. A questionnaire was designed to conduct a survey on food
consumption and on presentation of the illness. Information about the
survey and a link to the questionnaire was circulated to students and
teachers via the school’s intranet with the request that everyone who
attended the school party on 11th of November 2006 should fill in the
questionnaire. Practically all students and teachers check the intranet
on a daily basis, because it is the school’s main communication channel
for information about courses, homework assignments, cancellation of
lessons etc. The information about the investigation was therefore also
displayed on the screen in the main hall of the school. The school’s
intranet was also accessible for ill students or teachers from home so
that everyone in the cohort could potentially participate and the
response rate could be maximised. Symptomatic party attendees were asked
to submit stool samples via their general practitioners to the local
clinical microbiology laboratory where they were cultured for standard
enteric bacteria. The working hypothesis at the point was that the
outbreak had a viral or toxic aetiology. Norovirus is generally
acknowledged as the most frequent cause of foodborne outbreaks in
industrialised countries, so this would be a prime suspect. In the
study, the following case definition was used: a case is a person from
the cohort, who presented with diarrhoea or vomiting within 48 hours of
the meal. So anyone who presented with diarrhoea or vomiting from 6pm on
November 11th to 5:59pm on November 13th was included as a case. Anyone
with symptoms outside this time window is defined as a control as this
person probably didn’t become sick at the party.

An introduction to the *R* companion
====================================

Your *R* Workflow
-----------------

We will be using RStudio projects to separate our sessions into distinct
workflows. For each session, you will open R by double-clicking on the
`.Rproj` file, or opening RStudio and selecting the session from the
upper-right-hand dropdown menu.

> You can set a folder to be your working directory (using the setwd
> command), but we will not be using this because it makes transferring
> between computers difficult (see
> <a href="https://www.tidyverse.org/articles/2017/12/workflow-vs-script/" class="uri">https://www.tidyverse.org/articles/2017/12/workflow-vs-script/</a>
> for details). Instead, we will be using the RStudio project files and
> the ‘here’ package to keep track of files.

This tutorial is designed to be followed along in the context of an R
project folder structure:

    copenhagen/
    ├── data
    │   ├── copenhagen_descriptive.csv
    │   ├── copenhagen_raw.csv
    │   ├── copenhagen_stratified.csv
    │   └── copenhagen_univariable.csv
    ├── README.md
    ├── copenhagen.Rproj
    ├── reports
    │   ├── 01-introduction.Rmd
    │   ├── 02-descriptive-stats.Rmd
    │   ├── 03-univariate-analysis.Rmd
    │   └── 04-stratified-analysis.Rmd
    ├── runAll.R
    └── scripts
        └── single.variable.analysis.v0.2.R

You should create a folder on your computer for the project with the
above structure (containing a “data”, “reports”, and “scripts”
directory). Once you have done that you can download the following data
sets and place them in the `data/` directory:

-   Part 1: [`copenhagen_raw.csv`](../../data/copenhagen_raw.csv)
-   Part 2:
    [`copenhagen_descriptive.csv`](../../data/copenhagen_descriptive.csv)
-   Part 3:
    [`copenhagen_univaraible.csv`](../../data/copenhagen_univariable.csv)
-   Part 4:
    [`copenhagen_stratified.csv`](../../data/copenhagen_stratified.csv)

You should additionally download the
[`single.variable.analysis.v0.2.R`](../../scripts/single.variable.analysis.v0.2.R)
script written by Daniel Gardiner (PHE) and place it in the `scripts/`
directory.

Installing packages and functions
---------------------------------

R packages are bundles of functions which extend the capability of R.
Thousands of add-on packages are available in the main online repository
(known as CRAN) and many more packages in development can be found on
GitHub. They may be installed and updated over the Internet.

We will mainly use packages which come ready installed with R (base
code), but where it makes things easier we will use add-on packages. In
addition, we have included a few extra functions to simplify the code
required. All the R packages you need for the exercises can be installed
over the Internet.

``` r
# Installing required packages for the week
required_packages <- c("ggplot2", "skimr", "Hmisc", "epitools", "epiR", "incidence", "here")
install.packages(required_packages)
```

> **n.b.** you should only need to do the above step once.

Run the following code at the beginning of the day to make sure that you
have made available all the packages and functions that you need. Be
sure to include it in any scripts too.

``` r
library("ggplot2")
library("skimr")
library("Hmisc")
library("epiR")
library("incidence")
library("here")
```

``` r
# Functions required

# Adds a function that creates a nice table for output
source(here::here("scripts", "single.variable.analysis.v0.2.R"))
```

The `sva()` function allows calculation of attack rates of multiple
variables at one time. To find out more about the function, first load
it as above and then click on function in the **Global Environment** tab
on the right of the R Studio window.

*R* can hold one or many datasets in memory simultaneously, so there is
usually no need to save intermediate files or close and re-open
datasets.

Data management and *R* scripts
===============================

### Reading in datasets

Open the dataset **copenhagen\_raw.csv** using the `read.csv()` command.
It is also possible to import datasets from other formats, such as
Excel; see appendix for example. Datasets in *R* are stored and can be
referred to using the name it is saved as (in our case “cph”).

``` r
# read in your data from a csv file
# Select separator as comma (sep=",")
# do not import 'string' variables as 'Factors' (stringsAsFactors=FALSE)
# Factors are a special datatype, covered later - character variables are simpler
# dataframe read in and saved in R as "cph"

cph <- read.csv(here::here("data", "copenhagen_raw.csv"), stringsAsFactors = FALSE)
```

### Browsing your dataset

*R Studio* has the nice feature that everything is in one browser
window, so you can browse your dataset and your code without having to
switch between browser windows.

``` r
# to browse your data, use the View command
View(cph)
```

Alternatively, you can also view your dataset by clicking on *cph* in
the top right “global environment” panel of your *R Studio* browser.
Your global environment is where you can see all the datasets, functions
and other things you have running in the current session. (see figure 1
below)

![Browsing your dataset in R
Studio](../../img/screenshots/copenhagen-screenshot1.png)

Most of the variables are coded as numeric variables. Here is the key to
what the values in each varaiable means:

<table>
<colgroup>
<col style="width: 33%" />
<col style="width: 13%" />
<col style="width: 26%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th>Variable name</th>
<th>Type</th>
<th>Categories</th>
<th>Definition</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>sex</td>
<td>Dichotomous</td>
<td>male, female</td>
<td>Gender</td>
</tr>
<tr class="even">
<td>age</td>
<td>Continuous (can be transformed to a categorical one)</td>
<td>NA</td>
<td>Age in years</td>
</tr>
<tr class="odd">
<td>diarrhoea</td>
<td>Dichotomous</td>
<td>1=Yes, 0=No</td>
<td>Had diarrhoea Y/N</td>
</tr>
<tr class="even">
<td>vomiting</td>
<td>Dichotomous</td>
<td>1=Yes, 0=No</td>
<td>Had vomiting Y/N</td>
</tr>
<tr class="odd">
<td>start</td>
<td>Numeric</td>
<td>1=11th,</td>
<td>Date diarrhoea or vomiting started</td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td>2=12th,</td>
<td></td>
</tr>
<tr class="odd">
<td></td>
<td></td>
<td>3=13th,</td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td>4=14th,</td>
<td></td>
</tr>
<tr class="odd">
<td></td>
<td></td>
<td>5=15th,</td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td>6=16th</td>
<td></td>
</tr>
<tr class="odd">
<td>starthour</td>
<td>Categorical</td>
<td>1=00:00-05:59,</td>
<td>6 hour time frame when symptoms started</td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td>2=06:00-11:59,</td>
<td></td>
</tr>
<tr class="odd">
<td></td>
<td></td>
<td>3=12:00-17:59,</td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td>4=18:00-23:59</td>
<td></td>
</tr>
<tr class="odd">
<td>shrimps</td>
<td>Dichotomous</td>
<td>1=Yes, 0=No</td>
<td>Consumption of shrimp</td>
</tr>
<tr class="even">
<td>shrimpsD</td>
<td>Categorical</td>
<td>0=None,</td>
<td>Amount of portions of shrimp consumed</td>
</tr>
<tr class="odd">
<td></td>
<td></td>
<td>1=less than 1 portion,</td>
<td></td>
</tr>
<tr class="even">
<td></td>
<td></td>
<td>2=1 portion,</td>
<td></td>
</tr>
<tr class="odd">
<td></td>
<td></td>
<td>3=more than 1 portion</td>
<td></td>
</tr>
<tr class="even">
<td>veal</td>
<td>Dichotomous</td>
<td>1=Yes, 0=No</td>
<td>Consumption of veal</td>
</tr>
<tr class="odd">
<td>beer</td>
<td>Dichotomous</td>
<td>1=Yes, 0=No</td>
<td>Consumption of beer</td>
</tr>
<tr class="even">
<td>sauce</td>
<td>Dichotomous</td>
<td>1=Yes, 0=No</td>
<td>Consumption of sauce</td>
</tr>
</tbody>
</table>

### Saving your code in R Scripts

You can save your code in R scripts. (see figure 2 below) You can write
comments in your code using “`#`”

![Creating a new R-script in R
studio](../../img/screenshots/copenhagen-screenshot2.png)

### History

The History tab, in the global environment panel in the top right of
your browser, shows you all the commands you have previously run.

If you click on the code in the History tab, it will re-run.

### Describing your dataset

You can view the structure of your dataset using the following commands.
Each of these commands can be run for individual variables also. You can
refer to an individual variable of a dataset by using the `$`, for
example, if you wanted to obtain a summary of the age variable, then you
would write `summary(cph$age)`.

``` r
# str provides an overview of the number of observations and variable types
str(cph)

# summary provides information of variable class as well as extra details for numeric variables
summary(cph)

# skim (from skimr) and describe (from Hmisc package) both provide
#   number of observations, missing values, unique levels of each variable
skimr::skim(cph)
Hmisc::describe(cph)
```

> **n.b.** we are using the convention package::function() to make it
> clear when we are using a function that comes from an external
> package.  
> \# Data cleaning and recoding in *R*

Check the dataset “Copenhagen.csv”
----------------------------------

Using the “table” command, you can get information on how the counts of
cases are split across a variable. Using the “summary” command, you can
obtain summary measures, such as the median and quantiles. In the
example below we look at age in the cph dataset.

You can examine a variable within a dataset using the `$` sign and then
the variable name (e.g. `cph$age`). Alternatively, you can also refer to
a dataset using square brackets, the part before a comma refers to the
rows and after refers to columns (named or numerically). Or visually:
`cph[row , column]`. For example: `cph[, "age"]` gives you the variable
age as a vector, or `cph[2:4, ]` gives you rows two to four.

You can subset a dataset using `[...]` in combination with double-equals
(`==`), does not equal (`!=`), and less or greater than (`<`, `>`).

In *R*, when defining the filter this can be both numerical or text
(i.e. the gender example). In order to combine multiple filtering
commands in to one selection you can use the “`|`” (bar not capital i)
or “`&`” symbols. The **`|`** stands for **or** whereas the **`&`**
stands for **and**.

To select cases which are empty, use `is.na()`, for those which are not,
`!is.na(...)`. The exclamation mark (“`!`”) implies “not” in this
situation.

You can add new variables to a dataframe by using the `$` sign after the
dataset name and writing a name not already in the dataset, then
defining what should go in that variable.

``` r
# table will give a very basic frequency table (counts),
# in this example the first line of the output is the age and the second is the frequency.
table(cph$age)
```

    ## 
    ##   8  15  16  17  18  19  20  26  29  30  31  32  33  34  39  43  54  56 
    ##   1  11  99 115 112  39   3   1   1   1   1   1   1   1   1   1   1   1 
    ##  58  59  61  65 180 
    ##   2   1   1   1   1

``` r
# summary gives you more detailed statistics
summary(cph$age)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    8.00   16.00   17.00   18.68   18.00  180.00

Often, plotting the data can be much more informative. For example,
instead of using table, we can plot a histogram of age to see if we have
any outliers:

``` r
hist(cph$age,
     main = "Distribution of Age", 
     xlab = "Age",
     ylab = "Count",
     col = "palegreen")

rug(cph$age)
```

![](practical-copenhagen-intro_files/figure-markdown_github/density_of_age-1.png)

> Question: Is there anything weird about these data?

``` r
# You can look at age among teachers using the group variable
table(cph$age[cph$group == 0])
```

    ## 
    ## 26 29 30 31 32 33 34 39 43 54 56 58 59 61 65 
    ##  1  1  1  1  1  1  1  1  1  1  1  2  1  1  1

``` r
### Things you may have noticed:

# an outlier in incubation
summary(cph$incubation)
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    ##     3.0    15.0    15.0    19.9    21.0   210.0     177

``` r
# people did not have dinner but ate tuna, bread or veal
  # you can label the table by adding labels
table(meal = cph$meal, tuna = cph$tuna)
```

    ##     tuna
    ## meal   0   1
    ##    0   7   1
    ##    1 102 271

``` r
table(meal = cph$meal, bread = cph$bread)
```

    ##     bread
    ## meal   0   1
    ##    0   5   3
    ##    1  29 342

``` r
table(meal = cph$meal, veal = cph$veal)
```

    ##     veal
    ## meal   0   1
    ##    0   6   2
    ##    1  36 338

``` r
# people with day of onset but no symptoms
  # is.na() returns True/False if value is missing
  # So this selects the participants that are either 0 or missing for all three symptoms
no_symptoms <- function(x){
  x != 1 | is.na(x)
}

table(onset = cph$start[no_symptoms(cph$diarrhoea) &
                        no_symptoms(cph$vomiting)  &
                        no_symptoms(cph$bloody)    ])
```

    ## onset
    ## 1 2 
    ## 2 2

Data cleaning
-------------

### Handling missing values, typos and recoding variables

``` r
# correct mistakes in age
cph$age[cph$age == 8]   <- 18
cph$age[cph$age == 180] <- 18


# calculate your own age variable based on birthday
  # Choose the first day of symptom onset as date to calculate from
cph$age2 <- (as.Date("2006-11-11") - as.Date(cph$birthday)) / 365.25
# change this to a number and round it
cph$age2 <- round(as.numeric(cph$age2), digits = 0)


# correct mistake in incubation time
cph$incubation[cph$incubation == 210] <- 21

# Correct mistake regarding onset start
  # Those who have no symptoms should also not have an onset date
  # So this is selecting those that are 0 or empty for each of the three symptoms
  # We can use the no_symptoms function we defined above and place them into a vector
symptomless_dvb <- no_symptoms(cph$diarrhoea) & no_symptoms(cph$vomiting) & no_symptoms(cph$bloody)
table(symptomless_dvb) # how many were symptomless?
```

    ## symptomless_dvb
    ## FALSE  TRUE 
    ##   219   178

``` r
cph$start[symptomless_dvb] <- NA
```

### Creating a case definition

> Remember, in order to combine multiple filtering commands in to one
> selection you can use the “`|`” (bar not capital i) or “&” symbols.
> The **`|`** stands for **or** whereas the **`&`** stands for **and**.

``` r
# create new variable where people who have diarrhoea or vomiting get a 1 and all others a 0
cph$case <- 0
cph$case[cph$diarrhoea == 1 | cph$vomiting == 1] <- 1

# replace those who had onset before 11th nov 18:00 or after 13th nov 18:00
before_11_nov <- cph$start == 1 & cph$starthour < 4
after_13_nov <- (cph$start == 3 & cph$starthour > 3) | cph$start > 3

cph$case[cph$case == 1 & (before_11_nov | after_13_nov)] <- 0

cph$case[is.na(cph$meal) | cph$meal == 0] <- NA
```

Do a plausibility check to see if everything worked

``` r
# how many cases did you generate?
table(cph$case)
```

    ## 
    ##   0   1 
    ## 162 215

``` r
# check if people were assigned properly according to symptoms

table(case = cph$case, vomiting = cph$vomiting)
```

    ##     vomiting
    ## case   0   1
    ##    0  42   0
    ##    1 107  66

``` r
table(case = cph$case, diarrhoea = cph$diarrhoea)
```

    ##     diarrhoea
    ## case   0   1
    ##    0  40   0
    ##    1   6 206

Drop cases that do not meet the case definition

``` r
cph <- cph[!is.na(cph$case), ]
```

### Saving cleaned data

You can save your cleaned dataset in two ways:

1.  as a flat csv file.
2.  as a binary R data file (`*.rds`).

Saving as a flat csv file means that it’s easier to inspect and move the
data between non-R programs, but you lose any special formatting or
attributes you may have attached to it. Saving as an R data file allows
you to seamlessly move data between R sessions without worry that it
will accidentally change formatting.

Saving your intermediate, cleaned dataset allows you to perform
multi-facetted analyses with the same dataset and avoid having to
re-clean it over and over again.
<!-- You can save your cleaned dataset as an R datafile (.Rda) using the *save* command and re-load the same dataset using the *load* command.  -->
<!-- In reality you would never do this; your code should be stand-alone in that raw data is read and cleaned and analysis comes thereafter.  -->
<!-- But if you wanted to, this is how you would do it.  -->

``` r
# save as a flat csv file:
write.csv(cph, file = here::here("data", "clean_copenhagen.csv"), row.names = FALSE)
# read the file
cph2 <- read.csv(file = here::here("data", "clean_copenhagen.csv"), stringsAsFactors = FALSE)
identical(cph, cph2)

# save as a R data file
saveRDS(cph, file = here::here("data", "clean_copenhagen.rds"))
# read in the file
cph2 <- readRDS(file = here::here("data", "clean_copenhagen.rds"))
identical(cph, cph2)
```

Throughout the tutorial, we have saved the clean data for each section.

Part 2
------

Now that the data have been cleaned and inspected, we can move on to
[descriptive statistics in part 2](./copenhagen-descriptive.html).

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
