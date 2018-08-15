Welcome to the *RECON learn* project
====================================

This GitHub project hosts the sources of the [RECON](http://www.repidemicsconsortium.org/) learn platform, live at: <https://reconlearn.netlify.com/>.

This *RECON learn* website uses [R Markdown](http://rmarkdown.rstudio.com/) (`.Rmd`) documents to build markdown (`.md`) content that [Hugo](https://gohugo.io) then turns into a nifty website (`.html`).

General workflow for contributing
---------------------------------

The general workflow would include the following steps:

1.  **Fork the project** from the GitHub *RECON learn* project:

This will create a copy of the project in your own GitHub account. You will need to clone this archive, and make the modifications there. You `git clone` would look like:

``` bash
git clone https://github.com/johnsnow/learn
```

If your GitHub user name is `johnsnow`.

1.  Open the project in Rstudio and run `devtools::install()`

2.  **Add new content**, typically in the form of a new `.Rmd` file and associated media (most often images). See more details [in the following section](#creation)

    Regular posts such as practicals, tutorials, and case studies are stored in `content/post/`. They can be created via the use of `learnr::create_post`, e.g.
    
    ```r
    create_post(title = "An overview of incidence plotting",
              slug = "incidence-plotting",
              author = "Steph Locke",
              category = "practicals")
    ```

    Other content which is not rendered as typical html reports such as lecture slides can be stored in `static`.

3.  **Generate content** by running `learn::render_new_rmds_to_md()` to build the `.md` files and associated graphics.

4.  `git commit` and `git push` all changes; don't forget to add new images as well (run `git status` to see which files haven't been added).

5.  Make a **pull request** against the main project (`master` branch), from the GitHub *RECON learn* project. Make sure you use `reconhub/learn`, branch `master` as base fork.

Creating posts <a name="creation"></a>
--------------

Practicals, tutorials, case studies are contributed as [R Markdown](http://rmarkdown.rstudio.com/) (`.Rmd`) documents and generated markdown ready for conversion as `.md` documents. They are stored in `content/post`. The best way to create a new document is to use the `create_post` function.

 ```r
create_post(title = "An overview of incidence plotting",
            slug = "incidence-plotting",
            author = "Steph Locke",
            category = "practicals")
```

See `?create_post` to see further parameters.

### Conventions

File-naming conventions are as follows:

-   start with `practical` for practicals, `study` for case studies (handled by `create_post`)
-   use an informative slug.
    -   use lower case, no special characters
    -   be hypen-separated ("-")

For instance, for a practical using a SEIR model for influenza data:

-   `seir-influenza` is a good slug 
-   `SEIR-flu` is bad because it has capitalised letters
-   `new` is bad, as it is non-informative

### Editing the YAML header

The YAML header is the beginning of the `Rmd` document, within the `---`. For instance:

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
preserve_yaml: true
---
```

Fields are mostly self-explanatory, and can be adapted to your needs. The date should respect the format provided.

### Referencing packages

You can load packages or use functions via the typical methods `library(tidyverse)`, `require(magrittr)`, `dplyr::mutate()` and folks can run `learn::get_and_update_dependencies()` file to get all packages mentioned in the `content/posts` directory.

This means you do not need to have mandatory install statements - you can make these `eval=FALSE`.

NB. The `automagic` package used to get dependencies currently does not like `library("tidyverse")` so remove those speechmarks when writing your post!

### Storing images

The **image** will be the image associated with the document on the website. We try using natural, high-resolution, evocative images having a link, if only figurative, with the topic covered. These images are stored in `static/img/highres/`. Do not forget to add and push this file as well, as it will be required for your post to be successfully integrated. The path to the file provided in the header assumes `static/` as root folder (see example above), so that the right path will look like: `img/highres/your-image.jpg`.

### Bibliographies

The **`bibliography`** is optional. If provided, it should contain references cited in the document as a `bibtex` file (`.bib`). Do not forget to add and push this file as well, as it will be required for your post to be successfully integrated.

### Be nice

As many files could be generated in one go, please don't use any `rm(list=ls())` types of activities. Make your code play nicely with others -- use specific and useful names, don't mess around with the global environment, and don't force any package unloads.

Contributing slides
-------------------

Material for slides is stored in `static/slides`. Currently, two files are needed for a lecture:

1.  a `.Rmd` post in `content/post` (see above) to introduce the lecture and link to the slides; for an example, look at `content/post/lecture-reproducibility.Rmd`.

2.  the slides themselves, stored in `static/slides`.

For the slides, we recommended using `.Rmd` there again, and rendering them before committing them. If your slides use images, store them in `static/img/slides`. You will be able to refer to them using `../../img/slides/your-image.jpg`. For an example of `rmarkdown+ioslides` slides, look at `static/slides/intro_reproducibility_Rmd/intro_reproducibility.Rmd`.

Other topics
------------

### Contributing top-level pages

To contribute a page that sits outside of the posts category you can make an `.md` file (or a `.Rmd` file so long as you render to `.md` too). This will then be processed by Hugo along with the other files to build the website.

These files should have at minimum:

``` r
---
date : 2017-11-01
title : About RECON learn
---
```

### Maintaining package dependencies

This repository has a DESCRIPTION which lists any packages required to manage this package itself, not the packages required to knit the R Markdown files.

To identify and install all the packages needed to build all of the `.Rmd` files in `content/post/`, you need to run `learn::get_and_update_dependencies()`. This will also help find packages on GitHub.

### Editing existing content

If you need to change an existing piece of content:

1.  Make the changes to the `.Rmd` file
2.  Run `learn::render_new_rmds_to_md()`
3.  Commit and push to the repository
