---
title: "Outbreak of gastroenteritis after a high school dinner in Copenhagen, Denmark,November 2006 (part 2)"

author: "Zhian N. Kamvar, Janetta Skarp, Alexander Spina, and Patrick Keating"
authors: ["Zhian N. Kamvar", "Janetta Skarp", "Alexander Spina", "Patrick Keating", "Thibaut Jombart"]
categories: ["practicals"]
tags: ["epicurve", "single variable analysis", "2x2 tables"]
date: 6911-10-04
image: img/highres/van-der-helst-banquet-02.png
slug: copenhagen-descriptive
showonlyimage: true
licenses: CC-BY
---


<img src="../img/under-review.png" alt="Under Review: this practical is currently being revised and may change in the future">

Descriptive analysis in *R*
===========================

This practical is a continuation of the analysis concerning the outbreak
of gastroenteritis after a high school dinner in Copenhagen, Denmark.
The [introduction to this case is presented in part
1](./copenhagen-introduction.html), which focussed on initial data
inspection and cleaning. This practical will focus on descriptive stats
including 2x2 tables and epicurves.

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
# dataframe read in and saved in R as "cph"


cph <- read.csv(here::here("data", "copenhagen_descriptive.csv"),
                stringsAsFactors = FALSE) 
```

Dataset description and tabulation
----------------------------------

### Basic graphics

In the following, we show how *ggplot2* can be used for visualising the
data. Unlike the basic plotting system in **R**, *ggplot2* proceed by
building a graphic by combining different items, tied together using the
`+` operator: specifing the data (`ggplot()`), adding geometric elements
(i.e. type of graph, using `geom_...`), and aesthetic properties mapping
data into visual features (e.g. axis, color, shape, using `aes()`). Here
is a basic example plotting the distribution of ages using a boxplot:

``` r
ggplot(cph) + geom_boxplot(aes(x = sex, y = age))
```

![](practical-copenhagen-descriptive_files/figure-markdown_github/age_boxplot-1.png)

Other *geoms* can be used, several can be combined, and *aesthetics*
common to all *geoms* can be input to *ggplot*. Here are a few examples:

``` r
ggplot(cph, aes(x = sex, y = age)) + 
  geom_violin() +
  geom_jitter(aes(color = sex), alpha = 0.4)
```

![](practical-copenhagen-descriptive_files/figure-markdown_github/age_violin-1.png)

``` r
ggplot(cph, aes(x = age, fill = sex)) + geom_histogram()
```

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](practical-copenhagen-descriptive_files/figure-markdown_github/age_violin-2.png)

Also note that the default theme can be customised, e.g.:

``` r
my_plot <- ggplot(cph, aes(x = sex, y = age)) + 
  geom_violin() +
  geom_jitter(aes(color = sex), alpha = 0.4)

my_plot
```

![](practical-copenhagen-descriptive_files/figure-markdown_github/custom_ggplot-1.png)

``` r
my_plot + theme_bw(base_size = 20, base_family = "times")
```

![](practical-copenhagen-descriptive_files/figure-markdown_github/custom_ggplot-2.png)

For more information on how *ggplot2*, check the [dedicated
website](https://ggplot2.tidyverse.org/).

### Describe signs and symptoms of cases

We will use 2x2 tables with percentages to describe the signs and
symptoms of all the cases. To do this, we must tabulate the counts,
calculate the proportions of those counts, and then combine those into a
single table. Here’s an example of the table for cases that have
diarrhoea:

``` r
# create a frequency table diarrhoea among cases
a <- table(cph$diarrhoea[cph$case == 1])

# frequencies divided by total cases (as proportion) and rounded to one decimal place
props <- round(prop.table(a) * 100, digits = 1)

