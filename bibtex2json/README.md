# bibtex2json

This is a BibTeX `.bst` style that converts `.bib` entries to JSON format.
It helps generate baselines for BibTeX parse.

```bash
bibtex data.aux
```

The output is generated to `data.bbl` in JSON format.

This tool has the following limitations.

1. It only handles fields and entry types already defined in the `.bst` script.
2. BibTeX breaks long lines into multiple ones in the `.bbl` output but it
   doesn't work with JSON strings. This can be fixed via
   `python3 fix-bbl-json.py data.bbl`.
