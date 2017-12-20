.PHONY: help

#====================================================================
# determina bases que serao copiadas na execucao dos targets copy com base em config.yaml

TARGETS_COPY_EXEC := $(shell Rscript config/R/get_targets_copy.R exec 2> logs/log.Rout)
TARGETS_COPY_REEST := $(shell Rscript config/R/get_targets_copy.R reest 2> logs/log.Rout)

#====================================================================
# PHONY TARGETS

help: 
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

copy: copy_exec copy_reest ## Copia a base da receita e da despesa para sua pasta local

#====================================================================
# bases reest
copy_reest: $(TARGETS_COPY_REEST)

copy_reest_rec:
	@Rscript config/R/copy.R $@ 2> logs/log.Rout

copy_reest_desp:
	@Rscript config/R/copy.R $@ 2> logs/log.Rout

#====================================================================
# bases exec
copy_exec: $(TARGETS_COPY_EXEC)

copy_exec_rec:
	@Rscript config/R/copy.R $@ 2> logs/log.Rout

copy_exec_desp:
	@Rscript config/R/copy.R $@ 2> logs/log.Rout

copy_exec_suplementacao:
	@Rscript config/R/copy.R $@ 2> logs/log.Rout

copy_exec_cota:
	@Rscript config/R/copy.R $@ 2> logs/log.Rout