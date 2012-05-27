require_relative 'test_helper'
require_relative '../lib/key_signature'
require_relative '../lib/musical_note'

module Abc
  class MusicalNoteTest < MiniTest::Unit::TestCase
    include MusicalNoteHelper
    include FixtureHelper

    context "note pitches" do
      should "have pitch number 0 for middle C" do
        assert_equal 0, MusicalNote.new('C').pitch_number
      end

      should "have correct pitches for other notes" do
        assert_equal 0, MusicalNote.new('C').pitch_number
        assert_equal 2, MusicalNote.new('D').pitch_number
        assert_equal 4, MusicalNote.new('E').pitch_number
        assert_equal 5, MusicalNote.new('F').pitch_number
        assert_equal 7, MusicalNote.new('G').pitch_number
        assert_equal 9, MusicalNote.new('A').pitch_number
        assert_equal 11, MusicalNote.new('B').pitch_number
        assert_equal 12, MusicalNote.new('C', octave: 1).pitch_number
        assert_equal -12, MusicalNote.new('C', octave: -1).pitch_number
      end

      should "have the same pitch for E# and F" do
        assert_equal MusicalNote.new('E', accidental: :sharp).pitch_number, MusicalNote.new('F').pitch_number
      end

      should "increment pitch number by 1 for sharpend note" do
        assert_equal MusicalNote.new('C').pitch_number + 1, MusicalNote.new('C', accidental: :sharp).pitch_number
      end

      should "decrement pitch number by 1 for sharpend note" do
        assert_equal MusicalNote.new('C').pitch_number - 1, MusicalNote.new('C', accidental: :flat).pitch_number
      end
    end

    context "finding pitches with key signature" do
      should "take account of key signature when calculating pitch number" do
        f_sharp = MusicalNote.new('F', accidental: :sharp)
        g_major = KeySignature.new("G")
        f_in_g_major = MusicalNote.new('F', key_signature: g_major)
        assert_equal f_sharp.pitch_number, f_in_g_major.pitch_number
      end
    end

  end
end