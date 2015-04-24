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

      if char.is_backslash? && !is_quoted
        is_escaped = true
        next
      end

      next if char.char =~ /\s/ && !is_quoted
      is_quoted = !is_quoted if char.char == JSONChar::QUOTE
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

  def initialize(char, options={})
    @char = char
    @is_quoted = options[:is_quoted] || false
    @is_escaped = options[:is_escaped] || false
  end

  def is_open_brace?
    char == OPEN_BRACE && !is_escaped && !is_quoted
  end

  def is_closed_brace?
    char == CLOSED_BRACE && !is_escaped && !is_quoted
  end

  def is_open_bracket?
    char == OPEN_BRACKET && !is_escaped && !is_quoted
  end

  def is_closed_bracket?
    char == CLOSED_BRACKET && !is_escaped && !is_quoted
  end

  def is_backslash?
    char == "\\" && !is_escaped
  end

  def is_comma?
    char == "," && !is_escaped && !is_quoted
  end

  def is_newline?
    char == "n" && is_escaped && !is_quoted
  end

  def is_tab?
    char == "t" && is_escaped && !is_quoted
  end

  def is_open?
    is_open_brace? || is_open_bracket?
  end

  def is_closed?
    is_closed_brace? || is_closed_bracket?
  end

  def print_with(num_tabs)
    if is_open?
      print char
      print NEWLINE
      print TAB * num_tabs
    elsif is_closed?
      print NEWLINE
      print TAB * num_tabs
      print char
    elsif is_comma?
      print char
      print NEWLINE
      print TAB * num_tabs
    elsif is_newline?
      print NEWLINE
    elsif is_tab?
      print TAB
    else
      print char
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  printer = JSONPrinter.new $stdin.read
  printer.pretty_print
end

