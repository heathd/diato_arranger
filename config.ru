require 'bundler/setup'
Bundler.require(:default)

$: << File.expand_path("lib", File.dirname(__FILE__))
require 'diato_arranger/rack/app'

run DiatoArranger::App
