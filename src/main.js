import { Renderer, Stave, StaveNote, Formatter, Annotation } from 'vexflow';

function initRenderer() {
  const renderer = new Renderer(document.getElementById('music'), Renderer.Backends.SVG);
  renderer.resize(400, 500);
  const context = renderer.getContext();

  const stave = new Stave(10, 60, 380);
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
  const g = document.createElementNS('http://www.w3.org/2000/svg', 'g');
  const rect = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
  rect.setAttribute('x', bbox.x + bbox.width/2 - 10); // center above text
  rect.setAttribute('y', bbox.y - 25); // above the text
  rect.setAttribute('width', '20');
  rect.setAttribute('height', '20');
  rect.setAttribute('fill', 'red');
  rect.setAttribute('stroke', 'black');
  rect.setAttribute('stroke-width', '2');
  g.appendChild(rect);
  const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
  text.setAttribute('x', bbox.x + bbox.width/2); // center in box
  text.setAttribute('y', bbox.y - 10); // vertically center in box
  text.setAttribute('text-anchor', 'middle');
  text.setAttribute('dominant-baseline', 'middle');
  text.setAttribute('font-size', '12px');
  text.textContent = chordName;
  g.appendChild(text);
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
const musicData = "f/5:8d:Am f/5:8d:Am e/5:4d:G e/5:4d:G e/5:4d:C e/5:4d:C e/5:4d:F";
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