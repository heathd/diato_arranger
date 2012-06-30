require_relative "../arranger"
require_relative "../html_output"
require_relative "../abc/abc_parser"

module DiatoArranger
  module Rack
    class App
      def filename
        File.dirname(__FILE__) + "/../../../test/fixtures/nue_pnues.abc"
      end
      
      def call(env)
        arranger = DiatoArranger::Arranger.new(DiatoArranger::Arranger.two_row)
        result = DiatoArranger::Abc::AbcParser.new.parse(File.read(filename))
        output =  DiatoArranger::HtmlOutput.new(arranger.arrange(result.notes, result.accompaniment(0)))
        # output = ""

        [200, {"Content-Type" => "text/html"}, [output.to_s]]
      end
    end
  end
end
