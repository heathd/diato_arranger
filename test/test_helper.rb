require "rubygems"
require "bundler/setup"
Bundler.require(:default, :development, :test)
require 'minitest/unit'
require 'minitest/autorun'
require_relative '../lib/diato_arranger/musical_note_helper'

# require 'treetop'

class MiniTest::Unit::TestCase
  include Shoulda::Context::Assertions
  include Shoulda::Context::InstanceMethods
  extend Shoulda::Context::ClassMethods
end

module DiatoArranger
  module PlayingInstructionHelper
    def push(row, button)
      PlayableNote.new(row, :push, button)
    end
  
    def pull(row, button)
      PlayableNote.new(row, :pull, button)
    end
  end

  module ParserTestHelper
    def parse_to_result(notation_text)
      preamble = "X:1\nT:Sample\nK:C\n"
      input = preamble + notation_text + "\n"
      @parser.parse(input)
    end
  
    def parse_notation(notation_text)
      parse_to_result(notation_text).notes
    end
  
    def parse_accompaniment(notation_text)
      parse_to_result(notation_text).accompaniment(Rational(0,1))
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

  module FixtureHelper
    def fixture(name)
      path = File.expand_path("fixtures/#{name}", File.dirname(__FILE__))
      File.read(path)
    end
  end
end