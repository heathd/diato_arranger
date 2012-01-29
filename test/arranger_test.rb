require_relative 'test_helper'
require_relative '../lib/arranger'

class ArrangerTest < MiniTest::Unit::TestCase
  include ParserTestHelper
  include MusicalNoteHelper
  include PlayingInstructionHelper

  context "simple grid" do
    setup do
      @arranger = Arranger.new(
        a: {
          push: notes(%w{c e}),
          pull: notes(%w{d})
        }
      )
    end
    
    should "arrange a melody" do
      melody = notes(%w{c d e})
      expected_arrangement = [push(:a, 1), pull(:a, 1), push(:a, 2)]
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
end

