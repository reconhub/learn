---
title: "Outbreak of gastroenteritis after a high school dinner in Copenhagen, Denmark,November 2006 (part 4)"
author: "Zhian N. Kamvar, Janetta Skarp, Alexander Spina, and Patrick Keating"
output:
  html_document
authors: ["Zhian N. Kamvar", "Janetta Skarp", "Alexander Spina", "Patrick Keating"]
categories: ["practicals"]
tags: ["epicurve", "single variable analysis", "2x2 tables"]
date: 6911-10-04
image: img/highres/van-der-helst-banquet-04.png
slug: copenhagen-stratified
showonlyimage: true
licenses: CC-BY
---


<img src="../img/under-review.png" alt="Under Review: this practical is currently being revised and may change in the future">


Stratified analysis
===================

This practical is a continuation of the analysis concerning the outbreak
of gastroenteritis after a high school dinner in Copenhagen, Denmark.
The [introduction to this case is presented in part
1](./copenhagen-intro.html), which focussed on initial data inspection
and cleaning. [Part 2](./copenhagen-descriptive.html) focussed on
descriptive statistics. From [the univariate analysis conducted in part
3](./copenhagen-univariate.html), you can see that those eating pasta or
veal as well as drinking champagne have the highest risk of becoming
ill. There are, however, many other food items that are associated with
an increased risk (even if not statistically significant). At this stage
we cannot conclude anything, but need to check for effect modification
and confounding. This should be done by stratification.

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

cph <- read.csv(here::here("data", "copenhagen_stratified.csv"),
                stringsAsFactors = FALSE)
```

Make sure that your variables of interest are factors in the correct
order. Outcome and exposure variables of interest need to be factor
variables prior to using the function, in order to be relevelled from
(0,1) to (1,0) so that they can be correctly organised in 2-by-2 tables.
(We have already done this for our variables)

``` r
# We list the outcome/exposure variables
vars <- c("shrimps", "veal", "pasta", "sauce", "champagne", "rocket", "case")


# Convert all of those variables to factor variables and re-order the levels to aid interpretation
for (var in vars) {
  cph[[var]] <- factor(cph[[var]], levels = c(1, 0))
}
```

The `epi.2by2()` function in the *epiR* package can be used to identify
effect modifiers/confounders.

``` r
# Make a 3-way table with exposure of interest, the outcome and the stratifying variable, in that order
a <- table(cph$veal, cph$case, cph$pasta)

# Use the epi.2by2 function to calculate RRs (by stating method = "cohort.count")
mhtable <- epiR::epi.2by2(a, method = "cohort.count")

# view the output
mhtable
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
    ## 
    ## Point estimates and 95 % CIs:
    ## -------------------------------------------------------------------
    ## Inc risk ratio (crude)                       1.52 (1.00, 2.31)
    ## Inc risk ratio (M-H)                         1.14 (0.64, 2.03)
    ## Inc risk ratio (crude:M-H)                   1.33
    ## Odds ratio (crude)                           2.28 (1.13, 4.61)
    ## Odds ratio (M-H)                             1.29 (0.45, 3.73)
    ## Odds ratio (crude:M-H)                       1.76
    ## Attrib risk (crude) *                        20.28 (3.52, 37.05)
    ## Attrib risk (M-H) *                          6.19 (-116.53, 128.91)
    ## Attrib risk (crude:M-H)                      3.28
    ## -------------------------------------------------------------------
    ##  Test of homogeneity of IRR: X2 test statistic: 0.137 p-value: 0.711
    ##  Test of homogeneity of  OR: X2 test statistic: 0.083 p-value: 0.773
    ##  Wald confidence limits
    ##  M-H: Mantel-Haenszel
    ##  * Outcomes per 100 population units

You can then extract various outputs from the `epiR::epi.2by2()` table
for piecing together your own output. Take a couple of mintues to scan
the documentation for `epiR::epi.2by2()` to see what outputs are named.

> *hint:* in your R console, type `?epiR::epi.2by2()` and look for the
> section called “Value” Here two levels of `$`-signs are needed, as the
> function saves outputs to a list.

