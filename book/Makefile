#! Makefile for building the LaTeX book and per-chapter PDFs
# Tools: tries latexmk first; falls back to pdflatex+bibtex

PDFLATEX=pdflatex
BIBTEX=bibtex
FLAGS=-pdf -interaction=nonstopmode -halt-on-error

BOOK_DIR=.
CH_DIR=$(BOOK_DIR)/chapters
MAIN=$(BOOK_DIR)/main.tex
MAIN_BASENAME=$(basename $(notdir $(MAIN)))
CHAPTERS= \
  $(CH_DIR)/01-pendahuluan.tex \
  $(CH_DIR)/02-analisis-lexikal.tex \
  $(CH_DIR)/03-analisis-sintaksis.tex \
  $(CH_DIR)/04-analisis-semantik.tex \
  $(CH_DIR)/05-syntesis.tex

.PHONY: all book chapters clean

all: book

book:
	@if command -v latexmk >/dev/null 2>&1; then \
	  latexmk $(FLAGS) $(MAIN); \
	else \
	  $(PDFLATEX) -interaction=nonstopmode $(MAIN); \
	  if grep -q "\\\bibliography" $(MAIN); then $(BIBTEX) $(BOOK_DIR)/$(MAIN_BASENAME) || true; fi; \
	  $(PDFLATEX) -interaction=nonstopmode $(MAIN); \
	  $(PDFLATEX) -interaction=nonstopmode $(MAIN); \
	fi

chapters: $(CHAPTERS:.tex=.pdf)

$(CH_DIR)/%.pdf: $(CH_DIR)/%.tex $(MAIN)
	@cd $(CH_DIR) && \
	if command -v latexmk >/dev/null 2>&1; then \
	  latexmk $(FLAGS) $(notdir $<); \
	else \
	  $(PDFLATEX) -interaction=nonstopmode $(notdir $<); \
	  if grep -q "\\\bibliography" $(notdir $<); then $(BIBTEX) $(basename $(notdir $<)) || true; fi; \
	  $(PDFLATEX) -interaction=nonstopmode $(notdir $<); \
	  $(PDFLATEX) -interaction=nonstopmode $(notdir $<); \
	fi

clean:
	@if command -v latexmk >/dev/null 2>&1; then \
	  latexmk -C $(MAIN); \
	else \
	  rm -f $(BOOK_DIR)/$(MAIN_BASENAME).{aux,bbl,blg,log,out,toc,lof,lot,fls,fdb_latexmk}; \
	fi
	@cd $(CH_DIR) && for f in *.tex; do \
	  if command -v latexmk >/dev/null 2>&1; then latexmk -C $$f || true; \
	  else bn=$${f%.tex}; rm -f $$bn.{aux,bbl,blg,log,out,toc,lof,lot,fls,fdb_latexmk}; fi; \
	done

