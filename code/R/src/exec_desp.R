library(relatorios); library(reest)
library(data.table)

source("code/R/lib/helper.R")

base <- ler_exec_desp("data-raw/exec_desp.XLS")

base <- base[MES_COD %in% 1:10 & FUNCAO_COD == 10 & FONTE_COD == 10]

base <- add_saude(base)
base <- adiciona_desc(base)


writexl::write_xlsx(base, "reports/exec_desp.xlsx")
