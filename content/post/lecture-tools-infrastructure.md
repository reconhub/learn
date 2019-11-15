---
title: Tools for outbreak analytics infrastructures
author: Thibaut Jombart
authors: ["Thibaut Jombart"]
categories: ["lectures"]
topics: ["rmarkdown", "data science", "reproducibility", "outbreak", "response"]
date: 2018-10-23
image: img/highres/control_room.jpg
slug: infrastructure
showonlyimage: true
css: css/custom.css
licenses: CC-BY
---

Beyond the availability of data and methods, and the use of good practices for reproducible science, the outbreak response context poses a number of practical challenges. In this lecture, we outline tools which can help address some of these challenges, and create more robust and efficient data analytics pipelines using **R**.

Slides
======

**Click on the image below to access the slides:**

<center>
<a href="../../slides/infrastructure/tools_analytics_pipelines.pdf"><img class="gateway" src="../../img/highres/control_room.jpg" width="50%" alt="click there for slides" align="middle"></a>
</center>
Alternatively, you can view these slides directly on [google slides](https://docs.google.com/presentation/d/1998ITavX2hhObnG2DPg0R_wwc0U8XHZJw9gTND9ASAQ/edit?usp=sharing).

Related packages
================

`linelist`
----------

`linelist` provides data cleaning tools which address most of the common problems in epidemiological data. While tailored for case data (hence the name *linelist*), it is very general and will likely be useful in many other contexts. Its main features include:

-   **data standardisation**: ensures consistent capitalisation, separators, and replaces non-ascii characters by their closest ascii match

-   **guess dates**: automatically detects dates, identify their formats, and performs required conversions

-   **dictionary-based cleaning**: applies cleaning rules to fix typos and recode variables according to a user-defined dictionary

For more information on this package, go to: <https://repidemicsconsortium/linelist>.

To install this package, type:

``` r
remotes::install_github("reconhub/linelist")
```

`reportfactory`
---------------

The `reportfactory` provides an infrastructure for handling multiple `Rmd` reports which need regular updating.

For more information on this package, go to: <https://github.com/reconhub/reportfactory>.

To install this package, type:

``` r
remotes::install_github("reconhub/reportfactory")
```

`rmarkdown`
-----------

`rmarkdown` extends the capabilities of `knitr` with a more diverse set of outputs generated from `Rmd` files, including pdf documents, article templates, pdf or html slides, or even web applications.

More information on `rmarkdown` is available from: <http://rmarkdown.rstudio.com/>.

To install this package, type:

``` r
install.packages("rmarkdown")
```

About this document
===================

Contributors
------------

-   Thibaut Jombart: initial version

Contributions are welcome via [pull requests](https://github.com/reconhub/learn/pulls). The source files include:

-   [**the slides**](https://raw.githubusercontent.com/reconhub/learn/master/static/slides/reproducibility/reproducibility.Rmd)

-   [**this document**](https://docs.google.com/presentation/d/1998ITavX2hhObnG2DPg0R_wwc0U8XHZJw9gTND9ASAQ/edit?usp=sharing)

Legal stuff
-----------

**License**: [CC-BY](https://creativecommons.org/licenses/by/3.0/) **Copyright**: Thibaut Jombart, 2017
