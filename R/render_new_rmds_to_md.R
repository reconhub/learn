#' Prep Hugo pages by converting Rmds to Md's
#' 
#' Assumes anything without a corresponding markdown file
#' needs to be renderd to md. Hugo (the static site generator)
#' then converts these md files to html on the site. Use the
#' preview option in Rstudio to quickly see how your md has worked.
#'
#' @param dir Directory to search for new Rmds in. Defaults to the blog post location of Hugo.
#' @param build Selection criteria for which Rmds to convert to md, options are c("all", "old and new", "old", "new")
#' @param when `build = "old"` or `build = "old and new"`, this number will avoid re-building md files that are fewer than `tol` seconds old. 
#' @param dry_run When `TRUE`, targets are printed, but not rendered. Defaults to `FALSE`.
#'
#' @return Used for pure side effect. If `dry_run = TRUE`, then the list of targets to be rendered will be printed.
#' @export
render_new_rmds_to_md <- function(dir = "content/post", 
                                  build = "new",
                                  tol = 1,
                                  dry_run = FALSE) {
  match.arg(build, c("all", "old and new", "old", "new"))
  root    <- rprojroot::has_file("DESCRIPTION")
  content <- root$find_file(dir)
  
  # get info about all files
  info <- fs::dir_info(content)
  rmds <- info[stringr::str_detect(info$path, "\\.[Rr]md"),]
  mds <- info[stringr::str_detect(info$path, "\\.md"),]
  
  rmds$slug <- fs::path_ext_remove(rmds$path)
  mds$slug <- fs::path_ext_remove(mds$path)
  
  # Rmd without md
  unbuilt <- rmds$path[!rmds$slug %in% mds$slug]
  
  # Rmd with a too old md
  dplyr::left_join(rmds, mds, by = "slug",
                   suffix = c("_rmd", "_md")) %>%
    dplyr::filter((.data$change_time_rmd - .data$change_time_md) > tol) %>%
    dplyr::pull(.data$path_rmd) -> too_old
    
  if(build == "all"){
    to_build <- rmds$path_rmd 
  }
  if(build == "old and new"){
    to_build <- c(too_old, unbuilt)
  }
  if(build == "old"){
    to_build <- too_old
  }
  if(build == "new"){
    to_build <- unbuilt
  }
  pv <- rmarkdown::pandoc_version() >= package_version("2.0.0")
  variant <- if(pv) "gfm" else "markdown_github"
  figfile <- if (pv) "figure-gfm" else "figure-markdown_github"
  # build only the ones to be built
  if(length(to_build) > 0){
    if (dry_run) {
      return(to_build)
    }
    for (b in to_build) {
      rmd <- b
      rmarkdown::render(rmd,
                        rmarkdown::md_document(variant = variant,
                                               preserve_yaml = TRUE ))
      cpath <- gsub("\\.Rmd", "_files", rmd)
      spath <- gsub("content", "static", cpath)
      if (file.exists(file.path(cpath, figfile))) {
        fs::file_move(fs::dir_ls(file.path(cpath, figfile)), 
                      file.path(spath, figfile)
                     )
      }

    }
  }else{
    message("Nothing to build, all .md up-to-date")
  }
  
  
}
