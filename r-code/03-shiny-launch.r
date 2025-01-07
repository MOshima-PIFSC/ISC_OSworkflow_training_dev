
# Nicholas Ducharme-Barth
# 2025/01/06
# launch Shiny app

# Copyright (c) 2025 Nicholas Ducharme-Barth

#_____________________________________________________________________________________________________________________________
# load packages
library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(data.table)
library(markdown)
library(magrittr)
library(ggplot2)
library(viridis)

#_____________________________________________________________________________________________________________________________
# define paths
	proj_dir = this.path::this.proj()

#_____________________________________________________________________________________________________________________________
# load data needed for shiny app
    summary_dt = fread(file=paste0(proj_dir,"/shiny-data/summary.csv"))

#_____________________________________________________________________________________________________________________________
# app options
  start_collapsed = FALSE

#_____________________________________________________________________________________________________________________________
# source ui/server
  source(paste0(proj_dir,"/r-code/shiny/css.r"))
  source(paste0(proj_dir,"/r-code/shiny/ui.r"))
  source(paste0(proj_dir,"/r-code/shiny/server.r"))

#_____________________________________________________________________________________________________________________________
# Run the app
  app = shinyApp(ui=ui,server=server)
  runApp(app, port = 8888)
