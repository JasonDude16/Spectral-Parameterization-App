install.packages("reticulate")
library(reticulate)

# install miniconda, which includes python 
install_miniconda()

# get the reticulate install 
(cl <- conda_list())
retic <- cl[cl$name == "r-reticulate", ]$python

# add reticulate install to R Profile
ll <- readLines(".Rprofile")
writeLines(text = paste0(ll, "\n", paste0("Sys.setenv(RETICULATE_PYTHON = '", retic, "')")), con = "./.Rprofile")
