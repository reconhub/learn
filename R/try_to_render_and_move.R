try_to_render_and_move <- function(rmd) {
  pv <- rmarkdown::pandoc_version() >= package_version("2.0.0")
  variant <- if (pv) "gfm" else "markdown_github"
  figfile <- if (pv) "figure-gfm" else "figure-markdown_github"
  cpath <- gsub("\\.Rmd", "_files", rmd)
  spath <- gsub("content", "static", cpath)
  res <- try(rmarkdown::render(rmd,
                               rmarkdown::md_document(variant = variant,
                                                      preserve_yaml = TRUE),
                               envir = new.env()))
  if (inherits(res, "try-error")) {
    return(NA)
  }
  # If there are any figures, they should be moved into the correct folder
  #
  # Figures from the knitr run
  source_figs <- fs::path(cpath, figfile)
  # Where the figures should be
  site_figs   <- fs::path(cpath, figfile)
  
  if (fs::dir_exists(source_figs)) {
    # create the output directory if it doesn't exist
    if (!fs::dir_exists(site_figs)) {
      fs::dir_create(site_figs)
    }
    # Move the files
    fs::file_move(fs::dir_ls(source_figs), fs::path(site_figs))
  }
  return(rmd)
}