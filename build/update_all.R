# deploy to shinyapps.io

library(devtools)
setwd("~/gh/radiant_dev")
document(roclets = c('rd', 'collate', 'namespace'))
# install()

library(magrittr)
fn <- "~/gh/radiant_dev/inst/base/www/style.css"
readLines(fn) %>%
  gsub("top: 95px;", "top: 145px;", .) %>%
  cat(file = fn, sep = "\n")

Sys.sleep(5)

system("git add --all .")
system("git commit -m 'Update css for shinyapps.io [ci skip]'")
system("git push")

# options(repos = "http://cran.rstudio.com")
# install.packages("rmarkdown"); install.packages("ggvis"); install.packages("testthat")

# devtools::install_github(c("smartinsightsfromdata/rpivotTable","trestletech/shinyAce"))
# devtools::install_github(c("rstudio/shinyapps", "themel/sendmailR", "jimhester/covr"))
devtools::install_github(c("vnijs/radiant","vnijs/DT", "vnijs/MathJaxR"))

library(shinyapps)
fpath <- "~/gh/radiant_dev/inst/base"
setwd(fpath)

for (file in list.files("../../../shinyapps/R", pattern = "\\.(r|R)$", full.names = TRUE))
  source(file, local = TRUE)

source("../../build/deployapp.R", local = TRUE)
deployApp(account = "vnijs", launch.browser = FALSE)

setwd(file.path(fpath,"../quant"))
deployApp(account = "vnijs", launch.browser = FALSE)

setwd(file.path(fpath,"../marketing"))
deployApp(account = "vnijs", launch.browser = FALSE)

fn <- "~/gh/radiant_dev/inst/base/www/style.css"
readLines(fn) %>%
  gsub("top: 145px;", "top: 95px;", .) %>%
  cat(file = fn, sep = "\n")

setwd("~/gh/radiant_dev/")
Sys.sleep(5)

system("git add --all .")
system("git commit -m 'Undo css change for shinyapps.io [ci skip]'")
system("git push")

answ <- readline("Did you create binary packages for Windows? (y/n) ")
if (substr(answ, 1, 1) %in% c("y","Y")) {
  system("sh build/build_mac_win.sh")
}

# in case of problems
# shinyapps::showLogs(entries=1000)

system("osascript ~/gh/update.scpt")

# for major pull problems
# git fetch --all
# git reset --hard origin/master
# rm(list = ls())
