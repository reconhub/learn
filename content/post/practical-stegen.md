---
title: "An outbreak of gastroenteritis in Stegen, Germany, June 1998"
author: "Janetta Skarp, Zhian N. Kamvar, Alexander Spina, Patrick Keating and Thibaut Jombart"
authors: ["Thibaut Jombart", "Janetta Skarp", "Zhian N. Kamvar", "Alexander Spina", "Patrick Keating"]
categories: "case study"
tags: ["level: beginner", "epicurve", "single variable analysis", "2x2 tables", "gastroenteritis"]
date: 2018-10-24
slug: stegen
licenses: CC-BY
image: img/highres/graduation-1965.jpg
showonlyimage: true
---

Context
=======

On 26 June 1998, the St Sebastian High School in Stegen (school A),
Germany, celebrated a graduation party, where 250 to 350 participants
were expected. Attendants included graduates from that school, their
families and friends, teachers, 12th grade students, and some graduates
from a nearby school (school B).

A self-service party buffet was supplied by a commercial caterer in
Freiburg. Food was prepared on the day of the party and transported in a
refrigerated van to the school.

Festivities started with a dinner buffet open from 8.30 pm onwards and
were followed by a dessert buffet offered from 10 pm. The party and the
buffet extended late during the night and alcoholic beverages were quite
popular. All agreed it was a party to be remembered.

The alert
---------

On 2nd July 1998, the Freiburg local health office reported to the
Robert Koch Institute (RKI) in Berlin the occurrence of many cases of
gastroenteritis following the graduation party described above. More
than 100 cases were suspected among participants and some of them were
admitted to nearby hospitals. Sick people suffered from fever, nausea,
diarrhoea and vomiting lasting for several days. Most believed that the
tiramisu consumed at dinner was responsible for their illness.
*Salmonella enteritidis* was isolated from 19 stool samples.

The Freiburg health office sent a team to investigate the kitchen of the
caterer. Food preparation procedures were reviewed. Food samples, except
tiramisu (none was left over), were sent to the laboratory of Freiburg
University. Microbiological analyses were performed on samples of the
following: brown chocolate mousse, caramel cream, remoulade sauce,
yoghurt dill sauce, and 10 raw eggs.

The Freiburg health office requested help from the RKI in the
investigation to assess the magnitude of the outbreak and identify
potential vehicle(s) and risk factors for transmission in order to
better control the outbreak.

The epidemiological study
-------------------------

**Case definition**: cases were defined as any person who had attended
the party at St Sebastian High School and who suffered from *diarrhoea*
(min. 3 loose stool for 24 hours) between 27 June and 29 June 1998, or
from at least three of the following symptoms: *vomiting*, *fever over
38.5° C*, *nausea*, *abdominal pain*, *headache*.

Students from both schools attending the party were asked through phone
interviews to provide names of persons who attended the party.

Overall, 291 responded to enquiries and 103 cases were identified. The
linelist analysed in this case study was built from these 291 responses.

This case study
---------------

In this case study, we will take you through the analysis of this
epidemic. This will be the occasion to illustrate more generally useful
practices for data analysis using **R**, including:

-   how to read data from Excel
-   how to explore data using tables and summaries
-   how to clean data
-   how to make graphics to describe the data
-   how to test if specific food items are linked to the disease

Initial data processing
=======================

Loading required packages
-------------------------

The following packages will be used in the case study:

-   `here`: to find the path to data or script files
-   `readxl`: to read Excel spreadsheets into **R**
-   `incidence`: to build epicurves

To avoid having to specify the name of the package whenever we use a
function using the syntax `package_name::function_name()`, we load these
packages using `library`:

``` r
library(here)      # find data/script files
library(readxl)    # read xlsx files
library(incidence) # make epicurves
library(epitrix)   # clean labels and variables
library(dplyr)     # general data handling
library(ggplot2)   # advanced graphics
```

Note that you will get an error if the packages have not been installed
on your system. To install them (you only need to do this once!), type:

``` r
install.packages("here")
install.packages("readxl")
install.packages("incidence")
install.packages("epitrix")
install.packages("dplyr")
install.packages("ggplot2")
```

Loading these packages makes all functions implemented by the packages
available, so that `function_name()` can be used directly (without the
`package_name::` prefix). This is not a problem here as these packages
do now implement functions with identical names.

Importing data from Excel
-------------------------

Linelist data can be read from various formats, including flat text
files (e.g. `.txt`, `.csv`), other statistical software (e.g. STATA) or
Excel spreadsheets. We illustrate the latter, which is probably the most
common format. We assume that the data file `stegen_raw.xlsx` has been
saved in a `data/` folder of your project, and that your current R
session is at the root of the project.

Here we decompose the steps to read data in: finding the path to the
data (`path_to_data`), using the function `read_xlsx` to read data in,
and saving the output in a new object `stegen`:

``` r
path_to_data <- here("data", "stegen_raw.xlsx")
stegen <- read_xlsx(path_to_data)
```

