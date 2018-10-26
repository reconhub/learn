#' Prep Hugo pages by converting Rmds to Md's
#' 
#' Assumes anything without a corresponding markdown file
#' needs to be renderd to md. Hugo (the static site generator)
#' then converts these md files to html on the site. Use the
#' preview option in Rstudio to quickly see how your md has worked.
#'
#' @param dir Directory to search for new Rmds in. Defaults to the blog post location of Hugo.
#' @param build Selection criteria for which Rmds to convert to md, options are c("all", "old and new", "old", "new")
#'
#' @return Used for pure side effect
#' @export
render_new_rmds_to_md <- function(dir = "content/post", 
                                  build = "new") {
  match.arg(build, c("all", "old and new", "old", "new"))
  content = dir
  
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
    dplyr::filter(.data$change_time_md < .data$change_time_rmd) %>%
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
  
  # build only the ones to be built
  if(length(to_build) > 0){

    for (b in to_build) {
      rmd <- b
      rmarkdown::render(rmd,
                        rmarkdown::md_document(variant = "gfm",
                                               preserve_yaml = TRUE ))
    }
  }else{
    message("Nothing to build, all .md up-to-date")
  }
  
  
}
