import { Renderer, Stave, StaveNote, Formatter, Annotation } from 'vexflow';
import { AccordionChordChart } from './accordionChords';
import { AccordionLayout } from './accordionLayout';

function initRenderer() {
  const renderer = new Renderer(document.getElementById('music'), Renderer.Backends.SVG);
  renderer.resize(400, 500);
  const context = renderer.getContext();

  const stave = new Stave(20, 150, 380);
  stave.addClef("treble").addTimeSignature("4/4");
  stave.setContext(context).draw();

  return { renderer, context, stave };
}

// Parse music data into VexFlow notes and chord symbols
function parseMusic(musicData) {
  return musicData.split(" ").map(note => {
    const [key, duration, chord] = note.split(":");
    const staveNote = new StaveNote({ 
      keys: [key], 
      duration: duration 
    });
    
    // Add chord symbol if present
    if (chord) {
      const annotation = new Annotation(chord);
      annotation.setVerticalJustification(Annotation.VerticalJustify.TOP);
      annotation.setFont('Arial', 14, 'bold');
      annotation.setPosition(Annotation.Position.ABOVE);
      staveNote.addModifier(annotation, 0);
    }
    
    return staveNote;
  });
}

function renderChordDiagram(bbox, chordName) {
  const chart = new AccordionChordChart();
  const layout = new AccordionLayout();
  let chordLayout = layout.findChordPositions(chordName);

  const g = chart.drawChordChart(chordName, chordLayout.offset, chordLayout.buttonsPressed);
  g.setAttribute('transform', `translate(${bbox.x + bbox.width/2 - 40}, ${bbox.y - 100})`);
  return g;
}

function renderChordCharts() {
  const svg = document.getElementById('music').querySelector('svg');
  if (!svg) return;

  // Find all annotation elements
  const annotations = Array.from(svg.querySelectorAll('g.vf-annotation'));
  annotations.forEach(annotation => annotate(svg, annotation));
}

function annotate(svg, annotation) {
  const bbox = annotation.getBBox();
  const chordName = annotation.textContent;
  const rect = renderChordDiagram(bbox, chordName);
  svg.appendChild(rect);
}

// Render the music
async function renderMusic(musicData) {
  const { context, stave } = await initRenderer();
  const notes = parseMusic(musicData);
  Formatter.FormatAndDraw(context, stave, notes);
  setTimeout(renderChordCharts, 0);
}

// Initial render with chord symbols
const musicData = "f/5:8d:Am f/5:8d:Bb f/5:8d:Fm";
renderMusic(musicData);

// Hot Module Replacement (HMR) - Remove this in production
if (import.meta.hot) {
  import.meta.hot.accept((newModule) => {
    // Clear the SVG
    const musicDiv = document.getElementById('music');
    musicDiv.innerHTML = '';
    // Re-render
    renderMusic(musicData);
  });
} 