#' Determine all dependencies in blog posts and install them
#' 
#' Using the automagic package, detect requirements in Rmd files
#' and install them all. Will help you if packages appear to be on GitHub.
#'
#' @param dir Directory to search for packages in. Defaults to the blog post location of Hugo.
#'
#' @return Used for pure side effect
#' @export
get_and_update_dependencies <- function(dir = "content/post/") {
  pkgs <- checkpoint::scanForPackages("content/post", use.knitr = TRUE)$pkgs
  install.packages(pkgs)
}
