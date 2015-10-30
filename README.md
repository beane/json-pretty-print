### JSON Pretty Printer
:-)

### Motivation
Sometimes I have to work with janky JSON-like objects that aren't quite valid JSON and I couldn't find any parsers that pretty-print invalid JSON. Now there is one!

### Usage
`cat ./test.json | ./json_pretty_printer.rb`

### Known Bugs
Since it takes data as a stream, it's harder to make sure that all special non-quoted values are correct (true, false, null, and numbers).

~~It will miss decimal points in numbers~~

It will take values that look like true/false/null:
    - `loltruethy` will be printed as `true`

### JSON Pretty Printer will *NOT*
- validate your input
- break on invalid json
- hurt your feelings

