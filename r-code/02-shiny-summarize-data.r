
# Nicholas Ducharme-Barth
# 2025/01/06
# summarize model runs for Shiny app

# Copyright (c) 2025 Nicholas Ducharme-Barth

#_____________________________________________________________________________________________________________________________
# load packages
library(data.table)
library(magrittr)
library(r4ss)

#_____________________________________________________________________________________________________________________________
# define paths
	proj_dir = this.path::this.proj()
	dir_model = paste0(proj_dir,"/stock-synthesis-models/")

#_____________________________________________________________________________________________________________________________
# get a vector of directories for models that have produced stock synthesis output
    all_dirs = list.files(dir_model,recursive = TRUE)
    # only keep model directories that contain a Report.sso file
    all_dirs = all_dirs[grep("/Report.sso",all_dirs,fixed=TRUE)]
    all_dirs = gsub("Report.sso","",all_dirs,fixed=TRUE)

#_____________________________________________________________________________________________________________________________
# extract output from models
  output = SSgetoutput(dirvec=paste0(dir_model,all_dirs))
  names(output) = gsub("/","",all_dirs)

  # since we ran models with different steepness values lets get the steepness value that corresponds to each model
  model_steepness = sapply(output,function(x)x[["parameters"]]["SR_BH_steep","Value"])

  # we want to build a shiny app that shows the stock recruit curve for each model so we will need to extract the corresponding data
  # expected stock recruit relationship (srr)
  expected_srr_dt.list = as.list(rep(NA,length(all_dirs)))
  for(i in seq_along(expected_srr_dt.list)){
    expected_srr_dt.list[[i]] = as.data.table(output[[i]]$SPAWN_RECR_CURVE) %>%
                       .[,model_name:=names(output[i])] %>%
                       .[,.(model_name,SSB,Recruitment)] %>%
                       setnames(.,c("SSB","Recruitment"),c("ssb","rec_actual"))
  }
  expected_srr_dt = rbindlist(expected_srr_dt.list)
  fwrite(expected_srr_dt,file=paste0(proj_dir,"shiny/shiny-data/expected_srr.csv"))

  # annual estimated recruitments and corresponding spawning biomass
  est_recruit_dt.list = as.list(rep(NA,length(all_dirs)))
  for(i in seq_along(est_recruit_dt.list)){
    est_recruit_dt.list[[i]] = as.data.table(output[[i]]$recruit) %>%
                       .[,model_name:=names(output[i])] %>%
                       .[era=="Main"] %>%
                       .[,.(model_name,Yr,SpawnBio,pred_recr)] %>%
                       setnames(.,c("Yr","SpawnBio","pred_recr"),c("yr","ssb","rec_estimated"))
  }
  est_recruit_dt = rbindlist(est_recruit_dt.list)
  fwrite(est_recruit_dt,file=paste0(proj_dir,"shiny/shiny-data/est_recruit.csv"))
  
#_____________________________________________________________________________________________________________________________
# make summary files to run the shiny app from
  summary_dt = data.table(model_name=names(output),steepness=model_steepness)
  fwrite(summary_dt,file=paste0(proj_dir,"shiny/shiny-data/summary.csv"))
