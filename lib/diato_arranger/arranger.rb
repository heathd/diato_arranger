require_relative 'abc/musical_note'
require_relative 'abc/key_signature'
require_relative 'playing_instruction'
require_relative 'note_sequence'
require_relative 'musical_note_helper'
require 'pp'

module DiatoArranger
  class Arranger
    extend ::DiatoArranger::MusicalNoteHelper
  
    def initialize(grid)
      @grid = grid

      # The inverse grid maps a note's sound character to a list of possible playing instructions.
      # The sound character is the pitch (including octave) plus whether it's a base/accompaniment note.
      # The playing instruction says which button to push and in which direction the bellows move.
      @inverse_grid = invert(grid)
    end
  
    def invert(grid)
      inverse = {}
      grid.each do |row, notes_in_each_direction|
        notes_in_each_direction.each do |direction, notes|
          notes.each_with_index do |note, i|
            inverse[note.sound_character] ||= []
            inverse[note.sound_character] << PlayableNote.new(row, direction, i + 1, note)
          end
        end
      end
      inverse
    end
  
    def arrange(melody_notes, accompaniment_notes = nil)
      current_beat = Rational(0)
      accompaniment = NoteSequence.new(accompaniment_notes)
      all_possible_ways_of_playing = []
      
      melody_notes.each do |note|
        all_possible_ways_of_playing << possible_ways_to_play(accompaniment.at(current_beat), note)
        current_beat += note.duration
      end
      
      optimal_playing(all_possible_ways_of_playing)
    end
    
    def possible_ways_to_play(accompaniment_note, melody_note)
      accompaniment = accompaniment_note && @inverse_grid[accompaniment_note.sound_character] || []
      melody = @inverse_grid[melody_note.sound_character]
      
      [:push, :pull].map do |direction|
        melody.select {|pi| direction == pi.direction }.map do |melody_pi|
          accompaniment_pis = accompaniment.select {|pi| direction == pi.direction }
          (accompaniment_pis.any? ? accompaniment_pis : [nil]).map do |accompaniment_pi|
            melody_pi
              .with_accompaniment(accompaniment_pi)
              .with_duration(melody_note.duration)
          end
        end
      end.flatten
    end
    
    def optimal_playing(all_possible_ways_of_playing)
      previous_instruction = nil
      all_possible_ways_of_playing.map do |ways| 
        instruction = ways.sort_by { |way| score(way, previous_instruction) }.last
        previous_instruction = instruction
      end
    end
  
    def score(playing_instruction, previous_instruction)
      score = playing_instruction.accompaniment.nil? ? 0 : 10
      if previous_instruction && playing_instruction.direction == previous_instruction.direction
        score += 5
      end
      score
    end
    def self.two_row
      {
        c_row: c_row,
        g_row: g_row,
        accompaniment1: accompaniment1,
        accompaniment2: accompaniment2,
      }
    end
  
    def self.c_row
      {
        push: notes(%w{^g g-1 c e g c1 e1 g1 c2 e2}),
        pull: notes(%w{^a b   d f a b  d1 f1 a1 b1})
      }
    end
  
    def self.g_row
      {
        push: notes(%w{^c  d-1 g-1 b-1 d  g b d1 g1  b1 d2}),
        pull: notes(%w{^d ^f-1 a-1 c   e ^f a c1 e1 ^f1 a1})
      }
    end
  
    def self.accompaniment1
      {
        push: accompaniment(%w{F Em}),
        pull: accompaniment(%w{F Am})
      }
    end

    def self.accompaniment2
      {
        push: accompaniment(%w{C G}),
        pull: accompaniment(%w{G D})
      }
    end
  end
end