To print the content of the dataset, we can use either of these
commands:

``` r
stegen
## # A tibble: 291 x 21
##    `Unique key`   ill `Date-onset`   SEX   Age tiramisu tportion wmousse
##           <dbl> <dbl> <chr>        <dbl> <dbl>    <dbl>    <dbl>   <dbl>
##  1          210     1 1998-06-27       1    18        1        3       0
##  2           12     1 1998-06-27       0    57        1        1       0
##  3          288     1 1998-06-27       1    56        0        0       0
##  4          186     1 1998-06-27       0    17        1        1       1
##  5           20     1 1998-06-27       1    19        1        2       0
##  6          148     1 1998-06-27       0    16        1        2       1
##  7          201     1 1998-06-27       0    19        1        3       0
##  8          106     1 1998-06-27       0    19        1        2       1
##  9          272     1 1998-06-27       1    40        1        2       1
## 10           50     1 1998-06-27       0    53        1        1       1
## # ... with 281 more rows, and 13 more variables: dmousse <dbl>,
## #   mousse <dbl>, mportion <dbl>, Beer <dbl>, redjelly <dbl>, `Fruit
## #   salad` <dbl>, tomato <dbl>, mince <dbl>, salmon <dbl>,
## #   horseradish <dbl>, chickenwin <dbl>, roastbeef <dbl>, PORK <dbl>
## View(stegen)
```

<details>
<summary><b>Problems?</b> In case of trouble, click here to toggle
additional help:</summary>

<!-- <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#stegen_help_1">Show additional help</button> -->
<!--   <div id="stegen_help_1" class="collapse"> -->
If the above fails, you should check:

-   that your data file has been saved in the right folder, with the
    right name (lower case and upper case do matter)
-   that your R session was started from the right project - if unsure,
    close R and re-open Rstudio by double-clicking on the `.Rproj` file
-   that all packages are installed and loaded (see installation
    guidelines above)

</details>
Overview and summaries
----------------------

We first have a quick look at the content of the data set. The
information we are looking for is:

-   the numbers of cases (rows) and variables (columns) in the data
-   the *name* of the variables: do they use consistent capitalisation
    and separators?
-   the *type* of the variables: are dates, numeric or categorical
    variables used when they should?
-   the *coding* of the variables: are explicit labels (e.g.
    `"male"`/`"female"`) used where relevant?

We first check the dimensions of the `stegen` object, and the name of
the variables:

``` r
dim(stegen) # rows x columns
## [1] 291  21
names(stegen) # column labels
##  [1] "Unique key"  "ill"         "Date-onset"  "SEX"         "Age"        
##  [6] "tiramisu"    "tportion"    "wmousse"     "dmousse"     "mousse"     
## [11] "mportion"    "Beer"        "redjelly"    "Fruit salad" "tomato"     
## [16] "mince"       "salmon"      "horseradish" "chickenwin"  "roastbeef"  
## [21] "PORK"
```

We can now try and summarise the dataset using:

``` r
summary(stegen)
##    Unique key         ill         Date-onset             SEX        
##  Min.   :  1.0   Min.   :0.000   Length:291         Min.   :0.0000  
##  1st Qu.: 73.5   1st Qu.:0.000   Class :character   1st Qu.:0.0000  
##  Median :146.0   Median :0.000   Mode  :character   Median :1.0000  
##  Mean   :146.0   Mean   :0.354                      Mean   :0.5223  
##  3rd Qu.:218.5   3rd Qu.:1.000                      3rd Qu.:1.0000  
##  Max.   :291.0   Max.   :1.000                      Max.   :1.0000  
##                                                                     
##       Age           tiramisu         tportion         wmousse      
##  Min.   :12.00   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000  
##  1st Qu.:18.00   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000  
##  Median :20.00   Median :0.0000   Median :0.0000   Median :0.0000  
##  Mean   :26.66   Mean   :0.4231   Mean   :0.6678   Mean   :0.2599  
##  3rd Qu.:27.00   3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:1.0000  
##  Max.   :80.00   Max.   :1.0000   Max.   :3.0000   Max.   :1.0000  
##  NA's   :8       NA's   :5        NA's   :5        NA's   :14      
##     dmousse           mousse          mportion           Beer       
##  Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.0000  
##  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000  
##  Median :0.0000   Median :0.0000   Median :0.0000   Median :0.0000  
##  Mean   :0.3937   Mean   :0.4256   Mean   :0.6523   Mean   :0.3911  
##  3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:1.0000  
##  Max.   :1.0000   Max.   :1.0000   Max.   :3.0000   Max.   :1.0000  
##  NA's   :4        NA's   :2        NA's   :12       NA's   :20      
##     redjelly       Fruit salad        tomato           mince      
##  Min.   :0.0000   Min.   :0.000   Min.   :0.0000   Min.   :0.000  
##  1st Qu.:0.0000   1st Qu.:0.000   1st Qu.:0.0000   1st Qu.:0.000  
##  Median :0.0000   Median :0.000   Median :0.0000   Median :0.000  
##  Mean   :0.2715   Mean   :0.244   Mean   :0.2852   Mean   :0.299  
##  3rd Qu.:1.0000   3rd Qu.:0.000   3rd Qu.:1.0000   3rd Qu.:1.000  
##  Max.   :1.0000   Max.   :1.000   Max.   :1.0000   Max.   :1.000  
##                                                                   
##      salmon        horseradish       chickenwin       roastbeef      
##  Min.   :0.0000   Min.   :0.0000   Min.   :0.0000   Min.   :0.00000  
##  1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.0000   1st Qu.:0.00000  
##  Median :0.0000   Median :0.0000   Median :0.0000   Median :0.00000  
##  Mean   :0.4811   Mean   :0.3093   Mean   :0.2887   Mean   :0.09966  
##  3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:1.0000   3rd Qu.:0.00000  
##  Max.   :9.0000   Max.   :9.0000   Max.   :1.0000   Max.   :1.00000  
##                                                                      
##       PORK       
##  Min.   :0.0000  
##  1st Qu.:0.0000  
##  Median :0.0000  
##  Mean   :0.4742  
##  3rd Qu.:1.0000  
##  Max.   :9.0000  
## 
```

Note that binary variables, when treated as numeric values (0/1), are
summarised at such, which may not always be useful. As an alternative,
`table` can be used to list all possible values of a variable, and count
how many time each value appears in the data. For instance, we can
compare the `summary` and `table` for consumption of `tiramisu`:

``` r
stegen$tiramisu # all values
##   [1]  1  1  0  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##  [24]  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1
##  [47]  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  1  0  1  1  1 NA  1
##  [70]  0  1  1 NA  1  1  1  1  1  1  1  1  1  1  1  0  1  1  0  1  1  1  1
##  [93]  1  0  1  1  1  1  0  0  0  0  0  0  0  0  1  0  1  0  0  1  0  0  0
## [116]  0  0  0 NA  1  0  0  1  0  0  0  0  0  1  0  0  0  0  1  0  0  0  0
## [139]  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1  0  0  0  0  0  0  0  1
## [162]  0  0  1  0  0  0  0  0  0  0  0  0  0  1  1  0  0  0  0  0  0  0  0
## [185]  0  0  0 NA  0  0  0  0  0  1  0  0  1  0  1  1  0  0  0  0  1  0  0
## [208]  0  0  0  0  0  1  0  0  1  0  0  0  0  1  0  0  1  0  0  0  1  1  0
## [231]  0  0  0  0  0  1  0  0  0  0  0  0  0  1  0  1  0  0  0  0  0  0  0
## [254]  0  0  1  0  0  0  1  0  0  0  1  0  0  0  0  0  0 NA  0  1  0  0  0
## [277]  0  0  0  0  0  0  0  0  0  0  0  0  0  0  1
summary(stegen$tiramisu) # summary
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##  0.0000  0.0000  0.0000  0.4231  1.0000  1.0000       5
table(stegen$tiramisu) # table
## 
##   0   1 
## 165 121
```

**Good news**: the dataset has the expected dimensions, and all the
relevant variables seem to be present. There are, however, **a few
issues**:

1.  variable names are a bit messy, and include different separators,
    spaces, and irregular capitalisation
2.  variable types are partly wrong:
    -   *unique keys* should be `character` (i.e. character strings)
    -   *dates of onset* should be `Date` (**R** is good at handling
        actual dates)
    -   *illness* and *sex* should be `factor` (i.e. a categorical
        variables)
3.  labels used in some variables are ambiguous:
    -   *sex* should be coded explicitely, not as 0 (here, male) and 1
        (here, female)
    -   *illness* should be coded explicitely, not as 0 (here, non-case)
        and 1 (case)
4.  some binary variables have maximum values of 9 (see
    `summary(stegen)`)

Data cleaning
-------------

While it is tempting to go back to the Excel spreadsheet to fix issues
with data, it is almost always quicker and more reliable to clean data
in **R** directly. Here, we make a copy of the old data set, and clean
`stegen` before further analysis.

``` r
stegen_old <- stegen # save 'dirty data'
```

We use `epitrix`’s function `clean_labels` to standardise the variable
names:

``` r
new_labels <- clean_labels(names(stegen)) # generate standardised labels
new_labels # check the result
##  [1] "unique_key"  "ill"         "date_onset"  "sex"         "age"        
##  [6] "tiramisu"    "tportion"    "wmousse"     "dmousse"     "mousse"     
## [11] "mportion"    "beer"        "redjelly"    "fruit_salad" "tomato"     
## [16] "mince"       "salmon"      "horseradish" "chickenwin"  "roastbeef"  
## [21] "pork"
names(stegen) <- new_labels
```

We set convert the unique identifiers to character strings
(`character`), dates of onset to actual `Date` objects, and sex and
illness are set to categorical variables (`factor`):

``` r
stegen$unique_key <- as.character(stegen$unique_key)
stegen$sex <- factor(stegen$sex)
stegen$ill <- factor(stegen$ill)
stegen$date_onset <- as.Date(stegen$date_onset)
```

We use the function `recode` from the `dplyr' package to recode`sex\`
more explicitely:

