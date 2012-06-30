module DiatoArranger
  module Abc
    class KeySignature
      attr_reader :key
      attr_reader :mode

      def initialize(key, mode = 'major')
        @key = key
        @mode = mode.to_sym
      end

      def ==(other)
        self.key == other.key and self.mode == other.mode
      end

      def sharps
        keys_with_sharps = {
          major: %w{C G D A E B F# C#},
          minor: %w{A E B F# C# G# D#}
        }
        number_of_sharps = keys_with_sharps[@mode].find_index(@key) || 0
        order_of_sharps = %w{F C G D A E B}
        order_of_sharps[0...number_of_sharps]
      end

      def flats
        keys_with_flats = {
          major: %w{C F Bb Eb Ab Db Gb Cb},
          minor: %w{A D G C F Bb Eb}
        }
        number_of_flats = keys_with_flats[@mode].find_index(@key) || 0
        order_of_flats = %w{B E A D G C F}
        order_of_flats[0...number_of_flats]
      end

      def modifier_of_note(note)
        if sharps.include?(note.upcase)
          :sharp
        elsif flats.include?(note.upcase)
          :flat
        else
          nil
        end
      end
    end
  end
end