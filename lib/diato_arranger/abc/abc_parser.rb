require 'treetop'
require_relative 'musical_note'
require_relative 'key_signature'

module DiatoArranger
  module Abc
    module Cascade
      def notes
        elements ? elements.select {|e| e.respond_to?(:notes)}.map(&:notes).flatten : []
      end

      def accompaniment(current_beat)
        if elements
          result = elements.inject([current_beat, []]) do |memo, e|
            cb, acmp = memo
            acmp += e.accompaniment(cb) if e.respond_to?(:accompaniment)
            cb += e.notes.map(&:duration).inject(0, &:+) if e.respond_to?(:notes)
            [cb, acmp]
          end
          result[1]
        end
      end
    end
  
    module NoteLength
      def modify(note)
        if elements.any?
          n = numerator.text_value.empty? ? 1 : numerator.text_value.to_i rescue 1
          d = denominator.denominator_value.text_value.to_i rescue 1
          note.multiply_duration(Rational(n, d))
        end
        note
      end
    end

    module Accidental
      def modify(note)
        accidental = case text_value
        when "^" then :sharp
        when "^^" then :doublesharp
        when "=" then :natural
        when "_" then :flat
        when "__" then :doubleflat
        end
        note.accidental = accidental
        note
      end
    end
  end

  Treetop.load File.expand_path("abc", File.dirname(__FILE__))
end