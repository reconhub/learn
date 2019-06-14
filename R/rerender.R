#' Re-build an MD file for hugo
#' 
#' @param rmd the name of an md file you want to rebuild. 
#' @param dir Directory to search for new Rmds in. Defaults to the blog post location of Hugo.
#' @inheritParams render_new_rmds_to_md
#'
#' @return Used for pure side effect
#' @export
rerender <- function(rmd = NULL, dir = "content/post", params = list(full_version = FALSE), solution = FALSE) { 
  root     <- rprojroot::has_file("DESCRIPTION")
  the_dir  <- root$find_file(dir)
  pv <- rmarkdown::pandoc_version() >= package_version("2.0.0")
  variant <- if (pv) "gfm" else "markdown_github"
  figfile <- if (pv) "figure-gfm" else "figure-markdown_github"
  the_files <- fs::dir_ls(the_dir, glob = paste0("*", rmd))
  for (the_file in the_files) {
    if (length(the_file) == 0) {
      stop("please supply a file.")
    } 
    if (!grepl("[R.]md$", the_file)) {
      stop("must be an Rmd or an md file.")
    }
    if (grepl("Rmd$", the_file)) {
      md  <- gsub("\\.Rmd", "\\.md", the_file) 
      rmd <- the_file
    } else {
      md  <- the_file
      rmd <- gsub("\\.md", "\\.Rmd", the_file) 
    }
    try_to_render_and_move(rmd, variant, figfile, params, solution)
  }
}