``` r
stegen$sex <- recode_factor(stegen$sex, "0" = "male", "1" = "female")
stegen$ill <- recode_factor(stegen$ill, "0" = "non case", "1" = "case")
```

Finally we look in more depth into these variables having maximum values
of 9, where we expect 0/1; `table` is useful to list all values taken by
a variable, and listing their frequencies:

``` r

table(stegen$pork)
## 
##   0   1   9 
## 169 120   2
table(stegen$salmon)
## 
##   0   1   9 
## 183 104   4
table(stegen$horseradish)
## 
##   0   1   9 
## 217  72   2
```

The only rogue values are `9`; they are likely either data entry issues,
or missing data, which in **R** should be coded as `NA` (“not
available”). We can replace these values using:

``` r
stegen$pork[stegen$pork == 9] <- NA
stegen$salmon[stegen$salmon == 9] <- NA
stegen$horseradish[stegen$horseradish == 9] <- NA
```

**Going further** click on the button below for more explanation:

<details>
<summary> <b> Why does this work? </b> </summary>
<!-- <button type="button" class="btn btn-info" data-toggle="collapse" data-target="#stegen_help_2">Why does this work?</button> -->
<!--   <div id="stegen_help_2" class="collapse"> -->

There are several things going on in a command like:

``` r
stegen$pork[stegen$pork == 9] <- NA
```

