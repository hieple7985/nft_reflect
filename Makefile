SHELL := /bin/bash

ifndef LIGO
	LIGO=$(HOME)/ligo
endif

test:
	$(LIGO) run test tests/index.mligo 
