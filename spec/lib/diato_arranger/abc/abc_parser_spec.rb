require 'spec_helper'
require_relative '../../../../lib/diato_arranger/abc/abc_parser'

module DiatoArranger
  module Abc
    RSpec.describe AbcParser do
      include ParserTestHelper
      include MusicalNoteHelper
      include FixtureHelper

      let(:parser) { AbcParser.new }
      before { @parser = parser }  # For compatibility with helper methods

      describe "minimal example (headers only)" do
        let(:input) { fixture('minimal.abc') }

        it "parses" do
          expect_parsable(input)
        end
      end

      describe "parsing notes" do
        it "parses C to note of pitch c octave 0" do
          expect(parse_notation('C')).to eq(note('c', octave: 0))
        end

        it "parses C2 to note of pitch c octave 0, duration 2" do
          expect(parse_notation('C2')).to eq(note('c', octave: 0, duration: 2))
        end

        it "parses fractional durations" do
          expect(parse_notation('C1/2')).to eq(note('c', octave: 0, duration: Rational(1,2)))
          expect(parse_notation('C1')).to eq(note('c', octave: 0, duration: Rational(1,1)))
          expect(parse_notation('C/3')).to eq(note('c', octave: 0, duration: Rational(1,3)))
          expect(parse_notation('C5/3')).to eq(note('c', octave: 0, duration: Rational(5,3)))
        end

        it "parses octave annotations" do
          expect(parse_notation('C,')).to eq(note('c', octave: -1))
          expect(parse_notation("C'")).to eq(note('c', octave: 1))
          expect(parse_notation("C'''")).to eq(note('c', octave: 3))
          expect(parse_notation("C,,")).to eq(note('c', octave: -2))
        end

        it "parses accidental annotations" do
          expect(parse_notation('^C')).to eq(note('c', accidental: :sharp))
          expect(parse_notation('^^C')).to eq(note('c', accidental: :doublesharp))
          expect(parse_notation('C')).to eq(note('c', accidental: :unaltered))
          expect(parse_notation('=C')).to eq(note('c', accidental: :natural))
          expect(parse_notation('_C')).to eq(note('c', accidental: :flat))
          expect(parse_notation('__C')).to eq(note('c', accidental: :doubleflat))
        end

        it "skips barlines" do
          expect(parse_notation("CD | EF")).to eq(notes(%w{c d e f}))
        end

        it "parses melody containing chord indications" do
          expect(parse_accompaniment('"D"C')).to eq(accompaniment(%w{D}))
        end

        it "accompaniment has beat number determined by attachment to notes" do
          result = parse_accompaniment('"Cm"C D2 "D"E')
          expect(result).to eq(accompaniment(%w{Cm D}))
          expect(result.map(&:beat_number)).to eq([Rational(0, 1), Rational(3,1)])
        end

        it "pays attention to musical key" do
          key = "G"
          notes = "CDEFGAB"
          result = parser.parse("X:1\nT:Minimal\nK:#{key}\n#{notes}\n")
          expect(result.key_signature).to eq(::DiatoArranger::Abc::KeySignature.new("G"))
        end
      end

      describe "longer example (inc tune)" do
        let(:input) { fixture('sample.abc') }

        it "parses" do
          expect_parsable(input)
        end

        xit "shows notes" do
          show_notes(parser.parse(input))
        end
      end
    end
  end
end 