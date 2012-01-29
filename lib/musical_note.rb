module Abc
  class MusicalNote
    ATTRIBUTES = [:pitch, :duration, :octave, :accidental, :is_bass, :chord]
    attr_accessor *ATTRIBUTES

    def initialize(pitch, options = {})
      @pitch = pitch
      @duration = (options[:duration] || Rational(1)).to_r
      @octave = options[:octave] || 0
      @accidental = options[:accidental] || :unaltered
      @is_bass = options[:is_bass] || false
      @chord = options[:chord] || false
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

    def eql?(other)
      self.class == other.class &&
        ATTRIBUTES.all? do |attr|
          self.send(attr) == other.send(attr)
        end
    end
    
    alias == eql?
    
    def hash
      ATTRIBUTES.map do |attr|
        [attr, self.send(attr)]
      end.hash
    end

    def accidental_symbol
      case @accidental
      when :sharp then '#'
      when :flat then 'b'
      when :natural then '='
      when :unaltered then ''
      end
    end

    def chord_sym
      @chord == :minor ? "m" : " "
    end
    
    def to_s
      s = if chord
        "#{pitch}#{chord_sym}"
      else
        "#{@pitch}#{@octave}#{accidental_symbol}"
      end
      s + "__" * (duration - 1)
    end
  end
end