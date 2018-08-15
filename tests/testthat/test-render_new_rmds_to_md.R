context("render_new_rmds_to_md")

test_that("render_new_rmds_to_md works", {
  dir.create("content")
  dir.create(file.path("content", "post"))
  create_post()
  render_new_rmds_to_md()
  
  rmd_path <- file.path("content", 
                    "post",
                    "tutorial-a-study-of-zika-and-cholera.Rmd")
  md_path <- file.path("content", 
                        "post",
                        "tutorial-a-study-of-zika-and-cholera.md")
  
  
  expect_true(file.exists(rmd_path))
  expect_true(file.exists(md_path))
  
  file.remove(rmd_path)
  file.remove(md_path)
  unlink("content", recursive = TRUE)
  
})
