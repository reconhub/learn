content="content/post"
# Rmds not rendered
rmds<-list.files(content, pattern="\\.Rmd")
mds<-list.files(content, pattern="\\.md")

to_build<-setdiff(
                  tools::file_path_sans_ext(rmds),
                  tools::file_path_sans_ext(mds)
                )

for(b in to_build) {
  rmd = file.path(content, paste0(b, ".Rmd"))
  rmarkdown::render(
    rmd,
    rmarkdown::md_document(variant = "markdown_github",
                           preserve_yaml = TRUE))
}
