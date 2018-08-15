context("test-create_post")

test_that("create_post works", {
  dir.create("content")
  dir.create(file.path("content", "post"))
  
  create_post()
  
  path <- file.path("content", 
                    "post",
                    "tutorial-a-study-of-zika-and-cholera.Rmd")
  
  expect_true(file.exists(path))
  yaml <- rmarkdown::yaml_front_matter(path)
  expect_equal(yaml$author, "Celina Turchi, John Snow")
  
  file.remove(path)
  
  create_post(title = "Less cool",
              slug = "cool-cool",
              author = "Steph Locke",
              category = "practicals")
  
  path <- file.path("content", 
                    "post",
                    "practical-cool-cool.Rmd")
  
  expect_true(file.exists(path))
  yaml <- rmarkdown::yaml_front_matter(path)
  expect_equal(yaml$author, "Steph Locke")
  expect_equal(yaml$categories, "practicals")
  file.remove(path)
  
  unlink("content", recursive = TRUE)
})
