library(relatorios); library(reest)
library(data.table)

exec_supl <- ler_exec_desp("data-raw/exec_suplementacao.XLS")
exec_desp <- ler_exec_desp("data-raw/exec_desp.XLS")
exec_cota <- ler_exec_desp("data-raw/exec_cota.XLS")
reest_desp <- ler_reest_desp("data-raw/reest_desp.xlsx")


base <- join(SUPL = exec_supl, DESP = exec_desp, REEST = reest_desp, COTA = exec_cota)

base[, ASPS := is_asps_desp(base, "ACAO_COD")]
base[, MDE := is_mde_desp(base)]
base <- add_criterio_seplag(base, "ACAO_COD")

writexl::write_xlsx(base, "reports/saldo_credito.xlsx")
