#!/usr/bin/env ruby

class JSONPrinter
  attr_reader :string, :num_tabs

  def initialize(string)
    raise ArgumentError.new("cannot parse nil") if string.nil?
    @string = string
    @num_tabs = 0
  end

  def pretty_print
    print JSONChar::NEWLINE

    is_escaped = false
    is_quoted = false
    string.each_char do |c|
      char = JSONChar.new(c, :is_escaped => is_escaped, :is_quoted => is_quoted)
      if char.is_backslash?
        is_escaped = true
        next
      end

      if char.is_quote?
        is_quoted = !is_quoted
      end

      @num_tabs += 1 if char.is_open?
      @num_tabs -= 1 if char.is_closed?

      char.print_with num_tabs
      is_escaped = false
    end

    print JSONChar::NEWLINE
  end
end

class JSONChar
  attr_reader :char, :is_escaped, :is_quoted

  TAB = "  "
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

  def print_with(num_tabs)
    # strips out illegal noise and whitespace between control chars
    return if !is_quoted && !CONTROL_CHARS.include?(char)

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
  printer = JSONPrinter.new $stdin.read
  printer.pretty_print
end

