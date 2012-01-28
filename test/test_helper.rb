require "rubygems"
require "bundler/setup"
Bundler.require(:default, :development, :test)
require 'minitest/unit'
require 'minitest/autorun'

# require 'treetop'

class MiniTest::Unit::TestCase
  include Shoulda::Context::Assertions
  include Shoulda::Context::InstanceMethods
  extend Shoulda::Context::ClassMethods
end

module ParserTestHelper
  def show_failure(parser, input = nil)
    input ||= @input
    puts "#{parser.failure_reason} at line #{parser.failure_line} column #{parser.failure_column}"
    puts context(input, parser.failure_line, parser.failure_column)
  end
  
  def context(input, line, column = nil)
    context = []
    lines = input.split(/\r\n|\n|\r/, -1)
    from = [0, line - 3].max
    to = [lines.size, line + 3].min
    (from...to).each do |i|
      if column and i+1 == line
        context << "     " + ("-" * (column - 1)) + "v"
      end
      context << ("%3d" % (i+1)) + ": " + lines[i]
    end
    context.join("\n")
  end
  
  def line_and_col(input, failure_index)
    prefix = input[0...failure_index]
    prefix_lines = prefix.split(/\r\n|\n|\r/, -1)
    failure_line = prefix_lines.size
    failure_column = prefix_lines.last.size + 1
    [failure_line, failure_column]
  end
  
  def show_failure2(failure, input = nil)
    input ||= @input
    lineno, colno = line_and_col(input, failure.index)
    puts "#{failure} at line #{lineno} col #{colno}"
    puts context(input, lineno, colno)
    puts "\n\n"
  end
end