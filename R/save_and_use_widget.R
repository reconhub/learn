#' Store a widget and generate iframe code
#' 
#' Use this to embed a htmlwidget in your Rmd's for when they
#' get rendered to markdown. You also need to add 
#' `always_allow_html: yes` to the Rmd for the html to remain
#' incorporated. Widget will be saved in the widget directory.
#'
#' @param x htmlwidget to be shown
#' @param filename Unique filename for the widget to be saved under
#'
#' @return HTML code for iframe of htmlwidget
#' @export
save_and_use_widget <- function(x, filename) {
  root     <- rprojroot::has_file("DESCRIPTION")
  the_dir  <- root$find_file("static", "post", "widgets")
  the_file <- root$find_file("static", "post", "widgets", filename)
  dir.create(the_dir, showWarnings = FALSE)
  htmlwidgets::saveWidget(x, the_file, selfcontained = TRUE)
  htmltools::tags$iframe(src = file.path("widgets", filename),
                         width = "100%",
                         height = "500px")
}
