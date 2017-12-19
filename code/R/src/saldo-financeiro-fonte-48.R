library(reest); library(execucao)
library(data.table); library(magrittr)

exec <- reest::join(execucao::exec_rec, execucao::exec_desp, execucao::exec_rp)


# apuracao superavit financeiro
exec[FONTE_COD == 48,
     .(VL_EFET_AJUST = sum(VL_EFET_AJUST), VL_EMP = sum(VL_EMP), VL_CANCELADO_RP = sum(VL_CANCELADO_RPP_DEMAIS + VL_CANCELADO_RPNP)),
     by = .(ANO)] %>% clipboard::cb()

# suplementacao superavit financeiro
exec_supl <- reest::ler_exec_desp("data-raw/exec_suplementacao.XLS")
exec_supl <- add_origem_cred_desc(exec_supl)
exec_supl[FONTE_COD == 48, .(VL_SUPLEMENTACAO = sum(VL_SUPLEMENTACAO)), by = ORIGEM_CRED] %>% clipboard::cb()


