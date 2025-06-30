import { getColorStyle } from "./color.js";

export class ColorGrid {
    constructor(gridElement, colors) {
        this.gridElement = gridElement;
        this.colors = colors;
        this.size = colors.length;
        this.selectedColor = null;
        this.cells = [];

        this.gridElement.innerHTML = '';
        for (let i = 0; i < this.size; i++) {
            const cell = document.createElement('div');
            cell.className = 'color-cell';
            cell.style.backgroundColor = getColorStyle(this.colors[i]);
            cell.addEventListener('click', () => this.selectColor(i));

            this.gridElement.appendChild(cell);
            this.cells.push(cell);
        }
    }

    selectColor(index) {
        if (this.selectedColor !== null) {
            this.cells[this.selectedColor].classList.remove('color-selected');
        }

        this.selectedColor = index;
        this.cells[index].classList.add('color-selected');
    }
}