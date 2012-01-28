module Abc
  module Cascade
    def notes
      elements ? elements.select {|e| e.respond_to?(:notes)}.map(&:notes).flatten : []
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
        
  class MusicalNote
    ATTRIBUTES = [:pitch, :duration, :octave, :accidental]
    attr_accessor *ATTRIBUTES
    
    def initialize(pitch, options = {})
      @pitch = pitch
      @duration = (options[:duration] || Rational(1)).to_r
      @octave = options[:octave] || 0
      @accidental = options[:accidental] || :unaltered
    end
    
    def multiply_duration(multiplication_factor)
      @duration = @duration * multiplication_factor
      self
    end
    
    def increment_octave
      @octave += 1
      self
    end

    def decrement_octave
      @octave -= 1
      self
    end
    
    def ==(other)
      ATTRIBUTES.all? do |attr|
        self.send(attr) == other.send(attr)
      end
    end
    
    def accidental_symbol
      case @accidental
      when :sharp then '#'
      when :flat then 'b'
      when :natural then '='
      when :unaltered then ''
      end
    end
    
    def to_s
      "#{@pitch}#{@octave}#{accidental_symbol}" + 
        "__" * (duration - 1)
    end
  end
end

Treetop.load File.expand_path("abc", File.dirname(__FILE__))
