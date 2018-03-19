library(tidyverse)

"content/post/" %>% 
  list.files("*.Rmd", full.names = TRUE) %>% 
  map_chr(read_file) %>% 
  str_extract_all("library(.*)") %>% 
  simplify() %>% 
  unique() %>% 
  str_replace_all("^library\\(|\\)","") ->
  package_deps

package_deps %>% 
  setdiff(installed.packages()[,"Package"]) %>% 
  install.packages()

package_deps %>% 
  map(devtools::use_package)

