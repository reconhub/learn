try_to_render_and_move <- function(rmd, variant, figfile, params, solution = FALSE) {

  cpath <- sub("\\.Rmd$", "_files", rmd)
  spath <- sub("content", "static", cpath)
  existing_output <- sub("\\.Rmd$", ".md", rmd)
  output_exists <- fs::file_exists(existing_output)
  tmpfile <- tempfile(fileext = ".md")


  # The basic idea is that we follow these steps. Steps marked with (s) are
  # those that are specific to building solution documents.
  #
  # 0(s). Move the rendered file to a temporary file until it all blows over. 
  #
  # 1. Render the markdown document with given params, but return FALSE if it
  #    gives an error.
  #
  # 2(s). If the solution document is built, read in the built md document and
  #       link the images and widgets from the post directory with gsub.
  #
  # 3(s). Write the solution document to the content/solutions directory
  #
  # 4(s). Restore the original rendered document (if it exists)
  # 
  # 5. Move the rendered figures to the static/post directory


  # If there are solutions available, then run them and place them in the
  # "solutions" directory. 
  if (solution && any(names(params) == "full_version")) {
    # Check if a non-solution file already exists
    if (output_exists) {
      fs::file_move(existing_output, tmpfile)
      # always try to restore the file on exit
      on.exit(try(fs::file_move(tmpfile, existing_output), silent = TRUE))
    }
    # Create the directory if it doesn't exist
    output <- sub("post/", "solutions/", rmd) 
    output <- sub("\\.Rmd", "\\.md", output)
    if (!fs::dir_exists(dirname(output))) {
      fs::dir_create(dirname(output))
    }
    # Change full_version to TRUE, no matter what
    params$full_version <- TRUE
  } 

  res <- try(rmarkdown::render(rmd,
                               rmarkdown::md_document(variant = variant,
                                                      preserve_yaml = TRUE),
                               envir = new.env(),
                               params = params))

  if (inherits(res, "try-error")) {
    return(FALSE)
  }
  if (solution) {
    # First thing is to rewrite the output to use the figures and widgets from
    # the post directory
    res_text <- xfun::read_utf8(res)
    # fix figure paths
    res_text <- gsub(basename(cpath), sprintf("../post/%s", basename(cpath)), res_text)
    # fix widget paths
    res_text <- gsub("widgets/", sprintf("../post/%s", "widgets/"), res_text) 
    # write the output to the output file
    xfun::write_utf8(res_text, output)

    # If there was a non-solution file already, then restore it to its original
    # glory.
    if (output_exists) {
      fs::file_move(tmpfile, res)
    }
  }
  # If there are any figures, they should be moved into the correct folder
  #
  # Figures from the knitr run
  source_figs <- fs::path(cpath, figfile)
  # Where the figures should be
  site_figs   <- fs::path(spath, figfile)

  if (fs::dir_exists(source_figs)) {
    if (!fs::dir_exists(site_figs)) {
      # create the output directory if it doesn't exist
      fs::dir_create(site_figs)
    } 
    # Move the files
    fs::file_move(fs::dir_ls(source_figs), fs::path(site_figs))
    return(TRUE)
  } else {
    return(FALSE)
  }

}
