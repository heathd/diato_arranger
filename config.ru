require 'bundler/setup'
Bundler.require(:default)

$: << File.dirname(__FILE__)
require 'lib/diato_arranger/rack/app'

app = Rack::Builder.new {
  use Rack::CommonLogger
  use Rack::ShowExceptions
  map "/" do
    use Rack::Lint
    run DiatoArranger::Rack::App.new
  end
}

run app
