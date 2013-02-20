require 'rack/request'
require "diato_arranger/arranger"
require "diato_arranger/html_output"
require "diato_arranger/abc/abc_parser"
require 'diato_arranger/tunes_repository'
require 'diato_arranger/controllers/create'
require 'diato_arranger/controllers/show_tune'
require 'diato_arranger/controllers/homepage'

module DiatoArranger
  class NotFound < RuntimeError; end
  
  App = Rack::Builder.new do
    use Rack::CommonLogger
    use Rack::ShowExceptions
    use Rack::Lint
    use Rack::Static, urls: ["/static"]
    map("/") { run DiatoArranger::Controllers::Homepage.new }
    map("/create") { run DiatoArranger::Controllers::Create.new }
    map("/tune/") { run DiatoArranger::Controllers::ShowTune.new }
  end
end