# bind a column (cbind) to the above table with:
b <- cbind(n = a, prop = props)
b
```

    ##     n prop
    ## 0   6  2.8
    ## 1 206 97.2

However, we have a lot of variables we want to do this over, it’s better
to write a function that can do this for us over and over again. The key
to writing a function to to look at a procedure and think about what
parts stay the same and what parts change. In the case of our 2x2 table,
the only thing that changes is the vector we want to describe. If we
replace that by a variable called “x”, we can write our function like
so:

``` r
twobytwo <- function(x) {
  # create a frequency table diarrhoea among cases
  a <- table(x)

  # frequencies divided by total cases (as proportion) and rounded to one decimal place
  props <- round(prop.table(a) * 100, digits = 1)

  # bind a column (cbind) to the above table with:
  b <- cbind(n = a, prop = props)
  b
}
```

> **n.b.** This function is *portable*, meaning that I can copy it to
> any other R script and it will work exactly the same.

Now that we have our function, we can create the table with just one
line:

``` r
twobytwo(cph$diarrhoea[cph$case == 1])
```

    ##     n prop
    ## 0   6  2.8
    ## 1 206 97.2

``` r
twobytwo(cph$bloody[cph$case == 1])
```

    ##     n prop
    ## 0 147 97.4
    ## 1   4  2.6

Of course, we have several variables, we don’t necessarily want to write
this over and over, so we will use a function called `lapply()`. This
function takes a dataframe, list, or vector, applies a function over
each variable separately, and then returns a list of results. If we were
to use `lapply()` to get the results from above, we might do this:

``` r
vars <- c("diarrhoea", "bloody")
lapply(cph[cph$case == 1, vars, drop = FALSE], FUN = twobytwo)
```

    ## $diarrhoea
    ##     n prop
    ## 0   6  2.8
    ## 1 206 97.2
    ## 
    ## $bloody
    ##     n prop
    ## 0 147 97.4
    ## 1   4  2.6

Now you try it with the following variables:

``` r
vars <- c("diarrhoea", "bloody", "vomiting", "abdo", "nausea", "fever", "headache", "jointpain")
```

    ## $diarrhoea
    ##     n prop
    ## 0   6  2.8
    ## 1 206 97.2
    ## 
    ## $bloody
    ##     n prop
    ## 0 147 97.4
    ## 1   4  2.6
    ## 
    ## $vomiting
    ##     n prop
    ## 0 107 61.8
    ## 1  66 38.2
    ## 
    ## $abdo
    ##     n prop
    ## 0  29 15.2
    ## 1 162 84.8
    ## 
    ## $nausea
    ##     n prop
    ## 0  43 24.3
    ## 1 134 75.7
    ## 
    ## $fever
    ##    n prop
    ## 0 95 72.5
    ## 1 36 27.5
    ## 
    ## $headache
    ##     n prop
    ## 0  72 40.9
    ## 1 104 59.1
    ## 
    ## $jointpain
    ##     n prop
    ## 0 127 84.7
    ## 1  23 15.3

### Determine the median incubation period

``` r
summary(cph$incubation[cph$case == 1])
```

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##    3.00   15.00   15.00   19.05   21.00   45.00

### Describe the cohort in terms of person

``` r
# look at age and other variables of interest
Hmisc::describe(cph$age)
```

    ## cph$age 
    ##        n  missing distinct     Info     Mean      Gmd      .05      .10 
    ##      377        0       20    0.935    18.32    3.247       16       16 
    ##      .25      .50      .75      .90      .95 
    ##       16       17       18       19       19 
    ##                                                                       
    ## Value         15    16    17    18    19    20    26    29    31    32
    ## Frequency     11    95   106   111    36     3     1     1     1     1
    ## Proportion 0.029 0.252 0.281 0.294 0.095 0.008 0.003 0.003 0.003 0.003
    ##                                                                       
    ## Value         33    34    39    43    54    56    58    59    61    65
    ## Frequency      1     1     1     1     1     1     2     1     1     1
    ## Proportion 0.003 0.003 0.003 0.003 0.003 0.003 0.005 0.003 0.003 0.003

### Calculate the overall attack rates as well as the attack rates stratified by person characteristic

Remember, you can also refer to a dataset using square brackets, the
part before a comma refers to the rows and after refers to columns
(named or numerically). Or visually: `cph[row, column]`. For example:
`cph[ , "age"]` gives you the variable age as a vector, or `cph[2:4 , ]`
gives you rows two to four.

This is a very similar procedure to the 2x2 tables above, except now we
want to include the non-cases. We’ll demonstrate it for “group” first:

``` r
tab  <- table(cph$group, cph$case)

