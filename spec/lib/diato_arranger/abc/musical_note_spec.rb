require 'spec_helper'
require_relative '../../../../lib/diato_arranger/abc/key_signature'
require_relative '../../../../lib/diato_arranger/abc/musical_note'

module DiatoArranger
  module Abc
    RSpec.describe MusicalNote do
      include MusicalNoteHelper
      include FixtureHelper

      describe "note pitches" do
        it "has pitch number 0 for middle C" do
          expect(MusicalNote.new('C').pitch_number).to eq(0)
        end

        it "has correct pitches for other notes" do
          expect(MusicalNote.new('C').pitch_number).to eq(0)
          expect(MusicalNote.new('D').pitch_number).to eq(2)
          expect(MusicalNote.new('E').pitch_number).to eq(4)
          expect(MusicalNote.new('F').pitch_number).to eq(5)
          expect(MusicalNote.new('G').pitch_number).to eq(7)
          expect(MusicalNote.new('A').pitch_number).to eq(9)
          expect(MusicalNote.new('B').pitch_number).to eq(11)
          expect(MusicalNote.new('C', octave: 1).pitch_number).to eq(12)
          expect(MusicalNote.new('C', octave: -1).pitch_number).to eq(-12)
        end

        it "has the same pitch for E# and F" do
          expect(MusicalNote.new('E', accidental: :sharp).pitch_number).to eq(MusicalNote.new('F').pitch_number)
        end

        it "increments pitch number by 1 for sharpened note" do
          expect(MusicalNote.new('C', accidental: :sharp).pitch_number).to eq(MusicalNote.new('C').pitch_number + 1)
        end

        it "decrements pitch number by 1 for flattened note" do
          expect(MusicalNote.new('C', accidental: :flat).pitch_number).to eq(MusicalNote.new('C').pitch_number - 1)
        end
      end

      describe "finding pitches with key signature" do
        it "takes account of key signature when calculating pitch number" do
          f_sharp = MusicalNote.new('F', accidental: :sharp)
          g_major = KeySignature.new("G")
          f_in_g_major = MusicalNote.new('F', key_signature: g_major)
          expect(f_in_g_major.pitch_number).to eq(f_sharp.pitch_number)
        end
      end
    end
  end
end 