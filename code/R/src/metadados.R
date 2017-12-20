# As seguintes variaveis do Armazem sao usadas na aba metadados
# BASE = "Base XYZ"
# DATA_ATUALIZACAO =DataÚltimaExecução()
# ANO_REF = FiltroDeRelatório([Ano de Exercício]) 
# MES_REF = Máx([Mês - Numérico]) 

files <- list.files("data-raw/", full.names = TRUE)
files <- files[grepl("exec_", files)]

if(length(stem) > 0) {
  metadados <- Map(readxl::read_excel, files, "metadados")
  metadados <- Reduce(rbind, metadados)
  metadados <- metadados[!is.na(metadados$BASE),]
} else {
  metadados <- data.frame(BASE = "Não existem bases da execução orçamentária")
}

writexl::write_xlsx(metadados, "reports/metadados.xlsx")
