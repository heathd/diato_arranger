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

module MusicalNoteHelper
  def note(pitch, options = {})
    [Abc::MusicalNote.new(pitch, options)]
  end
  
  def notes(*pitches)
    pitches.map {|p| Abc::MusicalNote.new(p) }
  end
end

module ParserTestHelper
  
  def parse_notation(notation_text)
    preamble = "X:1\nT:Sample\nK:C\n"
    input = preamble + notation_text + "\n"
    @parser.parse(input).notes
  end
  
  def assert_parsable(input)
    assert @parser.parse(input), lambda { @parser.failure_reason }
  end
  
  def show_notes(result)
    puts "\n"
    bars = result.notes.join.scan(/.{8}/)
    lines = bars.each_slice(4).map do |bars|
      bars.join " | "
    end
    puts lines
    puts "\n"
  end
end