require_relative 'test_helper'

Treetop.load File.expand_path("../lib/movement", File.dirname(__FILE__))

class MovementParserTest < MiniTest::Unit::TestCase
  include ParserTestHelper
  
  def setup
    @parser = MovementParser.new
  end

  should "move one step" do
    new_position = stub("new_position")
    position = stub("position")
    position.expects(:moved_by).with([0,1]).returns(new_position)
    assert_equal new_position, @parser.parse("move north").perform(position)
  end
  
  should "move multiple steps" do
    position = stub("position")
    position.expects(:moved_by).with([0,-3])
    @parser.parse("move 3 south").perform(position)
  end

  should "perform two moves" do
    position = stub("position")
    intermediate_position = stub("intermediate position")
    position.expects(:moved_by).with([0,1]).returns(intermediate_position)
    intermediate_position.expects(:moved_by).with([1,0])
    @parser.parse("move north, move east").perform(position)
  end
  
  
end

