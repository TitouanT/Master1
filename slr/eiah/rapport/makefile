DOCUMENT = cr_Titouan_Teyssier
OPENER = xdg-open

open: all clean
	$(OPENER) $(DOCUMENT).pdf &> /dev/null

all: $(DOCUMENT).tex
	pdflatex $<
	# a second time to get references and table of contents
	pdflatex $<

clean:
	rm -f *.aux *.log *.toc

mrproper: clean
	rm $(DOCUMENT).pdf