let us break them down:

1.  `stegen$pork` means “get the variable called `pork` in the dataset
    `stegen`”
2.  `[...]` subset the vector according to `...`; if `...` is a series
    of `TRUE/FALSE` values, only entries corresponding to `TRUE` are
    retained
3.  `... == 9` for each value of `...` test if it is equal to `9`, and
    return `TRUE` if so (`FALSE` otherwise)
4.  `... <- NA` replace `...` with `NA` (missing value)

in other words: "isolate the entries of `stegen$pork` which equal `9`,
and replace them with `NA`; here is another toy example to illustrate
the procedure:

``` r
## make toy input vector
toy_vector <- 1:5
toy_vector
## [1] 1 2 3 4 5

## make toy logical vector for subsetting
toy_logical <- c(FALSE, TRUE, TRUE, FALSE, TRUE)
toy_logical
## [1] FALSE  TRUE  TRUE FALSE  TRUE
toy_vector[toy_logical] # subset values
## [1] 2 3 5
toy_vector[toy_logical] <- 0 # replace subset values
toy_vector # check outcome
## [1] 1 0 0 4 0
```

</details>
Data exploration
================

Summaries of age and sex distribution
-------------------------------------

We can have a brief look at age and sex distributions using some basic
summaries; for instance:

``` r
summary(stegen$age) # age stats
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   12.00   18.00   20.00   26.66   27.00   80.00       8
summary(stegen$sex) # gender distribution
##   male female 
##    139    152
tapply(stegen$age, stegen$sex, summary) # age stats by gender      
## $male
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   12.00   17.50   19.00   26.38   28.00   80.00       4 
## 
## $female
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
##   13.00   18.00   20.00   26.93   24.50   65.00       4
```

<p>
**Going further** click on the button below to learn about `tapply`:
</p>
<button type="button" class="btn btn-info" data-toggle="collapse" data-target="#stegen_help_3">More
about `tapply`</button>

<p>
`tapply` is a very handy function to stratify any kind of analyses. You
will find more details by reading the documentation of the function
`?tapply`, but briefly, the syntax to be used is
`tapply(input_data, stratification, function_to_use, optional_arguments)`.
In the command used above:

``` r
tapply(stegen$age, stegen$sex, summary)
```

this literally means: select the age variable in the dataset `stegen`
(`stegen$age`), stratify it by sex (`stegen$sex`), and summaries each
strata (`summary`). So for instance, to get the average age by sex
(function `mean`), one could use:

``` r
tapply(stegen$age, stegen$sex, mean, na.rm = TRUE)
##     male   female 
## 26.37778 26.92568
```

Here we illustrate that further arguments to the function can be passed
as extra arguments; here, `na.rm = TRUE` means “ignore missing data”.

</p>

Graphical exploration
---------------------

The summaries above may be useful for reporting purposes, but graphics
are usually better for getting a feel for the data. Here, we illustrate
how the package `ggplot2` can be used to derive informative graphics of
age/sex distribution. It implements an alternative graphics system to
the basic **R** plots, in which the plot is built by adding (literally
using `+`) different layers of information, using:

-   `ggplot()` to specify the dataset to use
-   `geom_...()` functions which define a type of graphics to use
    (e.g. barplot, histogram)
