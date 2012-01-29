require_relative 'test_helper'
require_relative '../lib/arranger'
require_relative '../lib/abc_parser'

class ArrangerTest < MiniTest::Unit::TestCase
  include ParserTestHelper
  include MusicalNoteHelper
  include PlayingInstructionHelper
  include FixtureHelper
  
  context "simple grid" do
    setup do
      @arranger = Arranger.new(
        a: {
          push: notes(%w{c e}),
          pull: notes(%w{d ^f})
        }
      )
    end
    
    should "arrange a melody" do
      melody = notes(%w{c d e})
      expected_arrangement = [push(:a, 1), pull(:a, 1), push(:a, 2)]
      assert_equal expected_arrangement, @arranger.arrange(melody)
    end
    
    should "ignore durations" do
      melody = notes(%w{c})
      melody.first.duration = 2
      expected_arrangement = [push(:a, 1)]
      assert_equal expected_arrangement, @arranger.arrange(melody)
    end
    
    should "match notes with accidentals" do
      melody = notes(%w{^f})
      expected_arrangement = [pull(:a, 2)]
      assert_equal expected_arrangement, @arranger.arrange(melody)
    end
    
  end
  
  context "ambiguous grid" do
    setup do
      @arranger = Arranger.new(
        row: {
          push: notes(%w{c d}),
          pull: notes(%w{c})
        },
        accompaniment: {
          push: accompaniment(%w{C}),
          pull: accompaniment(%w{D})
        }
      )
    end
    
    should "pick one option" do
      melody = notes(%w{c})
      assert_equal [push(:row, 1)], @arranger.arrange(melody)
    end
    
    should "disambiguate options using accompaniment" do
      melody = notes(%w{c})
      accompaniment = accompaniment(%w{D})
      assert_equal [pull(:row, 1)], @arranger.arrange(melody, accompaniment)
    end
    
    should "still play a note if it doesn't match the accompaniment direction" do
      melody = notes(%w{d})
      accompaniment = accompaniment(%w{D})
      assert_equal [push(:row, 2)], @arranger.arrange(melody, accompaniment)
    end
  end
  
  class HtmlOutput
    def initialize(arrangement)
      @arrangement = arrangement
    end
    
    def to_s
      @arrangement.map do |playing_instruction|
        case playing_instruction
        when PlayableNote then
          "<div class='#{playing_instruction.direction} #{playing_instruction.row}'>#{playing_instruction.button_number}<span>#{playing_instruction.note.to_s(false)}</span></div>\n"
        when UnplayableNote then
          "<div class='unplayable'>?<span>#{playing_instruction.note}</span></div>\n"
        end
      end.join
    end
  end
  
  context "nue pnues" do
    should "arrange it" do
      @arranger = Arranger.new(Arranger.two_row)
      file = fixture('nue_pnues.abc')
      result = AbcParser.new.parse(file)
      puts HtmlOutput.new(@arranger.arrange(result.notes, result.accompaniment(0)))
    end
  end
end

