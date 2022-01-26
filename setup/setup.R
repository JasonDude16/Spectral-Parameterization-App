install.packages("reticulate")
library(reticulate)

# install miniconda, which includes python 
install_miniconda()

# get the reticulate install 
(cl <- conda_list())
retic <- cl[cl$name == "r-reticulate", ]$python

if (.Platform$OS.type == "windows") 
    retic <- gsub('"', "", gsub("\\\\", "/", retic)) 

# add reticulate python version to R Profile (only for local project)
ll <- readLines(".Rprofile")

if (!exists("done") || !done) {
    writeLines(text = paste0(ll, "\n", paste0("Sys.setenv(RETICULATE_PYTHON = '", retic, "')")), con = "./.Rprofile")
    done <- TRUE
}
