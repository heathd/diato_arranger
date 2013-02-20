require 'diato_arranger/controllers/base'

module DiatoArranger
  module Controllers
    class ShowTune < Base
      def handle(request)
        match = %r{/([a-z0-9]+)}.match(request.path_info)
        hash = match && match[1]
        abc = tunes_repository.get(hash) || raise(NotFound)
        arranger = DiatoArranger::Arranger.new(DiatoArranger::Arranger.two_row)
        result = DiatoArranger::Abc::AbcParser.new.parse(abc)
        if result
          success DiatoArranger::HtmlOutput.new(arranger.arrange(result.notes, result.accompaniment(0)), abc)
        else
          errors = "Unable to parse tune"
          success DiatoArranger::Page.new(binding)
        end
      end

      def tunes_repository
        TunesRepository.new(File.expand_path("../../../tunes/", File.dirname(__FILE__)))
      end
    end
  end
end
