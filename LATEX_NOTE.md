# LaTeX PDF Manual Note

The package passes all functional checks but shows a LaTeX error when generating the PDF manual.

## Error
```
! LaTeX Error: File `inconsolata.sty' not found.
```

## Impact
- This error does NOT affect package installation or functionality
- It only affects the creation of PDF documentation
- The package works perfectly without the PDF manual
- HTML documentation is generated successfully

## Fix (Optional)

If you want to generate PDF documentation, install the LaTeX package:

### macOS (using MacTeX or TinyTeX)
```bash
# If using MacTeX:
sudo tlmgr install inconsolata

# If using TinyTeX (recommended for R users):
tinytex::tlmgr_install("inconsolata")
```

### Linux
```bash
# Ubuntu/Debian
sudo apt-get install texlive-fonts-extra

# Fedora
sudo dnf install texlive-inconsolata
```

## Alternative: Skip PDF Check

You can check the package without PDF generation:
```bash
R CMD check --no-manual wanikani.r
```

This will give you a clean check without the LaTeX requirement.
