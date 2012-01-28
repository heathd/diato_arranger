require_relative 'test_helper'
require_relative '../lib/abc_parser'

class AbcParserTest < MiniTest::Unit::TestCase
  include ParserTestHelper
  
  def setup
    @parser = AbcParser.new
  end

  def fixture(name)
    path = File.expand_path("fixtures/#{name}", File.dirname(__FILE__))
    File.read(path)
  end
  
  def assert_parseable(input)
    result = @parser.parse(input)
    assert result, lambda { @parser.failure_reason }
    result
  end
  
  def parse_notation(notation_text)
    preamble = "X:1\nT:Sample\nK:C\n"
    input = preamble + notation_text + "\n"
    @parser.parse(input).notes
  end
  
  def note(pitch, options = {})
    [Abc::MusicalNote.new(pitch, options)]
  end
  
  def notes(*pitches)
    pitches.map {|p| Abc::MusicalNote.new(p) }
  end
  
  context "minimal example (headers only)" do
    setup do
      @input = fixture('minimal.abc')
    end
    
    should "parse" do
      result = @parser.parse(@input)
      unless result
        @parser.terminal_failures.each { |f| show_failure(f) }
      end
      assert result, "Parsed ok"
    end
  end
  
  context "parsing notes" do    
    should "parse C to note of pitch c ocatave 0" do
      assert_equal note('c', ocatave: 0), parse_notation('C')
    end

    should "parse C2 to note of pitch c ocatave 0, duration 2" do
      assert_equal note('c', {octave: 0, duration: 2}), parse_notation('C2')
    end
    
    should "parse fractional durations" do
      assert_equal note('c', {octave: 0, duration: Rational(1,2)}), parse_notation('C1/2')
      assert_equal note('c', {octave: 0, duration: Rational(1,1)}), parse_notation('C1')
      assert_equal note('c', {octave: 0, duration: Rational(1,3)}), parse_notation('C/3')
      assert_equal note('c', {octave: 0, duration: Rational(5,3)}), parse_notation('C5/3')
    end

    should "parse octave annotations" do
      assert_equal note('c', {octave: -1}), parse_notation('C,')
      assert_equal note('c', {octave: 1}), parse_notation("C'")
      assert_equal note('c', {octave: 3}), parse_notation("C'''")
      assert_equal note('c', {octave: -2}), parse_notation("C,,")
    end
    
    should "parse accidental annotations" do
      assert_equal note('c', {accidental: :sharp}), parse_notation('^C')
      assert_equal note('c', {accidental: :doublesharp}), parse_notation('^^C')
      assert_equal note('c', {accidental: :unaltered}), parse_notation('C')
      assert_equal note('c', {accidental: :natural}), parse_notation('=C')
      assert_equal note('c', {accidental: :flat}), parse_notation('_C')
      assert_equal note('c', {accidental: :doubleflat}), parse_notation('__C')
    end
    
    should "skip barlines" do
      assert_equal notes('c', 'd', 'e', 'f'), parse_notation("CD | EF")
    end
  end
  
  context "longer example (inc tune)" do
    setup do
      @input = fixture('sample.abc')
    end
    
    should "parse" do
      assert_parseable(@input)
    end
    
    should "show notes" do
      result = @parser.parse(@input)
      puts "\n"
      bars = result.notes.join.scan(/.{8}/)
      lines = bars.each_slice(4).map do |bars|
        bars.join " | "
      end
      puts lines
      puts "\n"
      
    end
  end
end

