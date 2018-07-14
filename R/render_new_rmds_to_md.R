#' Prep Hugo pages by converting Rmds to Md's
#' 
#' Assumes anything without a corresponding markdown file
#' needs to be renderd to md. Hugo (the static site generator)
#' then converts these md files to html on the site. Use the
#' preview option in Rstudio to quickly see how your md has worked.
#'
#' @param dir Directory to search for new Rmds in. Defaults to the blog post location of Hugo.
#'
#' @return Used for pure side effect
#' @export
render_new_rmds_to_md <- function(dir = "content/post") {
  content = dir
  # Rmds not rendered
  rmds <- list.files(content, pattern = "\\.Rmd")
  mds <- list.files(content, pattern = "\\.md")
  
  to_build <- setdiff(tools::file_path_sans_ext(rmds),
                      tools::file_path_sans_ext(mds))
  
  for (b in to_build) {
    rmd = file.path(content, paste0(b, ".Rmd"))
    rmarkdown::render(rmd,
                      rmarkdown::md_document(variant = "markdown_github",
                                             preserve_yaml = TRUE))
  }
}