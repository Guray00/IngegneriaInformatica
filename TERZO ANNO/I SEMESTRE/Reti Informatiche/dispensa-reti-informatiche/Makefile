all:
	mkdir -p build
	pdflatex -output-directory build reti.tex
	cp bibliografia.bib build
	cd build; bibtex reti
	pdflatex -output-directory build reti.tex
	pdflatex -output-directory build reti.tex
	mkdir -p dist
	mv build/reti.pdf dist

clean:
	rm -rf build
