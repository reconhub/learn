#' Re-build an MD file for hugo
#' 
#' @param rmd the name of an md file you want to rebuild. 
#' @param dir Directory to search for new Rmds in. Defaults to the blog post location of Hugo.
#'
#' @return Used for pure side effect
#' @export
rerender <- function(rmd = NULL, dir = "content/post") { 
  root     <- rprojroot::has_file("DESCRIPTION")
  the_file <- root$find_file(dir, rmd)
  if (length(the_file) == 0) {
    stop("please supply a file.")
  } 
  if (!grepl("[R.]md$", the_file)) {
    stop("must be an Rmd or an md file.")
  }
  if (grepl("Rmd$", the_file)) {
    rmd <- the_file
    md  <- gsub("\\.Rmd", "\\.md", the_file) 
  } else {
    md <- the_file
    rmd  <- gsub("\\.md", "\\.Rmd", the_file) 
  }
  pv <- rmarkdown::pandoc_version() >= package_version("2.0.0")
  variant <- if (pv) "gfm" else "markdown_github"
  figfile <- if (pv) "figure-gfm" else "figure-markdown_github"
  rmarkdown::render(rmd,
                    rmarkdown::md_document(variant = variant,
                                           preserve_yaml = TRUE))
  cpath <- gsub("\\.md", "_files", md)
  spath <- gsub("content", "static", cpath)
  fs::file_move(fs::dir_ls(file.path(cpath, figfile)), 
                file.path(spath, figfile)
               )
}
