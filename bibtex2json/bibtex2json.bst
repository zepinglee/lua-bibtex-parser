% This BibTeX `.bst` style converts `.bib` entries to JSON format.
% Run `bibtex data.aux` and the output is generated to `data.bbl` in JSON format.
%
% This script has the following limitations.
%
% 1. It only handles fields and entry types already defined in the .bst script.
% 2. BibTeX breaks long lines into multiple ones in the `.bbl` output but it
%    doesn't work with JSON strings. This can be fixed via
%    `python3 fix-bbl-json.py data.bbl`.


% The fields are collected from standard data models of BiBTeX and biblatex.
ENTRY {
  abstract
  addendum
  address
  afterword
  annotation
  annotator
  annote
  archiveprefix
  author
  authortype
  bookauthor
  bookpagination
  booksubtitle
  booktitle
  booktitleaddon
  chapter
  commentator
  date
  doi
  edition
  editor
  editora
  editoratype
  editorb
  editorbtype
  editorc
  editorctype
  editortype
  eid
  entryset
  entrysubtype
  eprint
  eprintclass
  eprinttype
  eventdate
  eventtitle
  eventtitleaddon
  execute
  file
  foreword
  gender
  holder
  howpublished
  hyphenation
  ids
  indexsorttitle
  indextitle
  institution
  introduction
  isan
  isbn
  ismn
  isrn
  issn
  issue
  issuesubtitle
  issuetitle
  issuetitleaddon
  iswc
  journal
  journalsubtitle
  journaltitle
  journaltitleaddon
  key
  keywords
  label
  langid
  langidopts
  language
  library
  lista
  listb
  listc
  listd
  liste
  listf
  location
  mainsubtitle
  maintitle
  maintitleaddon
  month
  namea
  nameaddon
  nameatype
  nameb
  namebtype
  namec
  namectype
  note
  number
  options
  organization
  origdate
  origlanguage
  origlocation
  origpublisher
  origtitle
  pages
  pagetotal
  pagination
  part
  pdf
  presort
  primaryclass
  publisher
  pubstate
  related
  relatedoptions
  relatedstring
  relatedtype
  reprinttitle
  school
  series
  shortauthor
  shorteditor
  shorthand
  shorthandintro
  shortjournal
  shortseries
  shorttitle
  sortkey
  sortname
  sortshorthand
  sorttitle
  sortyear
  subtitle
  title
  titleaddon
  translator
  type
  url
  urldate
  usera
  userb
  userc
  userd
  usere
  userf
  venue
  verba
  verbb
  verbc
  version
  volume
  volumes
  xdata
  xref
  year
} {} {}


INTEGERS { entry.index field.index name.index num.names name.part.index i }

STRINGS { field name s }


FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}