-   `aes()` to map elements of the data into aesthetic properties
    (e.g. x/y axes, color, shape)

For instance, to get an histogram of age:

``` r
ggplot(stegen) + geom_histogram(aes(x = age))
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](practical-stegen_files/figure-markdown_github/stegen_histogram-1.png)

Color can be added using:

``` r
ggplot(stegen) + geom_histogram(aes(x = age, fill = sex))
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](practical-stegen_files/figure-markdown_github/stegen_histogram_sex-1.png)

Here, the age distribution is pretty much identical between male and
female.

<p>
**Going further** click on the button below to learn about customising
`ggplot2` graphics:
</p>
<button type="button" class="btn btn-info" data-toggle="collapse" data-target="#stegen_help_4">More
on `ggplot2`</button>

<p>
`ggplot2` graphics are highly customisable, and a lot of help and
examples can be found online. The [official
website](https://ggplot2.tidyverse.org/) is a good place to start.

For instance, here we:

-   add white borders to the plot (`color = "white"`)
-   specify colors manually for male / female, using specified color
    codes (see [html color
    picker](https://www.w3schools.com/colors/colors_picker.asp) to
    define your own colors) (`scale_fill_manual(...)`)
-   adding labels for title, *x* and *y* axes (`labs()`)
-   specify a lighter general color theme, using Times font of a larger
    size by default (`theme_light(...)`)
-   move the legend inside the plot (`theme(...)`)

``` r
ggplot(stegen) + geom_histogram(aes(x = age, fill = sex), color = "white") +
  scale_fill_manual(values = c(male = "#4775d1", female = "#cc6699")) +
  labs(title = "Age distribution by gender", x = "Age (years)", y = "Number of cases") +
  theme_light(base_family = "Times", base_size = 16) +
  theme(legend.position = c(0.8, 0.8))
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](practical-stegen_files/figure-markdown_github/stegen_ggplot2_custom-1.png)

</p>

Epidemic curve
--------------

Incidence curves can be built using the package `incidence`, which will
compute the number of new cases given a vector of dates (here, onset)
and a time interval (1 day by default). We use the function `incidence`
to achieve this, and then visualise the results:

``` r
i <- incidence(stegen$date_onset)
i
## <incidence object>
## [131 cases from days 1998-06-26 to 1998-07-09]
## 
## $counts: matrix with 14 rows and 1 columns
## $n: 131 cases in total
## $dates: 14 dates marking the left-side of bins
## $interval: 1 day
## $timespan: 14 days
## $cumulative: FALSE
plot(i)
```

![](practical-stegen_files/figure-markdown_github/stegen_incidence-1.png)

Details of the case counts can be obtained using:

``` r
as.data.frame(i)
##         dates counts
## 1  1998-06-26      1
## 2  1998-06-27     56
## 3  1998-06-28     51
## 4  1998-06-29     10
## 5  1998-06-30      3
## 6  1998-07-01      3
## 7  1998-07-02      3
## 8  1998-07-03      0
## 9  1998-07-04      1
## 10 1998-07-05      1
## 11 1998-07-06      1
## 12 1998-07-07      0
## 13 1998-07-08      0
## 14 1998-07-09      1
```

How long is this outbreak? It looks like most cases occurred over the
course of 3 days, but that cases kept showing up 10 days after the peak.
Is this true? Not really. Stratifying the epidemic curve by case
definition will clarify the situation:

``` r
i_ill <- incidence(stegen$date_onset, group = stegen$ill)
i_ill
## <incidence object>
## [131 cases from days 1998-06-26 to 1998-07-09]
## [2 groups: case, non case]
## 
## $counts: matrix with 14 rows and 2 columns
## $n: 131 cases in total
## $dates: 14 dates marking the left-side of bins
## $interval: 1 day
## $timespan: 14 days
## $cumulative: FALSE
as.data.frame(i_ill)
##         dates case non case
## 1  1998-06-26    0        1
## 2  1998-06-27   48        8
## 3  1998-06-28   46        5
## 4  1998-06-29    8        2
## 5  1998-06-30    0        3
## 6  1998-07-01    0        3
## 7  1998-07-02    0        3
## 8  1998-07-03    0        0
## 9  1998-07-04    0        1
## 10 1998-07-05    0        1
## 11 1998-07-06    0        1
## 12 1998-07-07    0        0
## 13 1998-07-08    0        0
## 14 1998-07-09    0        1
plot(i_ill, color = c("non case" = "#66cc99", "case" = "#990033"))
```

![](practical-stegen_files/figure-markdown_github/incidence_stratified-1.png)

The outbreak really only happened over 3 days: onsets reported after did
not match the epi case definition. This is compatible with a food-borne
outbreak with limited or no person-to-person transmission.

Note that the plots produced by `incidence` are `ggplot2` objects, so
that the options seen before can be used for further customisation (see
below).

<p>
**Going further** click on the button below to learn about `incidence`:
</p>
<button type="button" class="btn btn-info" data-toggle="collapse" data-target="#stegen_help_5">More
on `incidence`</button>

<p>
More information on the `incidence` package can be found from the
[dedicated website](https://www.repidemicsconsortium.org/incidence/).
Here, we illustrate how incidence can be stratified e.g. by case
definition:

We can also customise this graphic like other `ggplot2` plots (see [this
tutorial](https://www.repidemicsconsortium.org/incidence/articles/customize_plot.html)
for more):

``` r
plot(i_ill, border = "white", color = c("non case" = "#66cc99", "case" = "#990033")) + 
  labs(title = "Epicurve by gender", x = "Date of onset", y = "Number of cases") +
  theme_light(base_family = "Times", base_size = 16) +
  geom_hline(yintercept = 1:55, color = "white") +
  theme(legend.position = c(0.8, 0.8), axis.text.x = element_text(angle = 45, hjust = 1, vjust = 0.5))
```

![](practical-stegen_files/figure-markdown_github/incidence_stratified_custom-1.png)

</p>

Age and gender distribution of the cases
----------------------------------------

We use the same principles as before to visualise the distribution of
illness by age and gender. To split the plot into different panels
according to `sex`, we use `facet_grid()` (see previous extra info on
`ggplot2` customisation for further details otions):

``` r
ggplot(stegen) + geom_histogram(aes(x = age, fill = ill)) +
  scale_fill_manual("Illness", values = c("non case" = "#66cc99", "case" = "#990033")) +
  facet_grid(sex ~ .) + labs(title = "Cases by age and gender") + theme_light()
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

![](practical-stegen_files/figure-markdown_github/stegen_case_age_sex-1.png)

Illness does not seem to be depending on age or gender. This can be
tested: this is the topic of the next and final section.

Looking for the culprits
========================

Univariate tests
----------------

Methods for testing the association between two variables can be broken
down in 3 types, depending on which types these variables are:

1.  **2 quantitative variables**: Pearson’s correlation coefficient
    (*r*) and similar methods
2.  **1 quantitative, 1 categorical**: ANOVA types of approaches;
    particular case with 2 groups: Student’s*t*-test
3.  **2 categorical variables**: Chi-squared test on the 2x2 table
    (a.k.a. *contingency* table) and similar methods (e.g. Fisher’s
    exact test)

We can use these approaches to test if the disease is linked to any of
the other recorded variables. As illness itself is a categorical
variable, only approaches of type 2 and 3 will be illustrated here.

### Is illness linked to age?

We can use the function `t.test` to test if the average age is different
across illness status. As this test assumes that the two categories
exhibit similar variation, we first ensure that the variances are
comparable using Bartlett’s test. The syntax`variable ~ group` is used
to indicate the variable of interest (left hand-side), and the group
(right hand-side):

``` r
bartlett.test(stegen$age ~ stegen$ill)
## 
##  Bartlett test of homogeneity of variances
## 
## data:  stegen$age by stegen$ill
## Bartlett's K-squared = 0.82311, df = 1, p-value = 0.3643
```

The resulting p-value (0.364) suggests the variances are indeed
comparable. Wecan thus proceed to a *t*-test:

``` r
t.test(stegen$age ~ stegen$ill, var.equal = TRUE)
## 
##  Two Sample t-test
## 
## data:  stegen$age by stegen$ill
## t = -0.55979, df = 281, p-value = 0.5761
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -4.509729  2.512679
## sample estimates:
## mean in group non case     mean in group case 
##               26.31148               27.31000
```

The p-value of 0.576 confirms the previous graphics: the illness does
not seem to be linked to age.

### Is illness linked to gender?

To test the association between gender and illness (2 categorical
variables), we first build a 2-by-2 (contingency) table, using:

``` r
tab_ill_sex <- table(stegen$ill, stegen$sex)
tab_ill_sex
##           
##            male female
##   non case   86    102
##   case       53     50
```

Note that proportions can be obtained using `prop.table`:

``` r
## basic proportions
prop.table(tab_ill_sex)
##           
##                 male    female
##   non case 0.2955326 0.3505155
##   case     0.1821306 0.1718213

## expressed in %, rounded:
round(100 * prop.table(tab_ill_sex))
##           
##            male female
##   non case   30     35
##   case       18     17
```

Once a contingency table has been built, the Chi-square test can be run
using `chisq.test`:

``` r
chisq.test(tab_ill_sex)
## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  tab_ill_sex
## X-squared = 0.6562, df = 1, p-value = 0.4179
```

Here, the p-value of 0.418 suggests illness is not related to sex
either.

Making multiple tests
---------------------

The natural next step is to run multiple tests for all potential risk
factors recorded. There are many ways to go about this in **R**, but we
will illustrate one of the most common workflows:

1.  isolate a subset of variables to test (the ones indicative of food
    consumption) (using `[]`)
2.  for each:
    1.  build contingency table with illness status (using `table`)
    2.  run a Chi-square test on this table (using `chisq.test`)

All of these have been seen so far; the only missing piece is step 2),
which we will cover using a very handy function called `lapply`.

### Isolating the variables to test

We use the natural structure of the dataset, as variables representing
food consumption are all the last columns:

``` r
names(stegen)
##  [1] "unique_key"  "ill"         "date_onset"  "sex"         "age"        
##  [6] "tiramisu"    "tportion"    "wmousse"     "dmousse"     "mousse"     
## [11] "mportion"    "beer"        "redjelly"    "fruit_salad" "tomato"     
## [16] "mince"       "salmon"      "horseradish" "chickenwin"  "roastbeef"  
## [21] "pork"
```

In this case, we need to retain columns 6 to 21, excluding `tportion`
and `mportion`, which are not binary; this can be done using the
subsetting operator `[...]`, where `...` are numbers indicating the
columns to retain:

``` r
to_keep <- c(6, 8, 9, 10, 12:21)
to_keep
##  [1]  6  8  9 10 12 13 14 15 16 17 18 19 20 21
food <- stegen[to_keep]
food
## # A tibble: 291 x 14
##    tiramisu wmousse dmousse mousse  beer redjelly fruit_salad tomato mince
##       <dbl>   <dbl>   <dbl>  <dbl> <dbl>    <dbl>       <dbl>  <dbl> <dbl>
##  1        1       0       1      1     0        0           0      0     0
##  2        1       0       1      1     0        0           1      0     1
##  3        0       0       0      0     0        0           0      1     1
##  4        1       1       0      1     0        1           0      0     0
##  5        1       0       0      0     1        0           0      0     0
##  6        1       1       1      1     0        0           1      0     1
##  7        1       0       1      1     0        0           1      0     0
##  8        1       1       1      1     0        1           1      0     0
##  9        1       1       1      1     1        0           0      1     0
## 10        1       1       1      1     0        1           0      0     0
## # ... with 281 more rows, and 5 more variables: salmon <dbl>,
## #   horseradish <dbl>, chickenwin <dbl>, roastbeef <dbl>, pork <dbl>
```

### Building several contingency tables

There are many variables to test, and having to enter separate command
lines for each would be cumbersome and prone to errors. As a workaround,
the function `lapply` can be used. This function allows to repeat an
operation using a vector of inputs, using each element in turn. Its
general syntax is
`lapply(vector_of_inputs, function_to_use, other_arguments)`, where
`other_arguments` can be any secondary arguments taken by
`function_to_use`. Here, we use it to build a separate contingency table
of each variable in `food` crossed with illness status (`stegen$ill`);
note that we show only the first few tables:

``` r
food_tables <- lapply(food, table, stegen$ill)
head(food_tables)
## $tiramisu
##    
##     non case case
##   0      158    7
##   1       27   94
## 
## $wmousse
##    
##     non case case
##   0      156   49
##   1       23   49
## 
## $dmousse
##    
##     non case case
##   0      148   26
##   1       37   76
## 
## $mousse
##    
##     non case case
##   0      144   22
##   1       42   81
## 
## $beer
##    
##     non case case
##   0       96   69
##   1       76   30
## 
## $redjelly
##    
##     non case case
##   0      154   58
##   1       34   45
```

### Realising multiple Chi-squared tests

The same principle used to compute several contingency tables can be
used to compute Chi-square tests for each table, using `lapply`; note
that we show only the first few tests:

``` r
food_tests <- lapply(food_tables, chisq.test)
head(food_tests)
## $tiramisu
## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  X[[i]]
## X-squared = 161.64, df = 1, p-value < 2.2e-16
## 
## 
## $wmousse
## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  X[[i]]
## X-squared = 43.526, df = 1, p-value = 4.183e-11
## 
## 
## $dmousse
## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  X[[i]]
## X-squared = 79.574, df = 1, p-value < 2.2e-16
## 
## 
## $mousse
## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  X[[i]]
## X-squared = 82.943, df = 1, p-value < 2.2e-16
## 
## 
## $beer
## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  X[[i]]
## X-squared = 4.519, df = 1, p-value = 0.03352
## 
## 
## $redjelly
## 
##  Pearson's Chi-squared test with Yates' continuity correction
## 
## data:  X[[i]]
## X-squared = 20.781, df = 1, p-value = 5.148e-06
```

Looking at these results, it seems a large number of food items are
significantly correlated to the illness. Which food item is the biggest
suspect? We will try and address this question using risk ratios.

Risk ratios
-----------

### For one variable

The [risk ratio](https://en.wikipedia.org/wiki/Risk_ratio) is defined as
the ratio between the proportion of illness in one group (typically
‘exposed’) vs another (‘non-exposed’). For instance, let us consider the
contingency table of pork consumption and illness:

``` r
food_tables$pork
##    
##     non case case
##   0      115   54
##   1       72   48
```

This can be turned into proportions using `prop.table`, specifying that
we want proportions by rows (`margin = 1`):

``` r
pork_prop <- prop.table(food_tables$pork, margin = 1)
pork_prop
##    
##      non case      case
##   0 0.6804734 0.3195266
##   1 0.6000000 0.4000000
```

the corresponding risk ratio is:

``` r
## ill & exposed: row 2, column 2
pork_prop[2, 2] # row 2, column 2
## [1] 0.4

## ill & non-exposed: row 1, column 2
pork_prop[1, 2]
## [1] 0.3195266

## compute the risk ratio
pork_rr <- pork_prop[2, 2] / pork_prop[1, 2]
pork_rr
## [1] 1.251852
```

Note the use of the syntax `[rows, columns]` to subset specific rows and
columns of 2-dimensional objects.

### Multiple variables

In the example above, we have computed the risk ratio using a simple
recipe:

1.  select a contingency table
2.  convert raw numbers to proportions (using `prop.table`)
3.  isolating the risks in exposed and non-exposed groups, and compute
    their ratio

Repeating these tasks manually for all variables in `food` would be
cumbersome. As an alternative, we can define the steps above as
`function`, i.e. a generic recipe which we can then apply to any
contingency table. This new function will be called `risk_ratio`, and is
defined as follows:

``` r
risk_ratio <- function(tab) { # 'tab' is a placeholder for the input 2x2 table
  ## compute table of proportions
  tab_prop <- prop.table(tab, margin = 1)
  
  ## compute the risk ratio
  result <- tab_prop[2, 2] / tab_prop[1, 2]

  ## return the output
  return(result) # this will be the output of the function
}
```

We can now try this function on any of the tables in `food_tables`, for
instance:

``` r
food_tables$pork
##    
##     non case case
##   0      115   54
##   1       72   48
risk_ratio(food_tables$pork)
## [1] 1.251852
```

And we can now apply this function sequentially to all variables in
`food` as before, using `lapply` (we show only the first few values):

``` r
all_rr <- lapply(food_tables, risk_ratio)
## all_rr
## $tiramisu
## [1] 18.31169
## 
## $wmousse
## [1] 2.847222
## 
## $dmousse
## [1] 4.501021
## 
## $mousse
## [1] 4.968958
## 
## $beer
## [1] 0.6767842
## 
## $redjelly
## [1] 2.08206
```

Finally, we re-shape these results into a numeric `vector` (using
`unlist)` for further plotting; note that for this graph, the basic
system is easier to use than `ggplot2`:

``` r
## convert results from list to numeric vector
rr_data <- unlist(all_rr)
rr_data
##    tiramisu     wmousse     dmousse      mousse        beer    redjelly 
##  18.3116883   2.8472222   4.5010211   4.9689579   0.6767842   2.0820602 
## fruit_salad      tomato       mince      salmon horseradish  chickenwin 
##   2.5006177   1.2898653   1.0568237   1.0334249   1.2557870   1.1617347 
##   roastbeef        pork 
##   0.7607985   1.2518519

## sort results by decreasing order
rr_data <- sort(rr_data, decreasing = TRUE)

## plot using the basic system
par(mar = c(5, 7, 4, 1)) # change margins
barplot(rr_data, horiz = TRUE, las = 1,
        xlab = "Risk ratio",
        col = heat.colors(15), # add colors
        main = "Risk ratio by food exposure")
abline(v = 1, lty = 2) # add vertical line x = 1
```

![](practical-stegen_files/figure-markdown_github/stegen_rr_plot-1.png)

The results are a lot clearer now: the tiramisu is by far the largest
risk factor in this outbreak.

Conclusion
==========

This case study illustrated how **R** can be used to import data, clean
them, and derive basic summaries for a first glance at the data. It also
showed how to generate graphics using `ggplot2`, and how to detect
associations between several potential risk factors and the occurrence
of illness. One major caveat here is that we are not accounting for
potential confounding factors. These will be treated in a separate case
study, which will focus on the use of logistic regression in epidemic
studies.

<br> <br> <br>

About this document
===================

Source
------

This case study was first designed by Alain Moren and Gilles Desve,
EPIET. It is based on an investigation conducted by Anja Hauri, RKI,
Berlin, 1998.

Contributors
------------

-   original version: Alain Moren, Gilles Desve

-   reviewers, previous versions: Marta Valenciano, Alain Moren

-   adaptation for EPIET module: Alicia Barrasa, Ioannis Karagiannis

-   rewriting for R: Alexander Spina, Patrick Keating, Janetta Skarp,
    Zhian N. Kamvar, Thibaut Jombart

Contributions are welcome via [pull
requests](https://github.com/reconhub/learn/pulls). The source file can
be found
[here](https://github.com/reconhub/learn/blob/master/static/slides/outbreaker2/outbreaker2.Rmd).

Legal stuff
-----------

**License**: [CC-BY](https://creativecommons.org/licenses/by/3.0/)
**Copyright**: 2018

<br> <br>
