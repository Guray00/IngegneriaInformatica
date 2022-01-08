all:
	mkdir -p build
	pdflatex -output-directory build so.tex
	cp bibliografia.bib build
	cd build; bibtex so
	pdflatex -output-directory build so.tex
	pdflatex -output-directory build so.tex
	mkdir -p dist
	mv build/so.pdf dist

clean:
	rm -rf build
