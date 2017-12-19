# As seguintes variaveis do Armazem sao usadas na aba metadados
# BASE = "Base XYZ"
# DATA_ATUALIZACAO =DataÚltimaExecução()
# ANO_REF = FiltroDeRelatório([Ano de Exercício]) 
# MES_REF = Máx([Mês - Numérico]) 

config <- yaml::yaml.load_file("config/config.yaml")
stem <- names(config$munge_base)[as.logical(config$munge_base)]
stem <- stem[grepl("^exec_", stem)]

if(length(stem) > 0) {
  files <- paste0("data-raw/", stem, ".xlsx")
  metadados <- Map(readxl::read_excel, files, "metadados")
  metadados <- Reduce(rbind, metadados)
  metadados <- metadados[!is.na(metadados$BASE),]
} else {
  metadados <- data.frame(BASE = "Não existem bases da execução orçamentária")
}

writexl::write_xlsx(metadados, file = "data/metadados.xlsx", row.names = FALSE)
