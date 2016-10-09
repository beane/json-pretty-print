### Deprecated in favor of https://github.com/beane/json_pretty_printer_shell 

### JSON Pretty Printer
:-)

### Motivation
Sometimes I have to work with janky JSON-like objects that aren't quite valid JSON and I couldn't find any parsers that pretty-print invalid JSON. Now there is one!

### Usage
`cat ./test.json | ./json_pretty_printer.rb`

### Notes
Since it takes data as a stream, it's harder to make sure that all special non-quoted values are correct (true, false, null, and numbers). This project doesn't even bother - it will print what you give it. It will only attempt to prettify the output by assuming that the format is JSON-like.

It will not corrupt valid JSON - just reformat it. The printer will suppress printing non-quoted whitespace.

I gladly accept pull requests!

And, as always, use at your own risk.

### JSON Pretty Printer will *NOT*
- validate your input
- break on invalid json
- hurt your feelings

