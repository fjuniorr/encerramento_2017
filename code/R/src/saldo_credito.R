library(relatorios); library(reest)
library(data.table)

source("code/R/lib/helper.R")

exec_supl <- ler_exec_desp("data-raw/exec_suplementacao.XLS")
exec_desp <- ler_exec_desp("data-raw/exec_desp.XLS")
exec_cota <- ler_exec_desp("data-raw/exec_cota.XLS")
reest_desp <- ler_reest_desp("data-raw/reest_desp.xlsx")

lookup_funcao_cod <- unique(exec_supl[, .(ANO, UO_COD, ACAO_COD, FUNCAO_COD)])

exec_cota[lookup_funcao_cod, FUNCAO_COD := i.FUNCAO_COD, on = c("ANO", "UO_COD", "ACAO_COD")] # foo <- lookup_funcao_cod[exec_cota, on = c("ANO", "UO_COD", "ACAO_COD")]
exec_cota[is.na(FUNCAO_COD), FUNCAO_COD := 0]


base <- reest::join(reest_desp, exec_supl, exec_cota, exec_desp, 
                    value.var = c("VL_REEST_DESP", "VL_CRED_AUT", "VL_COTA_APROVADA", "VL_EMP"),
                    regex = FALSE,
                    bind = "columns", 
                    idcol = FALSE)


base[, MDE := is_mde_desp(base)]
base <- add_saude(base)
base <- add_tipo(base)
base <- adiciona_desc(base, "ACAO_COD")


writexl::write_xlsx(base, "reports/saldo_credito.xlsx")
