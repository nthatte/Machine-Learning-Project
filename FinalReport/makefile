final_report.pdf : final_report.tex final_report.aux final_report.bbl
	pdflatex final_report.tex
	pdflatex final_report.tex

finalreport.bbl: final_report.bib finalreport.aux
	pdflatex final_report.tex
	bibtex final_report
