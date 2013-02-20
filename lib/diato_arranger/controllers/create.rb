require 'diato_arranger/controllers/base'

module DiatoArranger
  module Controllers
    class Create < Base
      def handle(request)
        puts "CREATE!!"
        created_hash = tunes_repository.create(request.params['abc'])
        redirect "/tune/#{created_hash}"
      end

      def tunes_repository
        TunesRepository.new(File.expand_path("../../../tunes/", File.dirname(__FILE__)))
      end
    end
  end
end
