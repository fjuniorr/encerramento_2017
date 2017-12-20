library(relatorios); library(reest)
library(data.table); library(magrittr)

exec_desp <- ler_exec_desp("data-raw/exec_desp.XLS") 
exec_supl <- ler_exec_desp("data-raw/exec_suplementacao.XLS")
exec_rec <- ler_exec_rec("data-raw/exec_rec.XLS")
exec_cota <- ler_exec_desp("data-raw/exec_cota.XLS")
reest_rec <- ler_reest_rec("data-raw/reest_rec.xlsx")
reest_desp <- ler_reest_desp("data-raw/reest_desp.xlsx")


repasse_fes <- data.table(stringsAsFactors=FALSE,
                          ANO = c(2017),
                          UO_COD = c(2271, 1451, 1691, 1301, 2311, 2261, 2321, 1541, 2071),
                          UO_SIGLA = c("FHEMIG", "SEAP", "SESP", "SETOP", "UNIMONTES", "FUNED",
                                       "HEMOMINAS", "ESP-MG", "FAPEMIG"),
                          RECEITA_COD = c(7990805100),
                          RECEITA_DESC = c("REPASSE DE RECURSOS DO FUNDO ESTADUAL DE SAUDE - FES - LC 141/2012"),
                          ACAO_COD = c(4245, 4272, 4697, 4637, 4277, 4283, 4301, 4304, 4432),
                          ACAO_DESC = c("DESENVOLVIMENTO DAS ACOES DA FUNDACAO HOSPITALAR DO ESTADO DE MINAS GERAIS",
                                        "DESENVOLVIMENTO DAS ACOES DE SAUDE NO AMBITO DA SECRETARIA DE ADMINISTRACAO PRISIONAL",
                                        "DESENVOLVIMENTO DAS ACOES DE SAUDE NO AMBITO DA SECRETARIA DE ESTADO DE SEGURANCA PUBLICA",
                                        "DESENVOLVIMENTO DAS ACOES DE SAUDE NO AMBITO DA SETOP/DEER",
                                        "DESENVOLVIMENTO DAS ACOES DE SAUDE NO AMBITO DA UNIMONTES",
                                        "DESENVOLVIMENTO DAS ACOES DA FUNDACAO EZEQUIEL DIAS",
                                        "DESENVOLVIMENTO DAS ACOES DA FUNDACAO CENTRO DE HEMATOLOGIA E HEMOTERAPIA DE MINAS GERAIS",
                                        "DESENVOLVIMENTO DAS ACOES DA ESCOLA DE SAUDE PUBLICA DO ESTADO DE MINAS GERAIS",
                                        "DESENVOLVIMENTO DAS ACOES DE SAUDE NO AMBITO DA FUNDACAO DE AMPARO E PESQUISA - FAPEMIG")
)


lookup_funcao_cod <- unique(exec_supl[, .(ANO, UO_COD, ACAO_COD, FUNCAO_COD)])
exec_cota[lookup_funcao_cod, FUNCAO_COD := i.FUNCAO_COD, on = c("ANO", "UO_COD", "ACAO_COD")]
exec_cota[is.na(FUNCAO_COD), FUNCAO_COD := 0]


ASPS <- quote(ANO == 2017 & UO_COD %in% c(1301, 1451, 1541, 1691, 2071, 2261, 2271, 2321, 2311) & FUNCAO_COD == 10 & FONTE_COD == 10) # UO 2311 UNIMONTES ESTA NESSA LISTA e 4291 nao esta
INTRA_SAUDE <- quote(ANO == 2017 & UO_COD == 4291 & ACAO_COD %in% c(4245, 4272, 4283, 4301, 4304, 4637, 4432, 4697, 4277)) # ACAO 4277 UNIMONTES ESTA NESSA LISTA




desp <- exec_desp[eval(ASPS), 
                  .(VL_EMP = sum(VL_EMP)), 
                  by = UO_COD]

supl <- exec_supl[eval(ASPS),
                  .(VL_CRED_AUT = sum(VL_CRED_AUT)),
                  by = UO_COD]

cota <- exec_cota[eval(ASPS),
                  .(VL_COTA_APROVADA = sum(VL_COTA_APROVADA)),
                  by = UO_COD]

reest <- reest_desp[eval(ASPS), 
                  .(VL_REEST_DESP = sum(VL_REEST_DESP)), 
                  by = UO_COD]


rec <- exec_rec[nat(RECEITA_COD, 79908051), 
                .(VL_EFET_AJUST = sum(VL_EFET_AJUST)), 
                by = UO_COD]

rec_reest <- reest_rec[nat(RECEITA_COD, 79908051),
                       .(VL_REEST_REC = sum(VL_REEST_REC)),
                       by = UO_COD]


desp_fes <- exec_desp[eval(INTRA_SAUDE), 
                      .(VL_EMP = sum(VL_EMP)), 
                      by = ACAO_COD]

supl_fes <- exec_supl[eval(INTRA_SAUDE),
                      .(VL_CRED_AUT = sum(VL_CRED_AUT)),
                      by = ACAO_COD]

cota_fes <- exec_cota[eval(INTRA_SAUDE),
                      .(VL_COTA_APROVADA = sum(VL_COTA_APROVADA)),
                      by = ACAO_COD]

reest_fes <- reest_desp[eval(INTRA_SAUDE),
                      .(VL_REEST_DESP = sum(VL_REEST_DESP)),
                      by = ACAO_COD]

repasse_fes[rec_reest, VL_REEST_REC := i.VL_REEST_REC, on = c("UO_COD")]
repasse_fes[rec, VL_EFET_AJUST := i.VL_EFET_AJUST, on = c("UO_COD")]

repasse_fes[reest, VL_REEST_DESP := i.VL_REEST_DESP, on = c("UO_COD")]
repasse_fes[supl, VL_CRED_AUT := i.VL_CRED_AUT, on = c("UO_COD")]
repasse_fes[cota, VL_COTA_APROVADA := i.VL_COTA_APROVADA, on = c("UO_COD")]
repasse_fes[desp, VL_EMP := i.VL_EMP, on = c("UO_COD")]

repasse_fes[reest, VL_REEST_DESP_FES := i.VL_REEST_DESP, on = c("UO_COD")]
repasse_fes[supl_fes, VL_CRED_AUT_FES := i.VL_CRED_AUT, on = c("ACAO_COD")]
repasse_fes[cota_fes, VL_COTA_APROVADA_FES := i.VL_COTA_APROVADA, on = c("ACAO_COD")]
repasse_fes[desp_fes, VL_EMP_FES := i.VL_EMP, on = c("ACAO_COD")]

setcolorder(repasse_fes, 
            c("ANO", "UO_COD", "UO_SIGLA",
              "VL_REEST_DESP", "VL_CRED_AUT", "VL_COTA_APROVADA", "VL_EMP",
              "RECEITA_COD", "RECEITA_DESC",
              "VL_REEST_REC", "VL_EFET_AJUST",
              "ACAO_COD", "ACAO_DESC",
              "VL_REEST_DESP_FES", "VL_CRED_AUT_FES", "VL_COTA_APROVADA_FES", "VL_EMP_FES"))

writexl::write_xlsx(repasse_fes, "reports/repasse_fes.xlsx")

