module Abc
  class MusicalNote
    ATTRIBUTES = [:pitch, :duration, :octave, :accidental, :is_bass, :chord]
    attr_accessor *ATTRIBUTES
    attr_accessor :beat_number

    def initialize(pitch, options = {})
      @pitch = pitch.downcase
      @duration = (options[:duration] || Rational(1)).to_r
      @octave = (options[:octave] || 0).to_i
      @accidental = options[:accidental] || :unaltered
      @is_bass = options[:is_bass] || false
      @chord = options[:chord] || false
      @key_signature = options[:key_signature] || KeySignature.new("C", 'major')
      @beat_number = options[:beat_number]
    end

    def pitch_number
      i = %w{c c+ d d+ e f f+ g g+ a a+ b}.find_index(@pitch) || raise("No such pitch #{@pitch}")

      accidental = if @accidental == :unaltered
        @key_signature.modifier_of_note(@pitch)
      else
        @accidental
      end

      i += 1 if accidental == :sharp
      i -= 1 if accidental == :flat
      i += @octave * 12
      i
    end
    
    def sound_character
      [@is_bass, @chord, pitch_number]
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
    
    def inspect
      attrs = Hash[ATTRIBUTES.map do |attr|
        [attr, self.send(attr)]
      end]
      "<MusicalNote #{attrs}>"
    end
    
    def to_s(with_octave = true)
      s = if chord
        "#{pitch}#{chord_sym}"
      else
        with_octave ? "#{@pitch}#{@octave}#{accidental_symbol}" : "#{@pitch}#{accidental_symbol}"
      end
      s + "__" * (duration - 1)
    end
  end
end