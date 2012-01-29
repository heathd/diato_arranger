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

module PlayingInstructionHelper
  def push(row, button)
    PlayingInstruction.new(row, :push, button)
  end
  
  def pull(row, button)
    PlayingInstruction.new(row, :pull, button)
  end
end

module MusicalNoteHelper
  def note(pitch, options = {})
    [Abc::MusicalNote.new(pitch, options)]
  end
  
  def notes(pitches)
    pitches.map do |p|
      match = p.match(/(\^?)(.)(-?[0-9])/)
      if match
        accidental, p, octave = match[1..3]
      end
      Abc::MusicalNote.new(p, octave: octave, accidental: accidental == '^' ? :sharp : nil)
    end
  end
  
  def accompaniment(pitches)
    pitches.map do |p|
      match = p.match(/([CDEFGAB])(m)?([0-9]+)?/)
      if match
        note, minor, duration = match[1..3]
      end
      Abc::MusicalNote.new(note, chord: minor ? :minor : :major, duration: duration)
    end
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