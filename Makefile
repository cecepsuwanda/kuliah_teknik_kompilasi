# Simple Makefile to build the full book or individual chapters

TEX=pdflatex
BIB=biber
MAIN=main
CHAPTERS_DIR=chapters

all: book

book:
	$(TEX) -interaction=nonstopmode $(MAIN).tex
	$(BIB) $(MAIN)
	$(TEX) -interaction=nonstopmode $(MAIN).tex
	$(TEX) -interaction=nonstopmode $(MAIN).tex

chapter-%:
	$(TEX) -interaction=nonstopmode "$(CHAPTERS_DIR)/$*.tex"
	$(BIB) "$(CHAPTERS_DIR)/$*"
	$(TEX) -interaction=nonstopmode "$(CHAPTERS_DIR)/$*.tex"
	$(TEX) -interaction=nonstopmode "$(CHAPTERS_DIR)/$*.tex"

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.log *.out *.toc *.run.xml *.lof *.lot
	rm -f $(CHAPTERS_DIR)/*.aux $(CHAPTERS_DIR)/*.log $(CHAPTERS_DIR)/*.out

.PHONY: all book clean chapter-%
