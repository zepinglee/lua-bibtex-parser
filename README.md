# lua-bibtex-parser


Previously I wrote a BibTeX parser for <https://github.com/zepinglee/citeproc-lua>
and I'm planning to make it a standalone project here. This parser is aimed
at matching the original BibTeX's syntax.


## Improvements (TODO)

- Fault-tolerant: Able to parse files with syntax errors
- Exporting matching the original
- Easily modifying
- Formatting options for writing


## BibTeX grammar

The following PEG is largely based on <https://github.com/aclements/biblib>
with small fixes after I checked the BibTeX source code [bibtex.web](https://github.com/TeX-Live/texlive-source/blob/trunk/texk/web2c/bibtex.web).


```
bib_db = comment (command_or_entry comment)*

comment = [^@]*

ws = [ \t\n]*

ident = ![0-9] (![ \t"#%'(),={}] [\x20-\x7f])+

command_or_entry = '@' ws (comment_command / preamble / string / entry)

comment_command = 'comment' &[ \t\n{(]

preamble = 'preamble' ws ( '{' ws preamble_body ws '}'
                            / '(' ws preamble_body ws ')' )

preamble_body = value

string = 'string' ws ( '{' ws string_body ws '}'
                        / '(' ws string_body ws ')' )

string_body = ident ws '=' ws value

entry = ident ws ( '{' ws key ws entry_body? ws '}'
                    / '(' ws key_paren ws entry_body? ws ')' )

key = [^, \t}\n]*

key_paren = [^, \t\n]*

entry_body = (',' ws ident ws '=' ws value ws)* ','?

value = field_token (ws '#' ws field_token)*

field_token
    = [0-9]+
    / '{' balanced* '}'
    / '"' (!'"' balanced)* '"'
    / ident

balanced
    = '{' balanced* '}'
    / [^{}]
```
