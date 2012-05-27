require_relative 'test_helper'
require_relative '../lib/abc_parser'

class AbcParserTest < MiniTest::Unit::TestCase
  include ParserTestHelper
  include MusicalNoteHelper
  include FixtureHelper
  
  def setup
    @parser = AbcParser.new
  end

  context "minimal example (headers only)" do
    setup do
      @input = fixture('minimal.abc')
    end
    
    should "parse" do
      assert_parsable @input
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
      assert_equal notes(%w{c d e f}), parse_notation("CD | EF")
    end
    
    should "parse melody containing chord indications" do
      # assert_equal notes(%w{c0}), parse_notation('"Cm"C')
      assert_equal accompaniment(%w{D}), parse_accompaniment('"D"C')
    end

    should "accompaniment has beat number determined by attachment to notes" do
      assert_equal accompaniment(%w{Cm D}), parse_accompaniment('"Cm"C D2 "D"E')
      assert_equal [Rational(0, 1), Rational(3,1)], parse_accompaniment('"Cm"C D2 "D"E').map(&:beat_number)
    end
    
    should "pay attention to musical key" do
      key = "G"
      notes = "CDEFGAB"
      result = @parser.parse("X:1\nT:Minimal\nK:#{key}\n#{notes}\n")
      assert_equal ::Abc::KeySignature.new("G"), result.key_signature
      # assert_equal note('c', accidental: :natural), result.notes[0]
      # assert_equal note('d', accidental: :natural), result.notes[1]
      # assert_equal note('e', accidental: :natural), result.notes[2]
      # assert_equal note('f', accidental: :sharp), result.notes[3]
      # assert_equal note('g', accidental: :natural), result.notes[4]
      # assert_equal note('a', accidental: :natural), result.notes[5]
      # assert_equal note('b', accidental: :natural), result.notes[6]
    end
  end

  context "longer example (inc tune)" do
    setup do
      @input = fixture('sample.abc')
    end
    
    should "parse" do
      assert_parsable @input
    end
    
    should_eventually "show notes" do
      show_notes(@parser.parse(@input))
    end
  end
end

