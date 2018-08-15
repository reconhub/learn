#' Create a post from the template
#' 
#' @details create a R Markdown file and open it.
#'
#' @param title Title for the post
#' @param slug Short informative slug with words separated by "-"
#' @param category Either "tutorials", "practicals" or "case studies"
#' @param author Author as a vector
#' @param date Date for the post
#' @param licence_name Name of the license
#' @param licence_url URL to the license
#'
#' @return Used only for side-effects.
#' @export
#'
create_post <- function(title = "A study of Zika and Cholera",
                        slug = NULL,
                        category = c("tutorials", "practicals", "case studies"),
                        author = c("Celina Turchi", "John Snow"),
                        date = Sys.Date(),
                        licence_name = "CC-BY",
                        licence_url = "https://creativecommons.org/licenses/by/3.0/"){
  if(is.null(slug)){
    slug <- snakecase::to_any_case(title, case = "snake", 
                                   sep_out = "-", sep_in = "-")
  }
  
  singular_category <- switch(category[[1]],
                              "practicals" = "practical",
                              "tutorials" = "tutorial",
                              "case studies" = "study")
  
  post_path <- file.path("content", "post", 
                         glue::glue("{singular_category}-{slug}.Rmd"))
  
  file.copy(system.file("rmarkdown", "templates",
                        "skeleton",
                        "skeleton.Rmd", package = "learn"),
            post_path,
            overwrite = TRUE)
  
  file.copy(system.file("rmarkdown", "templates",
                        "resources",
                        "practical-phylogenetics.bib", package = "learn"),
            file.path("content", "post", paste0(slug, ".bib")),
            overwrite = TRUE)
  
  file.copy(system.file("rmarkdown", "templates",
                        "resources",
                        "placeholder.jpg", package = "learn"),
            file.path("static","img", "highres", paste0(slug, ".jpg")),
            overwrite = TRUE)
  
  yaml <- rmarkdown::yaml_front_matter(post_path, encoding = "UTF-8")
  
  yaml$title <- title
  yaml$author <- toString(author)
  yaml$authors <- jsonlite::toJSON(author)
  yaml$topics <- jsonlite::toJSON(yaml$topics)
  yaml$categories <- jsonlite::toJSON(category)
  yaml$date <- as.character(date)
  yaml$bibliography <- paste0(slug, ".bib")
  yaml$image <- glue::glue("img/highres/{slug}.jpg")
  yaml$licenses <- licence_name
  
  file_content <- readLines(post_path)
  i = grep('^---\\s*$', file_content)
  file_content <- file_content[(i[2]+1):length(file_content)]
  
  newyaml <- yaml::as.yaml(yaml)
  newyaml <- stringr::str_remove_all(newyaml, "'")
  
  file_content[grepl("\\- Zulma Cucunuba \\& Pierre Nouvellet\\: initial version", 
                     file_content)] <-
    glue::glue("- {toString(author)}: initial version")
  
  file_content[grepl("\\[CC-BY\\]\\(htt", file_content)] <-
    glue::glue("**License**: [{licence_name}]({licence_url})")
  
  file_content[grepl("Zulma Cucunuba \\& Pierre Nouvellet, 2017", 
                     file_content)] <-
    glue::glue("**Copyright**: {toString(author)}, {format(date, '%Y')}")
  
  
  file_content <- c(c("---"),
                    newyaml,
                    c("---"),
                    file_content)
  print(post_path)
  writeLines(file_content, post_path,
             useBytes = TRUE)
  usethis::edit_file(post_path)
  
}