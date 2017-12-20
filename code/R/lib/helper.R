add_saude <- function(base) {
  
  base[, SAUDE := NA_character_]
  
  base[ANO == 2017 & UO_COD == 4291 & ACAO_COD %in% c(4245, 4272, 4283, 4301, 4304, 4637, 4432, 4697), 
       SAUDE := "2.Repasse FES"]
  
  base[ANO == 2017 & UO_COD == 4291 & ACAO_COD == 4277, 
       SAUDE := "3.Repasse FES - Unimontes"]
  
  base[is.na(SAUDE) & ANO == 2017 & UO_COD %in% c(1301, 1451, 1541, 1691, 2071, 2261, 2271, 2321, 4291) & FUNCAO_COD == 10 & FONTE_COD == 10, 
       SAUDE := "1.ASPS"]
  
}

add_tipo <- function(base) {
  
  base[, TIPO := NA_character_]
  
  base[GRUPO_COD == 1, 
       TIPO := "1.Pessoal"]
  
  base[is.na(TIPO) & IPU_COD == 7, 
       TIPO := "2.Auxilio"]
  
  base[is.na(TIPO), 
       TIPO := "3.OCC"]
  
  if(anyNA(base$TIPO)) {
    warning("Linhas não classificadas: ", 
            paste(which(is.na(base$TIPO)), collapse = ", "))
  }       
  
  return(base[])
}