``` r
# Crude RR
mhtable$massoc$RR.crude.wald
```

    ##        est    lower    upper
    ## 1 1.521555 1.000777 2.313334

``` r
# Stratum specific RRs
mhtable$massoc$RR.strata.wald
```

    ##        est     lower    upper
    ## 1 1.193939 0.5937236 2.400934
    ## 2 1.050000 0.3773566 2.921639

``` r
# Adjusted RR
mhtable$massoc$RR.mh.wald
```

    ##        est     lower    upper
    ## 1 1.141738 0.6405961 2.034927

``` r
# You can combine all of those elements in to a single table using rbind
results <- rbind(
  mhtable$massoc$RR.crude.wald,
  mhtable$massoc$RR.strata.wald,
  mhtable$massoc$RR.mh.wald
)


# We can label the rows of this table as below
rownames(results) <- c("Crude", "Strata 1", "Strata 0", "Adjusted")

# view output table
results
```

    ##               est     lower    upper
    ## Crude    1.521555 1.0007766 2.313334
    ## Strata 1 1.193939 0.5937236 2.400934
    ## Strata 0 1.050000 0.3773566 2.921639
    ## Adjusted 1.141738 0.6405961 2.034927

Like we did before, we can use these steps to write a function:

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

Now we can run all of the variables at once

``` r
# List the exposure variables
vars <- c("veal", "rocket", "shrimps", "champagne", "sauce")
# run strata_risk for each one using pasta as strata
lapply(cph[vars], strata_risk, case = cph$case, strat = cph$pasta)
```

    ## $veal
    ##               est     lower    upper
    ## Crude    1.521555 1.0007766 2.313334
    ## Strata 1 1.193939 0.5937236 2.400934
    ## Strata 0 1.050000 0.3773566 2.921639
    ## Adjusted 1.141738 0.6405961 2.034927
    ## 
    ## $rocket
    ##                est      lower     upper
    ## Crude    0.8681467 0.72741416 1.0361066
    ## Strata 1 0.8235294 0.69114596 0.9812698
    ## Strata 0 0.3636364 0.05592816 2.3643083
    ## Adjusted 0.8048371 0.67387797 0.9612463
    ## 
    ## $shrimps
    ##               est     lower    upper
    ## Crude    1.052964 0.8686243 1.276425
    ## Strata 1 1.016949 0.8377118 1.234536
    ## Strata 0 1.101852 0.4635572 2.619046
    ## Adjusted 1.022840 0.8454977 1.237380
    ## 
    ## $champagne
    ##               est     lower    upper
    ## Crude    1.350981 0.9676189 1.886229
    ## Strata 1 1.394552 0.9844555 1.975482
    ## Strata 0 0.862069 0.2635860 2.819432
    ## Adjusted 1.344662 0.9633515 1.876903
    ## 
    ## $sauce
    ##               est     lower    upper
    ## Crude    1.123279 0.9340155 1.350894
    ## Strata 1 1.075893 0.8926480 1.296754
    ## Strata 0 1.090909 0.3379015 3.521981
    ## Adjusted 1.076414 0.8948041 1.294884

The exact same can be done for veal (switch veal and pasta)

