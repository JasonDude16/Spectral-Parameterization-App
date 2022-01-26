install.packages("reticulate")
library(reticulate)

# install miniconda/python 
install_miniconda()

# get the reticulate install 
(cl <- conda_list())
retic <- cl[cl$name == "r-reticulate", ]$python

if (.Platform$OS.type == "windows") {
    retic <- gsub('"', "", gsub("\\\\", "/", retic)) 
}

# add reticulate python version to R Profile (only for local project)
ll <- readLines(".Rprofile")

if (length(ll) == 1 && !exists("done")) {
    writeLines(text = paste0(ll, "\n", paste0("Sys.setenv(RETICULATE_PYTHON = '", retic, "')")), con = "./.Rprofile")
    done <- TRUE
}

# restarting R so .Rprofile can update
.rs.restartR()

# select yes when prompted
renv::status()
renv::hydrate()
renv::status()
renv::snapshot()

# very hacky way to do this but should work since versions aren't critical
py_install(read.table("requirements.txt", header = F, sep = "=")[[1]])

