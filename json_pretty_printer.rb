#!/usr/bin/env ruby

class JSONChar
  attr_reader :char, :is_escaped, :is_quoted

  TAB = "    "
  NEWLINE = "\n"
  QUOTE = "\""
  OPEN_BRACE = "{"
  CLOSED_BRACE = "}"
  OPEN_BRACKET = "["
  CLOSED_BRACKET = "]"
  BACKSLASH = "\\"
  COMMA = ","
  COLON = ":"

  OPEN_CHARS = [
    OPEN_BRACE,
    OPEN_BRACKET
  ]

  CLOSED_CHARS = [
    CLOSED_BRACE,
    CLOSED_BRACKET
  ]

  CONTROL_CHARS = [
    COMMA,
    QUOTE,
    COLON
  ] + CLOSED_CHARS + OPEN_CHARS

  def initialize(char, options={})
    @char = char
    @is_quoted = options[:is_quoted] || false
    @is_escaped = options[:is_escaped] || false
  end

  def escape(arg)
    print BACKSLASH
    print arg
  end

  def is_open?
    OPEN_CHARS.include?(char) && !is_escaped && !is_quoted
  end

  def is_closed?
    CLOSED_CHARS.include?(char) && !is_escaped && !is_quoted
  end

  def is_whitespace?
    return true if ["s", "t", "n", "r"].include?(char) && is_escaped
    char == " "
  end

  def is_quote?
    char == QUOTE && !is_escaped
  end

  def is_backslash?
    char == BACKSLASH && !is_escaped
  end

  def is_numeric?
    char =~ /[\.0-9]/ && !is_escaped
  end

  def print_with(num_tabs)
    return if is_whitespace? && !is_quoted # ignore non-quoted whitespace
    return print "#{char} " if char == COLON && !is_escaped && !is_quoted
    # strips out illegal noise and whitespace before/between/after control chars
    # return print char if is_numeric? && !is_quoted # preserves numbers
    # return if !is_quoted && !CONTROL_CHARS.include?(char)

    if is_escaped
      escape(char)
    elsif !is_escaped && !is_quoted
      if (OPEN_CHARS + [COMMA]).include? char
        print char
        print NEWLINE
        print TAB * num_tabs
      elsif CLOSED_CHARS.include? char
        print NEWLINE
        print TAB * num_tabs
        print char
      else
        print char
      end
    else
      # if the character is in quotes and not escaped
      print char
    end

    nil
  end
end

if __FILE__ == $PROGRAM_NAME
  print JSONChar::NEWLINE

  num_tabs = 0
  is_escaped = false
  is_quoted = false
  json_started = false
  ARGF.each_char do |c|
    # a little hack to print out non-json before
    # the json object is given
    # useful for curl headers when the response is JSON
    json_started = true if c == JSONChar::OPEN_BRACE
    if !json_started
      print c
      next
    end

    char = JSONChar.new(c, {
      :is_escaped => is_escaped,
      :is_quoted => is_quoted
    })

    if char.is_backslash?
      is_escaped = true
      next
    end

    if char.is_quote?
      is_quoted = !is_quoted
    end

    num_tabs += 1 if char.is_open?
    num_tabs -= 1 if char.is_closed?

    char.print_with num_tabs
    is_escaped = false
  end

  print JSONChar::NEWLINE
end

