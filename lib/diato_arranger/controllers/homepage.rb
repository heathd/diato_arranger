require 'diato_arranger/controllers/base'

module DiatoArranger
  module Controllers
    class Homepage < Base
      def handle(request)
        abc = ""
        success DiatoArranger::Page.new(binding)
      end
    end
  end
end
