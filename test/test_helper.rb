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
  def show_failure(failure, input = nil)
    input ||= @input
    prefix = input[0...failure.index]
    prefix_lines = prefix.split(/\r\n|\n|\r/, -1)
    lineno = prefix_lines.size
    colno = prefix_lines.last.size + 1
    lines = input.split(/\r\n|\n|\r/, -1)
    puts "#{failure} at line #{lineno} col #{colno}"
    from = [0, lineno - 3].max
    to = [lines.size, lineno + 3].min
    (from...to).each do |i|
      if i+1 == lineno
        puts "     " + ("-" * (colno - 1)) + "v"
      end
      puts ("%3d" % (i+1)) + ": " + lines[i]
    end
    puts "\n\n"
  end
end