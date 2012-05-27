require_relative 'test_helper'
require_relative '../lib/key_signature'
require_relative '../lib/musical_note'

class KeySignatureTest < MiniTest::Unit::TestCase
  include MusicalNoteHelper
  include FixtureHelper

  def assert_key_signature_has_sharps(expected_sharps, key_signature, message=nil)
    k = ::Abc::KeySignature.new(key_signature)
    assert_equal expected_sharps, k.sharps, "Key of #{key_signature} should have #{expected_sharps} sharps, but had #{k.sharps}"
    assert_equal [], k.flats, "Key of #{key_signature} should have no flats, but had #{k.flats}"
  end

  def assert_key_signature_has_flats(expected_flats, key_signature, message=nil)
    k = ::Abc::KeySignature.new(key_signature)
    assert_equal expected_flats, k.flats, "Key of #{key_signature} should have #{expected_flats} flats, but had #{k.flats}"
    assert_equal [], k.sharps, "Key of #{key_signature} should have no sharps, but had #{k.sharps}"
  end


  context "major keys" do
    should "have no modifications in C major" do
      key_signature = ::Abc::KeySignature.new('C')
      assert_equal [], key_signature.sharps
      assert_equal [], key_signature.flats
    end

    should "follow the standard pattern of sharps" do
      assert_key_signature_has_sharps(%w{}, 'C')
      assert_key_signature_has_sharps(%w{F}, 'G')
      assert_key_signature_has_sharps(%w{F C}, 'D')
      assert_key_signature_has_sharps(%w{F C G}, 'A')
      assert_key_signature_has_sharps(%w{F C G D}, 'E')
      assert_key_signature_has_sharps(%w{F C G D A}, 'B')
      assert_key_signature_has_sharps(%w{F C G D A E}, 'F#')
      assert_key_signature_has_sharps(%w{F C G D A E B}, 'C#')
    end

    should "follow the standard pattern of flats" do
      assert_key_signature_has_flats(%w{}, 'C')
      assert_key_signature_has_flats(%w{B}, 'F')
      assert_key_signature_has_flats(%w{B E}, 'Bb')
      assert_key_signature_has_flats(%w{B E A}, 'Eb')
      assert_key_signature_has_flats(%w{B E A D}, 'Ab')
      assert_key_signature_has_flats(%w{B E A D G}, 'Db')
      assert_key_signature_has_flats(%w{B E A D G C}, 'Gb')
      assert_key_signature_has_flats(%w{B E A D G C F}, 'Cb')
    end
  end

  context "minor keys" do
    should "have no modifications in A minor" do
      key_signature = ::Abc::KeySignature.new('A', 'minor')
      assert_equal [], key_signature.sharps
      assert_equal [], key_signature.flats
    end

    should "have six sharps in D# minor" do
      key_signature = ::Abc::KeySignature.new('D#', 'minor')
      assert_equal %w{F C G D A E}, key_signature.sharps
      assert_equal [], key_signature.flats
    end
  end

end
