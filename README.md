Welcome to the *RECON learn* project
====================================

This GitHub project hosts the sources of the [RECON](http://www.repidemicsconsortium.org/) learn platform, live at: <https://reconlearn.org/>.


## Running a local copy of the website

To run a local copy of this website, you will need a working version of [Hugo](https://gohugo.io/) installed; `git clone` this repos, then its submodules (used to pull the Hugo theme), and then run hugo on the website:

```
git clone https://github.com/reconhub/learn recon-learn
cd recon-learn
git submodule init
git submodule update
hugo serve -D
```


## How to contribute content?

This *RECON learn* website uses [R Markdown](http://rmarkdown.rstudio.com/) (`.Rmd`) documents to build markdown (`.md`) content that [Hugo](https://gohugo.io) then turns into a nifty website (`.html`).

For practical details, head out to [this step-by-step tutorial about creating posts](https://reconlearn.netlify.com/post/post-creation.html).

## Other topics

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