FUNCTION {escape.json}
{ 's :=
  ""
    { s empty$ not }
    { s #1 #1 substring$ "\" =
        { "\" * }
        { s #1 #1 substring$ quote$ =
            { "\" * }
            'skip$
          if$
        }
      if$
      s #1 #1 substring$ *
      s #2 global.max$ substring$ 's :=
    }
  while$
}

FUNCTION {format.field}
{ 'field :=
  duplicate$ missing$
    'pop$
    { field.index #1 + 'field.index :=
      field.index #1 >
        { "," write$ }
        'skip$
      if$
      newline$
      escape.json
      "            " quote$ * field * quote$ * ": " * quote$ * swap$ * quote$ * write$
    }
  if$
}


FUNCTION {format.name.part}
{ swap$
  duplicate$ empty$
    { pop$ pop$ }
    { name.part.index #1 + 'name.part.index :=
      name.part.index #1 >
        { "," write$ }
        'skip$
      if$
      newline$
      escape.json
      quote$ *
      quote$ ": " * quote$ * swap$ * *
      "                    " quote$ * swap$ *
      write$
    }
  if$
}


FUNCTION {format.name.field}
{ 'field :=
  duplicate$ missing$
    'pop$
    { field.index #1 + 'field.index :=
      field.index #1 >
        { "," write$ newline$ }
        'skip$
      if$
      'name :=
      "            " quote$ * field * quote$ * ": [" * write$
      #1 'name.index :=
      name num.names$ 'num.names :=
        { name.index num.names #1 + < }
        { name.index #1 >
            { "," write$ }
            'skip$
          if$
          newline$
          #0 'name.part.index :=
          "                {" write$
          name name.index "{vv}" format.name$ "von" format.name.part
          name name.index "{ll}" format.name$ "last" format.name.part
          name name.index "{ff}" format.name$ "first" format.name.part
          name name.index "{jj}" format.name$ "jr" format.name.part
          newline$
          "                }" write$
          name.index #1 + 'name.index :=
        }
      while$
      newline$
      "            ]" write$
    }
  if$
}


FUNCTION {format.fields}
{ abstract "abstract" format.field
  addendum "addendum" format.field
  address "address" format.field
  afterword "afterword" format.name.field
  annotation "annotation" format.field
  annotator "annotator" format.name.field
  annote "annote" format.field
  archiveprefix "archiveprefix" format.field
  author "author" format.name.field
  authortype "authortype" format.field
  bookauthor "bookauthor" format.name.field
  bookpagination "bookpagination" format.field
  booksubtitle "booksubtitle" format.field
  booktitle "booktitle" format.field
  booktitleaddon "booktitleaddon" format.field
  chapter "chapter" format.field
  commentator "commentator" format.name.field
  date "date" format.field
  doi "doi" format.field
  edition "edition" format.field
  editor "editor" format.name.field
  editora "editora" format.name.field
  editoratype "editoratype" format.field
  editorb "editorb" format.name.field
  editorbtype "editorbtype" format.field
  editorc "editorc" format.name.field
  editorctype "editorctype" format.field
  editortype "editortype" format.field
  eid "eid" format.field
  entryset "entryset" format.field
  entrysubtype "entrysubtype" format.field
  eprint "eprint" format.field
  eprintclass "eprintclass" format.field
  eprinttype "eprinttype" format.field
  eventdate "eventdate" format.field
  eventtitle "eventtitle" format.field
  eventtitleaddon "eventtitleaddon" format.field
  execute "execute" format.field
  file "file" format.field
  foreword "foreword" format.name.field
  gender "gender" format.field
  holder "holder" format.name.field
  howpublished "howpublished" format.field
  hyphenation "hyphenation" format.field
  ids "ids" format.field
  indexsorttitle "indexsorttitle" format.field
  indextitle "indextitle" format.field
  institution "institution" format.field
  introduction "introduction" format.name.field
  isan "isan" format.field
  isbn "isbn" format.field
  ismn "ismn" format.field
  isrn "isrn" format.field
  issn "issn" format.field
  issue "issue" format.field
  issuesubtitle "issuesubtitle" format.field
  issuetitle "issuetitle" format.field
  issuetitleaddon "issuetitleaddon" format.field
  iswc "iswc" format.field
  journal "journal" format.field
  journalsubtitle "journalsubtitle" format.field
  journaltitle "journaltitle" format.field
  journaltitleaddon "journaltitleaddon" format.field
  key "key" format.field
  keywords "keywords" format.field
  label "label" format.field
  langid "langid" format.field
  langidopts "langidopts" format.field
  language "language" format.field
  library "library" format.field
  lista "lista" format.field
  listb "listb" format.field
  listc "listc" format.field
  listd "listd" format.field
  liste "liste" format.field
  listf "listf" format.field
  location "location" format.field
  mainsubtitle "mainsubtitle" format.field
  maintitle "maintitle" format.field
  maintitleaddon "maintitleaddon" format.field
  month "month" format.field
  namea "namea" format.name.field
  nameaddon "nameaddon" format.field
  nameatype "nameatype" format.field
  nameb "nameb" format.name.field
  namebtype "namebtype" format.field
  namec "namec" format.name.field
  namectype "namectype" format.field
  note "note" format.field
  number "number" format.field
  options "options" format.field
  organization "organization" format.field
  origdate "origdate" format.field
  origlanguage "origlanguage" format.field
  origlocation "origlocation" format.field
  origpublisher "origpublisher" format.field
  origtitle "origtitle" format.field
  pages "pages" format.field
  pagetotal "pagetotal" format.field
  pagination "pagination" format.field
  part "part" format.field
  pdf "pdf" format.field
  presort "presort" format.field
  primaryclass "primaryclass" format.field
  publisher "publisher" format.field
  pubstate "pubstate" format.field
  related "related" format.field
  relatedoptions "relatedoptions" format.field
  relatedstring "relatedstring" format.field
  relatedtype "relatedtype" format.field
  reprinttitle "reprinttitle" format.field
  school "school" format.field
  series "series" format.field
  shortauthor "shortauthor" format.name.field
  shorteditor "shorteditor" format.name.field
  shorthand "shorthand" format.field
  shorthandintro "shorthandintro" format.field
  shortjournal "shortjournal" format.field
  shortseries "shortseries" format.field
  shorttitle "shorttitle" format.field
  sortkey "sortkey" format.field
  sortname "sortname" format.name.field
  sortshorthand "sortshorthand" format.field
  sorttitle "sorttitle" format.field
  sortyear "sortyear" format.field
  subtitle "subtitle" format.field
  title "title" format.field
  titleaddon "titleaddon" format.field
  translator "translator" format.name.field
  type "type" format.field
  url "url" format.field
  urldate "urldate" format.field
  usera "usera" format.field
  userb "userb" format.field
  userc "userc" format.field
  userd "userd" format.field
  usere "usere" format.field
  userf "userf" format.field
  venue "venue" format.field
  verba "verba" format.field
  verbb "verbb" format.field
  verbc "verbc" format.field
  version "version" format.field
  volume "volume" format.field
  volumes "volumes" format.field
  xdata "xdata" format.field
  xref "xref" format.field
  year "year" format.field
}


FUNCTION {convert.to.json}
{ entry.index #1 + 'entry.index :=
  entry.index #1 =
    'skip$
    { "," write$ }
  if$
  newline$
  "    {" write$
  newline$
  "        " quote$ * "key" * quote$ * ": " * quote$ * cite$ escape.json * quote$ * "," * write$ newline$
  "        " quote$ * "type" * quote$ * ": " * quote$ * type$ escape.json * quote$ * "," * write$ newline$
  "        " quote$ * "fields" * quote$ * ": " * "{" * write$
  #0 'field.index :=
  format.fields
  cite$ top$
  field.index top$
  field.index #0 >
    { newline$
      "        " write$
    }
    'skip$
  if$
  "}" write$ newline$
  "    }" write$
}


% The following entry tyeps are collected from standard data models of BiBTeX and biblatex.
FUNCTION {article} {convert.to.json}
FUNCTION {artwork} {convert.to.json}
FUNCTION {audio} {convert.to.json}
FUNCTION {bibnote} {convert.to.json}
FUNCTION {book} {convert.to.json}
FUNCTION {bookinbook} {convert.to.json}
FUNCTION {booklet} {convert.to.json}
FUNCTION {collection} {convert.to.json}
FUNCTION {comment} {convert.to.json}
FUNCTION {commentary} {convert.to.json}
FUNCTION {conference} {convert.to.json}
FUNCTION {customa} {convert.to.json}
FUNCTION {customb} {convert.to.json}
FUNCTION {customc} {convert.to.json}
FUNCTION {customd} {convert.to.json}
FUNCTION {custome} {convert.to.json}
FUNCTION {customf} {convert.to.json}
FUNCTION {dataset} {convert.to.json}
FUNCTION {electronic} {convert.to.json}
FUNCTION {image} {convert.to.json}
FUNCTION {inbook} {convert.to.json}
FUNCTION {incollection} {convert.to.json}
FUNCTION {inproceedings} {convert.to.json}
FUNCTION {inreference} {convert.to.json}
FUNCTION {jurisdiction} {convert.to.json}
FUNCTION {legal} {convert.to.json}
FUNCTION {legislation} {convert.to.json}
FUNCTION {letter} {convert.to.json}
FUNCTION {manual} {convert.to.json}
FUNCTION {mastersthesis} {convert.to.json}
FUNCTION {misc} {convert.to.json}
FUNCTION {movie} {convert.to.json}
FUNCTION {music} {convert.to.json}
FUNCTION {mvbook} {convert.to.json}
FUNCTION {mvcollection} {convert.to.json}
FUNCTION {mvproceedings} {convert.to.json}
FUNCTION {mvreference} {convert.to.json}
FUNCTION {online} {convert.to.json}
FUNCTION {patent} {convert.to.json}
FUNCTION {performance} {convert.to.json}
FUNCTION {periodical} {convert.to.json}
FUNCTION {phdthesis} {convert.to.json}
FUNCTION {preamble} {convert.to.json}
FUNCTION {proceedings} {convert.to.json}
FUNCTION {reference} {convert.to.json}
FUNCTION {report} {convert.to.json}
FUNCTION {review} {convert.to.json}
FUNCTION {set} {convert.to.json}
FUNCTION {software} {convert.to.json}
FUNCTION {standard} {convert.to.json}
FUNCTION {string} {convert.to.json}
FUNCTION {suppbook} {convert.to.json}
FUNCTION {suppcollection} {convert.to.json}
FUNCTION {suppperiodical} {convert.to.json}
FUNCTION {techreport} {convert.to.json}
FUNCTION {thesis} {convert.to.json}
FUNCTION {unpublished} {convert.to.json}
FUNCTION {video} {convert.to.json}
FUNCTION {www} {convert.to.json}

FUNCTION {comment@book} {convert.to.json}
FUNCTION {!$&*+-./:;<>?@[\]^_`|~} {convert.to.json}

FUNCTION {default.type} {convert.to.json}


MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}



READ


FUNCTION { start }
{ "[" write$
  #0 'entry.index :=
}

EXECUTE {start}


ITERATE {call.type$}


FUNCTION { end }
{ entry.index #0 >
    'newline$
    'skip$
  if$
  "]" write$
  newline$
}

EXECUTE {end}
