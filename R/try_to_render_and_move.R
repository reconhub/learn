try_to_render_and_move <- function(rmd, variant, figfile, params, solution = FALSE) {

  cpath <- sub("\\.Rmd$", "_files", rmd)
  spath <- sub("content", "static", cpath)

  # If there are solutions available, then run them and place them in the
  # "solutions" directory. 
  if (solution && any(names(params) == "full_version")) {
    output <- sub("post/", "solutions/", rmd) 
    output <- sub('\\.Rmd$', '.md', output)
    if (!fs::dir_exists(dirname(output))) {
      fs::dir_create(dirname(output))
    }
    params$full_version <- TRUE
  } else {
    output <- NULL
  }

  res <- try(rmarkdown::render(rmd,
                               rmarkdown::md_document(variant = variant,
                                                      preserve_yaml = TRUE),
                               output_file = output,
                               envir = new.env(),
                               params = params))

  if (inherits(res, "try-error")) {
    return(FALSE)
  }
  # If there are any figures, they should be moved into the correct folder
  #
  # Figures from the knitr run
  source_figs <- fs::path(cpath, figfile)
  # Where the figures should be
  site_figs   <- fs::path(spath, figfile)

  if (fs::dir_exists(source_figs)) {
    # create the output directory if it doesn't exist
    if (!fs::dir_exists(site_figs)) {
      fs::dir_create(site_figs)
    } else {
      fs::file_delete(fs::dir_ls(site_figs))
    }
    # Move the files
    fs::file_move(fs::dir_ls(source_figs), fs::path(site_figs))
    return(TRUE)
  } else {
    return(FALSE)
  }

}
