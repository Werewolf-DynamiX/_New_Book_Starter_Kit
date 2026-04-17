.PHONY: all epub print docx md clean release help

help:
	@echo "Build targets:"
	@echo "  make all      - Build MD + EPUB + PDF + DOCX"
	@echo "  make md       - Compile merged manuscript markdown only"
	@echo "  make epub     - Build EPUB (requires pandoc)"
	@echo "  make print    - Build PDF (requires pandoc + LuaLaTeX)"
	@echo "  make docx     - Build DOCX (requires pandoc)"
	@echo "  make clean    - Remove build artifacts from release/"
	@echo "  make release  - Alias for 'all'"

all:
	@bash scripts/compile.sh all

md:
	@bash scripts/compile.sh md

epub:
	@bash scripts/compile.sh epub

print:
	@bash scripts/compile.sh print

docx:
	@bash scripts/compile.sh docx

clean:
	@rm -f release/*.pdf release/*.epub release/*.docx release/*.md
	@echo "Cleaned release/"

release: all
	@echo ""
	@echo "Release artifacts ready in release/"