``` r
# List the exposure variables
vars <- c("pasta", "rocket", "shrimps", "champagne", "sauce")
# run strata_risk for each one using veal as strata
lapply(cph[vars], strata_risk, case = cph$case, strat = cph$veal)
```

    ## $pasta
    ##               est     lower    upper
    ## Crude    1.646791 1.0570739 2.565498
    ## Strata 1 1.591919 0.6478873 3.911493
    ## Strata 0 1.400000 0.5967549 3.284431
    ## Adjusted 1.509126 0.8010437 2.843116
    ## 
    ## $rocket
    ##                est     lower     upper
    ## Crude    0.8681467 0.7274142 1.0361066
    ## Strata 1 0.8373409 0.7015432 0.9994249
    ## Strata 0 0.5252525 0.1428526 1.9312932
    ## Adjusted 0.8210678 0.6872771 0.9809031
    ## 
    ## $shrimps
    ##                est     lower    upper
    ## Crude    1.0529644 0.8686243 1.276425
    ## Strata 1 0.9858156 0.8135252 1.194594
    ## Strata 0 1.7000000 0.7126936 4.055038
    ## Adjusted 1.0269359 0.8503386 1.240209
    ## 
    ## $champagne
    ##                est     lower    upper
    ## Crude    1.3509813 0.9676189 1.886229
    ## Strata 1 1.3865827 0.9786528 1.964549
    ## Strata 0 0.9482759 0.2942761 3.055726
    ## Adjusted 1.3455170 0.9639351 1.878151
    ## 
    ## $sauce
    ##               est     lower    upper
    ## Crude    1.123279 0.9340155 1.350894
    ## Strata 1 1.068421 0.8860069 1.288391
    ## Strata 0 1.363636 0.4598608 4.043624
    ## Adjusted 1.076885 0.8954576 1.295070

It appears that pasta confounds the association between eating veal and
being a case. For a variable to be a confounder it needs to be
associated both with the outcome (being a case) and with the exposure.
We know from univariable analysis that pasta is associated with being a
case, we can now check if it is also associated with veal.

``` r
# using a fisher's exact test

fisher.test(table(cph$pasta, cph$veal))
```

    ## 
    ##  Fisher's Exact Test for Count Data
    ## 
    ## data:  table(cph$pasta, cph$veal)
    ## p-value < 2.2e-16
    ## alternative hypothesis: true odds ratio is not equal to 1
    ## 95 percent confidence interval:
    ##   45.38863 482.22379
    ## sample estimates:
    ## odds ratio 
    ##   136.7379

Integrate the analysis steps in one master script file
======================================================

This is easily done, if you have saved each of your analyses in a
separate script (e.g. one for cleaning, descriptive, univariable and
stratified each), you can create a master script by using the
`rmarkdown::render()` function.

Open a new R file and save it as `runAll.R`. Inside of this script, put
the following:

    rmarkdown::render(here::here("reports", "01-intro.Rmd"))
    rmarkdown::render(here::here("reports", "02-descriptive-stats.Rmd"))
    rmarkdown::render(here::here("reports", "03-univariate-analysis.Rmd"))
    rmarkdown::render(here::here("reports", "04-stratified-analysis.Rmd"))

Conclusions of the stratified analysis
--------------------------------------

We found that pasta consumption confounds the association between eating
veal and being ill. The crude (univariable) result for veal suggests
that veal is a risk factor (crude RR = 1.52, CI: 1.00-2.31), but when we
adjust for the consumption of pasta we see that actually this result is
due to the fact that most people who ate veal also ate pasta. Within the
stratum of the people who ate pasta, veal has no effect (RR = 1.19, CI:
0.59-2.40). The same holds within the stratum of people who didn’t eat
pasta (RR = 1.05, CI = 0.38, 2.92). This is why the adjusted MH-RR also
suggests that veal has no effect (RRadj = 1.14, CI: 0.64-2.03). This
result taken together with the dose response relationship we found
earlier for pasta gives additional evidence that there was something
going on with the pesto!

Microbiological analyses
------------------------

### Local clinical microbiology laboratory

The finding of *Salmonella spp.* is surprising because one would expect
a median incubation period of at least 24 hours in a Salmonella
outbreak. A look at the epidemic curve tells us that the median
incubation period in this outbreak was &lt;18 hours. It would also be
unusual to have such a low proportion of positive stool samples (3 of
20), if Salmonella was the only pathogen causing the outbreak. Most
microbiology laboratories use conventional methods (culture and
microscopy) for routine detection of common bacterial enteric pathogens;
molecular approaches are used by specialised laboratories to screen for
key pathogens and their virulence genes. Further microbiological
investigation is required involving specialised assays that are only
usually undertaken by a reference laboratory, namely, detection assays
for diarrhoeagenic *Escherichia coli* and norovirus. All stool samples
implicated in the outbreak should be examined for these pathogens also.

