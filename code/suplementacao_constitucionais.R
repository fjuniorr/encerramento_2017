library(relatorios)
library(data.table)

exec_supl <- ler_exec_desp("data-raw/exec_suplementacao.XLS")

exec_supl[, ASPS := is_asps_desp(exec_supl, "ACAO_COD")]
exec_supl[, MDE := is_mde_desp(exec_supl)]

exec_supl <- add_origem_cred_desc(exec_supl)
exec_supl[DECRETO == 0 & CRED_ADIC_COD == 0, ORIGEM_CRED := "LOA"]
exec_supl[DECRETO != 0 & CRED_ADIC_COD == 0, ORIGEM_CRED := "REMANEJAMENTO"]

exec_supl <- adiciona_desc(exec_supl, c("UO_COD", "ACAO_COD"))

writexl::write_xlsx(exec_supl, "reports/suplementacao_constitucionais.xlsx")
