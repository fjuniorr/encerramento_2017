config <- yaml::yaml.load_file("config/config.yaml")

stem <- names(config$munge_base)[as.logical(config$munge_base)]

args <- commandArgs(trailingOnly = TRUE)

regex <- paste0("^", args, "_")

stem <- stem[grepl(regex, stem)]

if(is.character(stem) & length(stem) == 0) {
  targets <- ""
} else {
  targets <- paste0("copy_", stem)
}

write(targets, file = stdout())
