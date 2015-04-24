#!/bin/bash

# cat will listen for arguments piped to STDIN if no arguments are provided
# otherwise it will try to read the file passed
# thanks to http://stackoverflow.com/a/20351363
json="$(cat "$@")" ruby ./parser.rb
