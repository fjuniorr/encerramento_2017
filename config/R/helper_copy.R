guess_base <- function(x) {
  tokens <- strsplit(x, "_")
  tokens[[1]][2]
}

copy_scppo <- function(file, dir) {
  env <- Sys.getenv("PATH_SCPPO")
  if(env == "") {
    stop("A variavel PATH_SCPPO nao esta definida.")
  }
  path <- file.path(env, dir, file)
  copy_file(path)
}

copy_local <- function(file, dir) {
  path <- file.path(dir, file)
  copy_file(path)
}

copy_file <- function(path) {
  if(!file.exists(path)) {
    stop(paste("Arquivo", path, "nao encontrado."))
  }
  cat(paste0("Copiando ", path, "...\n"))
  invisible(file.copy(path, "data-raw/", overwrite = TRUE))
}

make_path <- function(x) {
  tokens <- strsplit(x, "_")
  base <- tokens[[1]][2]
  stem <- paste0(tokens[[1]][-c(1, 2)], collapse = "_")
  paste0(base, "_", stem, ".xlsx")
}

clean_excel <- function(from, to) {
  vbscript <- paste("cscript //nologo code/vbs/clean_excel.vbs", from, to)
  
  shell(vbscript, mustWork = TRUE)
  
  if(from != to) {
    invisible(file.remove(file.path("data-raw/", from)))
  }
}
