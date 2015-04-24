#!/bin/bash

# cat will listen for arguments piped to STDIN if no arguments are provided
# otherwise it will try to read the file passed
# thanks to http://stackoverflow.com/a/20351363
path=$(echo $0 | sed 's/json_parser.sh/parser.rb/g')
json="$(cat "$@")" ruby $path
