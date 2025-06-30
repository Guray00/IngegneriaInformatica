"use strict";

// Create a color struct (plain object)
export function createColor(r, g, b) {
    return { r, g, b };
}

// Get CSS style string from color struct
export function getColorStyle(color) {
    return "rgb("
        + Math.floor(color.r).toString() + ","
        + Math.floor(color.g).toString() + ","
        + Math.floor(color.b).toString() + ")";
}

// Calculate weighted sum of colors
export function weighedColorSum(weights_cols) {
    let r = 0;
    let g = 0;
    let b = 0;
    let weights_sum = 0;

    for (const wc of weights_cols) {
        r += wc[0] * wc[1].r;
        g += wc[0] * wc[1].g;
        b += wc[0] * wc[1].b;
        weights_sum += wc[0];
    }

    return createColor(Math.floor(r/weights_sum), Math.floor(g/weights_sum), Math.floor(b/weights_sum));
}