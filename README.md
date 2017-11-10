
Welcome to the *RECON learn* project
====================================

This github project hosts the sources of the
[RECON](http://www.repidemicsconsortium.org/) learn platform, live at:
[https://reconlearn.netlify.com/](https://reconlearn.netlify.com/).


This *RECON learn* website uses
[blogdown](https://bookdown.org/yihui/blogdown/), which generates static content
for a website through the compilation of a series of
[Rmarkdown](http://rmarkdown.rstudio.com/) (`.Rmd`) documents.


## Running the website locally

You will need to install `blogdown` and its dependencies (especially Hugo):

```r
install.packages("blogdown") # install blogdown
blogdown::install_hugo() # install hugo
```

See detailed [installation
guidelines](https://bookdown.org/yihui/blogdown/installation.html) for more
information.

<br>

You will also need to `git clone` this project, which using `git` command
lines would look like:


```bash
git clone https://github.com/reconhub/learn
cd learn
```

Once this is done, start R and type:

```r
blogdown::serve_site()
```

This will open up the website at `127.0.0.1:4321`. This website is updated in
real time based on the content of `learn/`.




## Contributing to *RECON learn*

### General workflow

The general workflow would include the following steps:

1. **Fork the project** from the github *RECON learn* project:

<center>
<img src="data/img/shot-fork.png" width="800px">
</center>

This will create a copy of the project in your own github account. You will need
to clone this archive, and make the modifications there. You `git clone` would look like:


```bash
git clone https://github.com/johnsnow/learn
```

If your github user name is `johnsnow`.  


2. **Add new content**, typically in the form of a new `.Rmd` file and
associated media (most often images). Regular posts are stored in
`content/post/`. Other content which is not rendered as typical html reports
such as lectures can be stored in `static`.

3. **Test new content** and revise until satisfying by visualising the local website
using `blogdown::serve_site()`, where the current working directory is set to
the project folder (`learn/` by default).

4. `git commit` and `git push` all changes; don't forget to add new images as
well (run `git status` to see which files haven't been added).

5. Make a **pull request** against the main project (`master` branch), from the github *RECON learn* project:

<center>
<img src="data/img/shot-pr.png" width="800px">
</center>




### Contributing practicals and case studies




