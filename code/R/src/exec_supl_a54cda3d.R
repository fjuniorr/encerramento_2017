source("code/R/lib/helper.R")

exec_supl_a54cda3d <- ler_exec_desp("data-raw/exec_suplementacao_a54cda3d.xlsx")

exec_supl_a54cda3d <- add_saude(exec_supl_a54cda3d)
exec_supl_a54cda3d <- add_tipo(exec_supl_a54cda3d)
exec_supl_a54cda3d <- adiciona_desc(exec_supl_a54cda3d, "ACAO_COD")


writexl::write_xlsx(exec_supl_a54cda3d, "reports/exec_supl_a54cda3d.xlsx")


