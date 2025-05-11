export class AccordionLayout {
  constructor() {
    this.layout = {
      "push": {
        "melody": {
          "row1": [null, "D", "G", "B", "D", "G", "B", "D", "G", "B", "D"],
          "row2": ["Bb", "A", "C", "E", "A", "C", "E", "A", "C", "E", "G"], 
          "row3": ["Gb", "Eb", "F", "Gb", "Eb", "F", "Gb", "Eb", "F", "Gb"]
        },
        "accomp": {
          "row1": ["Eb", "Eb*", "C", "C*", "G", "G*"],
          "row2": ["Ab", "Ab*", "F", "F*", "E", "E*"],
          "row3": ["Bb", "B", "D", "Gb", "Db", "A"]
        }
      },
      "pull": {
        "melody": {
          "row1": [null, "Gb", "A", "C", "E", "Gb", "A", "C", "E", "Gb", "A"],
          "row2": ["Ab", "B", "D", "F", "Ab", "B", "D", "F", "Ab", "B", "D"],
          "row3": ["Db", "Eb", "G", "Bb", "Db", "Eb", "G", "Bb", "Db", "C"]
        },
        "accomp": {
          "row1": ["Bb", "Bb*", "G", "G*", "D", "D*"],
          "row2": ["B", "B*", "F", "F*", "A", "A*"],
          "row3": ["Eb", "Ab", "C", "Gb", "Db", "E"]
        }
      }
    };

    // Build note lookup tables for quick access
    this.noteLookup = this.buildNoteLookup();
  }

  buildNoteLookup() {
    const lookup = {
      push: { melody: {}, accomp: {} },
      pull: { melody: {}, accomp: {} }
    };

    // Process each direction and keyboard
    ['push', 'pull'].forEach(direction => {
      ['melody', 'accomp'].forEach(keyboard => {
        const keyboardLayout = this.layout[direction][keyboard];
        
        // Process each row
        Object.entries(keyboardLayout).forEach(([row, notes]) => {
          notes.forEach((note, col) => {
            // Skip nil values
            if (note === null || note === undefined) return;
            
            // Store the position for each note
            if (!lookup[direction][keyboard][note]) {
              lookup[direction][keyboard][note] = [];
            }
            lookup[direction][keyboard][note].push({
              row: parseInt(row.replace('row', '')) - 1,
              col: col,
              exists: true
            });
          });
        });
      });
    });

    return lookup;
  }

  findChordPositions(chordName, direction = 'pull', keyboard = 'melody') {
    const normalizedChord = this.normalizeChord(chordName);
    if (!normalizedChord) return [];

    const { root, type } = normalizedChord;
    let positions = [];

    // Get the root note positions
    positions = this.noteLookup[direction][keyboard][root] || [];

    // select the root note position closest to the 0 column
    positions = positions.sort((a, b) => Math.abs(a.col - 0) - Math.abs(b.col - 0));
    positions = positions[0];

    // find the chord notes for this root position
    positions = this.findChordNotes(positions, type, direction, keyboard);

    // calculate the offset as the minimum column number of the chord notes
    const offset = Math.min(...positions.map(pos => pos.col));

    return {
      direction: direction,
      offset: offset, 
      buttonsPressed: positions
    }
  }

  normalizeChord(chordName) {
    // Basic chord name parsing
    const match = chordName.match(/^([A-G][b#]?)(m|7|m7|dim|aug)?$/);
    if (!match) return null;

    return {
      root: match[1],
      type: match[2] || 'major'
    };
  }

  // Convert a note name to its chromatic pitch value (number of semitones from C)
  chromaticPitch(note) {
    if (!note) return 0;

    // Remove any octave number if present
    note = note.replace(/\d+$/, '');

    // Define the base pitch for each note (C = 0, C# = 1, D = 2, etc.)
    const basePitches = {
      'C': 0, 'C#': 1, 'Db': 1,
      'D': 2, 'D#': 3, 'Eb': 3,
      'E': 4,
      'F': 5, 'F#': 6, 'Gb': 6,
      'G': 7, 'G#': 8, 'Ab': 8,
      'A': 9, 'A#': 10, 'Bb': 10,
      'B': 11
    };

    return basePitches[note] || 0;
  }

  findChordNotes(rootPos, chordType, direction, keyboard) {
    const notes = [rootPos];
    const keyboardLayout = this.layout[direction][keyboard];
    
    // Define intervals for different chord types (in semitones)
    const intervals = {
      'major': [4, 7],  // Major third, perfect fifth
      'm': [3, 7],      // Minor third, perfect fifth
      '7': [4, 7, 10],  // Major third, perfect fifth, minor seventh
      'm7': [3, 7, 10], // Minor third, perfect fifth, minor seventh
      'dim': [3, 6],    // Minor third, diminished fifth
      'aug': [4, 8]     // Major third, augmented fifth
    };

    // Get the root note from the position
    const rootNote = keyboardLayout[`row${rootPos.row + 1}`][rootPos.col];
    if (!rootNote) return notes;

    // Get the intervals for this chord type
    const chordIntervals = intervals[chordType] || intervals['major'];
    
    // Find all notes in the layout
    const allNotes = [];
    Object.entries(keyboardLayout).forEach(([row, rowNotes]) => {
      rowNotes.forEach((note, col) => {
        if (note && !note.includes('*')) {  // Skip nil and bass notes
          allNotes.push({
            note,
            row: parseInt(row.replace('row', '')) - 1,
            col
          });
        }
      });
    });

    // For each interval, find the closest note that matches
    chordIntervals.forEach(interval => {
      let bestMatch = null;
      let minDistance = Infinity;

      // filter allnotes to only include notes which match this interval relative to the root note

      const desiredPitch = (this.chromaticPitch(rootNote) + interval) % 12;
      const filteredNotes = allNotes.filter(notePos => {
        return this.chromaticPitch(notePos.note) === desiredPitch;
      });

      filteredNotes.forEach(notePos => {
        // Skip the root note
        if (notePos.row === rootPos.row && notePos.col === rootPos.col) return;

        // Calculate the distance from the root position
        const rowDiff = Math.abs(notePos.row - rootPos.row);
        const colDiff = Math.abs(notePos.col - rootPos.col);
        const distance = rowDiff + colDiff;

        // If this note is closer than our current best match, update it
        if (distance < minDistance) {
          bestMatch = notePos;
          minDistance = distance;
        }
      });

      if (bestMatch) {
        notes.push(bestMatch);
      }
    });

    return notes;
  }

  getAvailableChords() {
    // Return all possible chords based on the layout
    const chords = new Set();
    
    ['push', 'pull'].forEach(direction => {
      ['melody', 'accomp'].forEach(keyboard => {
        const keyboardLayout = this.layout[direction][keyboard];
        Object.values(keyboardLayout).forEach(row => {
          row.forEach(note => {
            // Skip nil values and bass notes
            if (note === null || note === undefined || note.includes('*')) return;
            
            chords.add(note);         // Add major chord
            chords.add(note + 'm');   // Add minor chord
            chords.add(note + '7');   // Add seventh chord
          });
        });
      });
    });

    return Array.from(chords).sort();
  }

} 