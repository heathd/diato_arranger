require 'spec_helper'
require_relative '../../../../lib/diato_arranger/abc/key_signature'
require_relative '../../../../lib/diato_arranger/abc/musical_note'

module DiatoArranger
  module Abc
    RSpec.describe KeySignature do
      include MusicalNoteHelper
      include FixtureHelper

      def expect_key_signature_has_sharps(expected_sharps, key_signature)
        k = described_class.new(key_signature)
        expect(k.sharps).to eq(expected_sharps), 
          "Key of #{key_signature} should have #{expected_sharps} sharps, but had #{k.sharps}"
        expect(k.flats).to eq([]),
          "Key of #{key_signature} should have no flats, but had #{k.flats}"
      end

      def expect_key_signature_has_flats(expected_flats, key_signature)
        k = described_class.new(key_signature)
        expect(k.flats).to eq(expected_flats),
          "Key of #{key_signature} should have #{expected_flats} flats, but had #{k.flats}"
        expect(k.sharps).to eq([]),
          "Key of #{key_signature} should have no sharps, but had #{k.sharps}"
      end

      describe "major keys" do
        it "has no modifications in C major" do
          key_signature = described_class.new('C')
          expect(key_signature.sharps).to be_empty
          expect(key_signature.flats).to be_empty
        end

        it "follows the standard pattern of sharps" do
          expect_key_signature_has_sharps(%w{}, 'C')
          expect_key_signature_has_sharps(%w{F}, 'G')
          expect_key_signature_has_sharps(%w{F C}, 'D')
          expect_key_signature_has_sharps(%w{F C G}, 'A')
          expect_key_signature_has_sharps(%w{F C G D}, 'E')
          expect_key_signature_has_sharps(%w{F C G D A}, 'B')
          expect_key_signature_has_sharps(%w{F C G D A E}, 'F#')
          expect_key_signature_has_sharps(%w{F C G D A E B}, 'C#')
        end

        it "follows the standard pattern of flats" do
          expect_key_signature_has_flats(%w{}, 'C')
          expect_key_signature_has_flats(%w{B}, 'F')
          expect_key_signature_has_flats(%w{B E}, 'Bb')
          expect_key_signature_has_flats(%w{B E A}, 'Eb')
          expect_key_signature_has_flats(%w{B E A D}, 'Ab')
          expect_key_signature_has_flats(%w{B E A D G}, 'Db')
          expect_key_signature_has_flats(%w{B E A D G C}, 'Gb')
          expect_key_signature_has_flats(%w{B E A D G C F}, 'Cb')
        end
      end

      describe "minor keys" do
        it "has no modifications in A minor" do
          key_signature = described_class.new('A', 'minor')
          expect(key_signature.sharps).to be_empty
          expect(key_signature.flats).to be_empty
        end

        it "has six sharps in D# minor" do
          key_signature = described_class.new('D#', 'minor')
          expect(key_signature.sharps).to eq(%w{F C G D A E})
          expect(key_signature.flats).to be_empty
        end
      end
    end
  end
end 