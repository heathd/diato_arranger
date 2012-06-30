module DiatoArranger
  module MusicalNoteHelper
    def note(pitch, options = {})
      [Abc::MusicalNote.new(pitch, options)]
    end
  
    def notes(pitches)
      pitches.map.with_index do |p, i|
        match = p.match(/(\^?)(.)(-?[0-9])?/)
        if match
          accidental, p, octave = match[1..3]
        end
        Abc::MusicalNote.new(p, octave: octave, accidental: accidental == '^' ? :sharp : nil, beat_number: i)
      end
    end
  
    def accompaniment(pitches)
      pitches.map.with_index do |p, i|
        match = p.match(/([CDEFGAB])(m)?([0-9]+)?/)
        if match
          note, minor, duration = match[1..3]
        end
        Abc::MusicalNote.new(note.downcase, chord: minor ? :minor : :major, duration: duration, beat_number: i)
      end
    end
  end
end