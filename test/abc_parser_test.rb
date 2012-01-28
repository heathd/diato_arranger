require_relative 'test_helper'

Treetop.load File.expand_path("../lib/abc", File.dirname(__FILE__))

class AbcParserTest < MiniTest::Unit::TestCase
  include ParserTestHelper
  
  def setup
    @parser = AbcParser.new
  end

  def fixture(name)
    path = File.expand_path("fixtures/#{name}", File.dirname(__FILE__))
    File.read(path)
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
  
  context "longer example (inc tune)" do
    setup do
      @input = fixture('sample.abc')
    end
    
    should "parse" do
      result = @parser.parse(@input)
      unless result
        @parser.terminal_failures.each { |f| show_failure(f) }
      end
      assert result, "Parsed ok"
    end
  end
end

