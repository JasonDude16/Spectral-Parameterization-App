source("renv/activate.R")
cl <- reticulate::conda_list()
Sys.setenv(RETICULATE_PYTHON = cl[cl$name == "r-reticulate", ]$python)

