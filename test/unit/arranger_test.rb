require_relative '../test_helper'
require_relative '../../lib/diato_arranger/arranger'
require_relative '../../lib/diato_arranger/html_output'
require_relative '../../lib/diato_arranger/abc/abc_parser'

module DiatoArranger
  class ArrangerTest < MiniTest::Unit::TestCase
    include ParserTestHelper
    include ::DiatoArranger::MusicalNoteHelper
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
  
    context "#possible_ways_to_play" do
      should "list possible ways to play in unambiguous grid" do
        arranger = Arranger.new(
          melody_row: {
            push: notes(%w{c}),
            pull: notes(%w{d})
          },
          accompaniment: {
            push: accompaniment(%w{C}),
            pull: accompaniment(%w{D})
          }
        )
        ways = arranger.possible_ways_to_play(accompaniment_note("C"), one_note("c", duration: 1))
        assert_equal 1, ways.size
        assert_equal 1, ways[0].duration
        assert_equal :melody_row, ways[0].row
        assert_equal 1, ways[0].accompaniment.button_number
        assert_equal :accompaniment, ways[0].accompaniment.row
        assert_equal 1, ways[0].accompaniment.button_number
      end
      
      should "list all possible ways to play in an ambiguous grid" do
        arranger = Arranger.new(
          melody_row: {
            push: notes(%w{c}),
            pull: notes(%w{c d})
          },
          accompaniment: {
            push: accompaniment(%w{C}),
            pull: accompaniment(%w{C D})
          }
        )
        ways = arranger.possible_ways_to_play(accompaniment_note("C"), one_note("c", duration: 1))
        assert_equal 2, ways.size
        assert_equal 1, ways[0].duration
        assert_equal 1, ways[1].duration

        assert_equal :melody_row, ways[0].row
        assert_equal :push, ways[0].direction
        assert_equal 1, ways[0].button_number
        assert_equal :accompaniment, ways[0].accompaniment.row
        assert_equal :push, ways[0].accompaniment.direction
        assert_equal 1, ways[0].accompaniment.button_number

        assert_equal :melody_row, ways[1].row
        assert_equal :pull, ways[1].direction
        assert_equal 1, ways[1].button_number
        assert_equal :accompaniment, ways[1].accompaniment.row
        assert_equal :pull, ways[1].accompaniment.direction
        assert_equal 1, ways[1].accompaniment.button_number
      end
      
      should "list playing the melody note without accompaniment as an option if it's impossible to play them together" do
        arranger = Arranger.new(
          melody_row: {
            push: notes(%w{c})
          },
          accompaniment: {
            pull: accompaniment(%w{C})
          }
        )
        ways = arranger.possible_ways_to_play(accompaniment_note("C"), one_note("c", duration: 1))
        assert_equal 1, ways.size
        assert_equal :melody_row, ways[0].row
        assert_equal :push, ways[0].direction
        assert_equal 1, ways[0].button_number
        assert_equal nil, ways[0].accompaniment        
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
            push: accompaniment(%w{C E}),
            pull: accompaniment(%w{D E})
          }
        )
      end
    
      should "disambiguate options using accompaniment" do
        # In this grid, there are two ways of playing 'c', but only one 
        # way of playing the D accompaniment (on the pull)
        melody = notes(%w{c})
        accompaniment = accompaniment(%w{D})
        assert_equal [pull(:row, 1)], @arranger.arrange(melody, accompaniment)
      end
    
      should "still play a note if it doesn't match the accompaniment direction" do
        melody = notes(%w{d})
        accompaniment = accompaniment(%w{D})
        assert_equal [push(:row, 2)], @arranger.arrange(melody, accompaniment)
      end
      
      should "prefer to play a subsequent note in the same direction as the previous note" do
        melody = notes(%w{d c})
        accompaniment = accompaniment(%w{E E})
        assert_equal [push(:row, 2), push(:row, 1)], @arranger.arrange(melody, accompaniment)
      end
    end
  
    context "nue pnues" do
      should_eventually "arrange it" do
        @arranger = Arranger.new(Arranger.two_row)
        file = fixture('nue_pnues.abc')
        result = AbcParser.new.parse(file)
        # HtmlOutput.new(@arranger.arrange(result.notes, result.accompaniment(0)))
      end
    end
  end
end
