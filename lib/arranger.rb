require_relative 'musical_note'
require_relative 'playing_instruction'
require_relative 'note_sequence'

class Arranger
  def initialize(grid)
    @grid = grid
    @inverse_grid = invert(grid)
  end
  
  def invert(grid)
    inverse = {}
    grid.each do |row, notes_in_each_direction|
      notes_in_each_direction.each do |direction, notes|
        notes.each_with_index do |note, i|
          inverse[note] ||= []
          inverse[note] << PlayingInstruction.new(row, direction, i + 1)
        end
      end
    end
    inverse
  end
  
  def arrange(melody_notes, accompaniment_notes = nil)
    current_beat = Rational(0)
    accompaniment = NoteSequence.new(accompaniment_notes)
    melody_notes.map do |note|
      possible_direction_constraint = accompaniment_direction(accompaniment, current_beat)
      current_beat += note.duration
      find_note_in_grid(note, possible_direction_constraint)
    end
  end
  
  def find_note_in_grid(note, direction = nil)
    return nil unless @inverse_grid[note]
    found = if direction
      @inverse_grid[note].find { |pi| pi.direction == direction }
    end
    found || @inverse_grid[note].first
  end
  
  def accompaniment_direction(accompaniment, beat)
    note = accompaniment.at(beat)
    if note
      playing_direction_of(note)
    end
  end
  
  def playing_direction_of(note)
    found = find_note_in_grid(note)
    found && found.direction
  end
  
  def self.two_row
    {
      c_row: c_row,
      g_row: g_row
    }
  end
  
  def self.c_row
    {
      push: notes(*%w{^g g-1 c e g c1 e1 g1 c2 e2}),
      pull: notes(*%w{^a b   d f a b  d1 f1 a1 b1})
    }
  end
  
  def self.g_row
    {
      push: notes(*%w{^c  d-1 g-1 b-1 d  g b d1 g1  b1 d2}),
      pull: notes(*%w{^d ^f-1 a-1 c   e ^f a c1 e1 ^f1 a1})
    }
  end
end