# create a table of proportions
prop <- round(prop.table(tab, margin = 1) * 100, digits = 1)

# bind the column with AR from b to the 2by2 table in a
res  <- cbind(tab, prop[, 2, drop = TRUE])

# rename your columns
colnames(res) <- c("non case", "case", "AR%")
res
```

    ##   non case case  AR%
    ## 0        9    6 40.0
    ## 1      153  209 57.7

Much like the function we used above, only one thing changes: the
variable of interest, but we also need to have a vector of cases to
complete the table. Since functions should be stand-alone, we will
create another variable called “case”:

``` r
AR <- function(x, case) {
  tab  <- table(x, case)

  # create a table of proportions
  prop <- round(prop.table(tab, margin = 1) * 100, digits = 1)

  # bind the column with AR from b to the 2by2 table in a
  res  <- cbind(tab, prop[, 2, drop = TRUE])

  # rename your columns
  colnames(res) <- c("non case", "case", "AR%")
  res
}
```

We can see that it works for group:

``` r
AR(cph$group, case = cph$case)
```

    ##   non case case  AR%
    ## 0        9    6 40.0
    ## 1      153  209 57.7

Now we can use it with lapply, supplying our “case” argument after the
function name. This is explained in the help documentation for “lapply”

``` r
# students and sex
vars <- c("group", "class", "sex")
lapply(cph[vars], AR, case = cph$case)
```

    ## $group
    ##   non case case  AR%
    ## 0        9    6 40.0
    ## 1      153  209 57.7
    ## 
    ## $class
    ##   non case case  AR%
    ## 1       63   68 51.9
    ## 2       45   56 55.4
    ## 3       38   73 65.8
    ## 
    ## $sex
    ##        non case case  AR%
    ## female       97  116 54.5
    ## male         65   99 60.4

To see how to combine this code to create a ready-to-present table for
exporting see the appendix.

Describing temporal dynamics
============================

### Recoding for date compatability

Date compatibility is always an issue when switching between softwares,
*R* sometimes has a problem reading in dates from excel files, however
there is user-written code which fixes these kinds of glitches.

In the current dataset it is simply a case of creating useful date
variables by some data manipulation.

The variable *start* is an example of bad data collection. Nevertheless
it consists of numbers (1, 2 and 3); these numbers correspond to dates
(11th, 12th and 13th of November 2006).

``` r
# Create a useful date variable from start
# set yourself a reference date (one day before onset)
refdate <- as.Date("2006-11-10")

# use start to create dates from your start variable
cph$dayonset <- as.Date(refdate + cph$start)
```

### Construct epicurve by day

<!--
It is possible to create an epicurve manually using base-R code (see appendix), however for simplicity, there is a user written function (Daniel Gardener, PHE). 
The epicurve function allows creation of easily formatted epicurves. To find out more about the function, first load it as above and then click on function in the Global Environment tab on the right of the R Studio window.
-->
Epicurves are often a great way of visualizing the dynamics of an
epidemic, but can be easily mis-constructed if done by hand. To make
things easier, the package *incidence* will automatically bin incidence
by day (or any other time interval) and generate a curve. This function
uses the *ggplot2* package (use `?ggplot` to find out more about this
function) and so is quite easily manipulated and saved after being
created.

``` r
cph_incidence <- incidence::incidence(cph$dayonset, interval = 1)
plot(cph_incidence)
```

![](practical-copenhagen-descriptive_files/figure-markdown_github/epicurve-1.png)

Conclusions from the descriptive analyses
=========================================

We didn’t find anything surprising in the descriptive analysis of the
cohort’s age given it consists of two groups, the students and the
teachers.

The distribution of the cohort regarding sex, group and class also
didn’t reveal anything unusual. Students seem a bit more affected by the
outbreak than teachers and the attack rate is higher for older students
in higher classes. This, however, is a purely descriptive result.

The above results are in line with norovirus as the prime suspect, but
the symptoms are not a textbook fit. There are too few people that
experienced vomiting!

Part 3
======

The analysis continues with [univariate analyses in part
3](./copenhagen-univariate.html)

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
