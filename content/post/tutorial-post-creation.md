---
title: How to create a new post for the site
author: Locke Data
authors: ["Locke Data"]
categories: ["tutorials"]
topics: ["website"]
date: 2018-08-23
image: img/highres/post-creation.jpg
showonlyimage: yes
licenses: CC-BY
always_allow_html: yes
output: 
  md_document:
    variant: markdown_github
    preserve_yaml: true
---

In this article we explain how to contribute new posts and slidedecks
for the website.

## General workflow for contributing

If you’re new to git and GitHub [check out this nifty
guide](http://happygitwithr.com/).

The general workflow would include the following steps:

1.  [**Fork the project**](https://github.com/reconhub/learn/fork) from
    the GitHub *RECON learn* project:

This will create a copy of the project in your own GitHub account. You
will need to clone this archive, and make the modifications there. You
`git clone` would look like:

``` bash
git clone https://johnsnow@github.com/johnsnow/learn
```

If your GitHub user name is `johnsnow`.

1.  Open the project in Rstudio and run `devtools::install()`

2.  **Add new content**, typically in the form of a new `.Rmd` file and
    associated media (most often images). See more details [in the
    following section for posts](#post-creation) or in the [section
    about slidedecks](#slidedeck-creation).

3.  **Generate content** by knitting your new Rmd via RStudio’s knit
    button or by running `learn::render_new_rmds_to_md()` to build the
    `.md` files and associated graphics.

4.  `git commit` and `git push` all changes; don’t forget to add new
    images as well (run `git status` to see which files haven’t been
    added).

5.  Make a **pull request** against the main project (`master` branch),
    from the GitHub *RECON learn* project. Make sure you use
    `reconhub/learn`, branch `master` as base fork. Every pull request
    will trigger a new deploy of the website, so that new versions can
    be visualised online (see section *Visualising the changes* below)

## Creating posts <a name="post-creation"></a>

Practicals, tutorials, case studies are contributed as [R
Markdown](http://rmarkdown.rstudio.com/) (`.Rmd`) documents and
generated markdown ready for conversion as `.md` documents. They are
stored in `content/post`. The best way to create a new document is to
use the `create_post()` function. For instance, this post was created
using:

``` r
learn::create_post(title = "How to create a new post for the site",
                   slug = "post-creation",
                   category = "tutorials",
                   author = "Locke Data")
```

See `?create_post()` to see further parameters. `create_post()` creates
and opens the Rmd file, creates a default .bib and a blank place-holder
image that you can replace with your own header image.

### Conventions

File-naming conventions are as follows:

  - start with `practical` for practicals, `study` for case studies
    (handled by `create_post()`)
  - use an informative slug.
      - use lower case, no special characters
      - be hypen-separated (“-”)

For instance, for a practical using a SEIR model for influenza data:

  - `seir-influenza` is a good slug
  - `SEIR-flu` is bad because it has capitalised letters
  - `new` is bad, as it is non-informative

### Editing the YAML header

The YAML header is the beginning of the `Rmd` document, within the
`---`. For instance:

``` r
---
title: Phylogenetic tree reconstruction
author: Thibaut Jombart
authors: ["Jombart, Thibaut"]
categories: ["practicals"]
topics: ["genetics"]
date: 2017-11-01
image: img/highres/trees.jpg
showonlyimage: true
bibliography: practical-phylogenetics.bib
licenses: CC-BY
always_allow_html: yes
output: 
  md_document:
    variant: markdown_github
    preserve_yaml: true
---
```

Fields are mostly self-explanatory, and can be adapted to your needs.
The date should respect the format provided. When using `create_post` as
shown earlier, many fields will have been filled for you.

### Referencing packages

You can load packages or use functions via the typical methods
`library("tidyverse")`, `require("magrittr")`, `dplyr::mutate()` and
folks can run `learn::get_and_update_dependencies()` file to get all
packages mentioned in the `content/posts` directory.

This means you do not need to have mandatory install statements - you
can make these `eval=FALSE`.

### Storing images

The **image** will be the image associated with the document on the
website. We try using natural, high-resolution, evocative images having
a link, if only figurative, with the topic covered. These images are
stored in `static/img/highres/`. Do not forget to add and push this file
as well, as it will be required for your post to be successfully
integrated. The path to the file provided in the header assumes
`static/` as root folder (see example above), so that the right path
will look like: `img/highres/your-image.jpg`.

### Bibliographies

The **`bibliography`** is optional. If provided, it should contain
references cited in the document as a `bibtex` file (`.bib`). Do not
forget to add and push this file as well, as it will be required for
your post to be successfully integrated.

`create_post` create a .bib by default. If you don’t need it, delete it
and delete the corresponding YAML field.

### HTML widgets (plotly, leaflet…)

If your post features an interactive plot or map, please use the
`save_and_use_widget` function.

``` r
map <- leaflet::leaflet()
learn::save_and_use_widget(map, "map.html")
```

<!--html_preserve-->

<iframe src="widgets/map.html" width="100%" height="500px">

</iframe>

<!--/html_preserve-->

### Be nice

As many files could be generated in one go, please don’t use any
`rm(list=ls())` types of activities. Make your code play nicely with
others – use specific and useful names, don’t mess around with the
global environment, and don’t force any package unloads.

## Contributing slides <a name="slidedeck-creation"></a>

Material for slides is stored in `static/slides`. Currently, two files
are needed for a lecture:

1.  a `.Rmd` post in `content/post` (see above) to introduce the lecture
    and link to the slides; for an example, look at
    [`content/post/lecture-reproducibility.Rmd`](https://github.com/reconhub/learn/blob/master/content/post/lecture-basicvbd-modelling.Rmd).

2.  the slides themselves, stored in `static/slides`.

For the slides, we recommended using `.Rmd` there again, and rendering
them before committing them. If your slides use images, store them in
`static/img/slides`. You will be able to refer to them using
`../../img/slides/your-image.jpg`. For an example of
`rmarkdown+ioslides` slides, look at
[`static/slides/intro_reproducibility_Rmd/intro_reproducibility.Rmd`](https://github.com/reconhub/learn/blob/master/static/slides/reproducibility/reproducibility.Rmd).

## Visualising the changes

Once a pull request (PR) has been made against
<https://github.com/reconhub/learn/>, a new version of the website
matching the PR will be deployed online at a new URL with the form
`https://deploy-preview-xyz--reconlearn-test.netlify.com/` where `xyz`
is the number of the pull request. For instance, PR 26 will be deployed
at: <https://deploy-preview-26--reconlearn-test.netlify.com/> .

# About this document

## Contributors

  - Locke Data: initial version

  - Thibaut Jombart: precisions on cloning and PR deploys

  - Zhian N. Kamvar: Clarificaton of rendering and forking

Contributions are welcome via [pull
requests](https://github.com/reconhub/learn/pulls).

## Legal stuff

**License**: [CC-BY](https://creativecommons.org/licenses/by/3.0/)
**Copyright**: Locke Data, 2018
