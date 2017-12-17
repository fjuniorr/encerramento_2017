library(relatorios)
library(data.table)

exec_supl <- ler_exec_desp("data-raw/exec_suplementacao.XLS")
exec_desp <- ler_exec_desp("data-raw/exec_desp.XLS")

base <- join(exec_supl, exec_desp)

base[, ASPS := is_asps_desp(base, "ACAO_COD")]
base[, MDE := is_mde_desp(base)]
base <- add_criterio_seplag(base, "ACAO_COD")

writexl::write_xlsx(base, "reports/saldo_credito.xlsx")