### Reference laboratory results

The fact that this was an outbreak where several aetiological agents
were identified, may point to a contamination from an environmental
source. It also makes it less likely that kitchen staff excreting
bacteria could have contaminated the food (and we already know that
kitchen staff claimed not to have had symptoms, and that their stools
tested negative). ETEC is among the leading bacterial causes of
diarrhoea in the developing world in particular among children, as well
as the most common cause of travellers’ diarrhoea. It is increasingly
being recognised as an important cause of diarrhoea also in the
developed world. ETEC is transmitted by food or water contaminated with
human (or maybe animal) faeces. ETEC is defined by the expression of one
or more enterotoxins. Two such classes of toxins exist, heat-labile
enterotoxin (LT) and heat-stable enterotoxin (ST). ETEC may produce
either LT, ST or both. Both toxins directly cause diarrhoea, but other
virulence factors also exist. LT is similar to the cholera toxin.
Infection with ETEC can cause profuse watery diarrhea and abdominal
cramping. Illness develops somewhat quicker than for other bacterial
enteric infections, because of the presence of the toxins. Symptoms
appear 1-3 days after exposure and usually last 3-4 days. Some
infections may take a week or longer to resolve. Symptoms rarely last
more than 3 weeks. Most patients recover with supportive measures alone
and do not require hospitalization or antibiotics. Diagnostics is not
easily performed; most laboratories do not test for ETEC.

Note that the field of diarrhoeagenic *E. coli* involves other types
also. *E. coli* constitute a large group of bacteria that occur
naturally in the intestines of humans and animals. Most are
non-pathogenic. However, several (six are generally recognized) groups
of diarrhoea causing *E. coli*, exist. These include ETEC, but also
other groups, among which are:

+EPEC (enteropathogenic *E. coli*), cause diarrhoea through an
infectious mechanism not involving toxins. It mostly affects children
under the age of 2. Is transmitted from person-to-person, sometimes via
foods. + STEC, (shiga toxin producing *E. coli*), STEC (also known as
VTEC and EHEC) are similar to EPECs in many ways, but additionally
express shiga toxins. Because of this, these strains may cause HUS,
haemolytic uremic syndrome.

### Food sample results

ETEC can be very difficult to isolate from food samples. Not isolating
ETEC therefore does not exclude that ETEC was present in the sample. It
is just extremely difficult to find it among all the other E.coli (a bit
like looking for a needle in a haystack). In fact the presence of very
high counts of generic *E. coli* in the food, suggests that ETEC was
also there. One strategy to increase the success would be to use an
enrichment step. That means letting the bacteria grow - before trying to
isolate ETEC - for some hours under conditions, where growth of ETEC
would be favoured above other types of *E. coli* (if such conditions can
be established). Or, if for instance it was known that the ETEC strain
isolated from cases was resistant to a specific set of antibiotics, this
could be utilized in the isolation process, by growing the food extracts
in a medium containing these antibiotics. An alternative strategy would
be to use PCRs directly addressing the ETECs or to detect the toxins
directly. However, as the pathogenic ETEC likely were present in small
amounts, this would also be difficult.

### PFGE results

The four *Salmonella anatum* strains were found to have the same PFGE
profile and 100% identity on the dendogram. The *S. anatum* isolate
found in the food was also typed by PFGE and found to have the same
profile. The other strains show greater diversity within the dendogram
confirming that they are distinguishable strains. Concerning ETEC,
sixteen of the 17 O92:H- isolates were indistinguishable by PFGE whereas
the PFGE profile of the remaining O92:H- isolate differed from the
others by a few bands.

Conclusions of the investigation
--------------------------------

In summary, it is fair to say that there was both epidemiological and
microbiological evidence that the pasta salad with pesto was the most
likely vehicle of transmission in this outbreak. Further investigations
focused on how the pasta salad with pesto could have become contaminated
and on lessons learned from this outbreak that could then communicated
both the scientific community, the caterer and the general public.

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
