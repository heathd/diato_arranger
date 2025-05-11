// Accordion chord chart rendering module
export class AccordionChordChart {
  constructor(options = {}) {
    this.columns = 3;
    this.rows = 3;
    this.spacingFactor = 0.5;
    this.textHeight = 15;
    this.textPadding = this.textHeight*0.05;
    this.options = {
      width: 50,
      height: 50,
      ...options
    };
    this.buttonSize = this.calculateButtonSize();
    this.buttonSpacing = this.calculateButtonSpacing();
  }

  calculateButtonSize() {
    let widthFudgeFactor = 4.5 * (1.0+this.spacingFactor) / 3.0
    let sizeBasedOnBoxWidth = this.options.width / (this.columns * widthFudgeFactor)
    let sizeBasedOnBoxHeight = ( this.options.height -  this.textHeight - this.textPadding)  / (this.rows* (1.0+this.spacingFactor))
    return Math.min(sizeBasedOnBoxWidth, sizeBasedOnBoxHeight)
  }

  calculateButtonSpacing() {
    return this.buttonSize * this.spacingFactor;
  }

  drawButton(g, x, y, isPressed = false) {
    const button = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    button.setAttribute('cx', x);
    button.setAttribute('cy', y);
    button.setAttribute('r', this.buttonSize / 2);
    button.setAttribute('fill', isPressed ? '#4CAF50' : '#fff');
    button.setAttribute('stroke', '#000');
    button.setAttribute('stroke-width', '1');
    g.appendChild(button);
    return button;
  }

  drawChordChart(chordName, keyboardOffset, buttonsPressed = []) {
    const g = document.createElementNS('http://www.w3.org/2000/svg', 'g');

    // Draw button grid
    const startX = this.buttonSpacing;
    const startY = this.buttonSpacing;
    
    for (let row = 0; row < this.rows; row++) {
      for (let col = 0; col < this.columns; col++) {
        // Skip drawing button if it's a nil position (first note of row 1)
        if (row === 0 && (col + keyboardOffset) === 1) continue;
        
        const x = startX + this.textHeight *0.2 + col * (this.buttonSize + this.buttonSpacing) + row * this.buttonSize/2;
        // Flip the y position by calculating from the bottom
        const y = startY + (this.rows - 1 - row) * (this.buttonSize + this.buttonSpacing);
        
        // add the offset to the column number when searching for the button pressed
        const isPressed = buttonsPressed.some(button => 
          button.row === row && button.col === col + keyboardOffset
        );
        
        this.drawButton(g, x, y, isPressed);
      }
    }

    // render a small text label for the position
    const positionText = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    positionText.setAttribute('x', this.buttonSpacing);
    positionText.setAttribute('y', this.options.height*.4 - this.textHeight*0.8);
    positionText.setAttribute('text-anchor', 'middle');
    positionText.setAttribute('dominant-baseline', 'middle');
    positionText.setAttribute('font-size', this.textHeight*0.7);
    positionText.textContent = keyboardOffset;
    g.appendChild(positionText);

    // Add chord name
    const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    text.setAttribute('x', this.options.width / 2);
    text.setAttribute('y', this.options.height - this.textHeight/2);
    text.setAttribute('text-anchor', 'middle');
    text.setAttribute('dominant-baseline', 'middle');
    text.setAttribute('font-size', this.textHeight);
    text.textContent = chordName;
    g.appendChild(text);

    // render a box around the chord chart
    const box = document.createElementNS('http://www.w3.org/2000/svg', 'rect');
    box.setAttribute('x', 0);
    box.setAttribute('y', 0);
    box.setAttribute('width', this.options.width-1);
    box.setAttribute('height', this.options.height-1);
    box.setAttribute('fill', 'none');
    box.setAttribute('stroke', 'red');
    box.setAttribute('stroke-width', '1');
    g.appendChild(box);
    return g;
  }

  // Example chord patterns (to be expanded)
  static getChordPattern(chordName) {
    const patterns = {
      'Am': [0, 1, 2], // Example pattern for Am chord
      'G': [1, 2, 3],  // Example pattern for G chord
      'C': [2, 3, 4],  // Example pattern for C chord
      'F': [3, 4, 5]   // Example pattern for F chord
    };
    return patterns[chordName] || [];
  }
} 