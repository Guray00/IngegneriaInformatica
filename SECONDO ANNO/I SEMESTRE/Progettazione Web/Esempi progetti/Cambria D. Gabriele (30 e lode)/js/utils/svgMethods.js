"use strict";

export const svgNamespace = "http://www.w3.org/2000/svg";

/**
 * Centra orizzontalmente (e opzionalmente verticalmente) un elemento SVG rispetto a un altro.
 * @param {SVGSVGElement} svgDoc Il nodo SVG principale (es: document.querySelector('svg'))
 * @param {string} idToCenter id dell'elemento da centrare (es: testo)
 * @param {string} idReference id dell'elemento di riferimento (es: rettangolo)
 * @param {boolean} [vertical=true] se `true` centra anche verticalmente, altrimenti solo orizzontalmente [Default = `true`]
 */
export function centerSvgElement(svgDoc, idToCenter, idReference, vertical = true){
    const elToCenter = svgDoc.getElementById(idToCenter);
    const refEl = svgDoc.getElementById(idReference);
    
	if (!elToCenter || !refEl) 
		return;

    const refBox = refEl.getBBox();

    let x = refBox.x + refBox.width / 2;
    let textLength = 0;

    // Se è testo SVG, usa getComputedTextLength per la larghezza, altrimenti utilizzo width
    if (typeof elToCenter.getComputedTextLength === "function"){
        textLength = elToCenter.getComputedTextLength();
    } 
	else if (elToCenter.hasAttribute("width")){
        textLength = parseFloat(elToCenter.getAttribute("width")) || 0;
    }

    elToCenter.setAttribute("x", x - textLength / 2);

    if (vertical){
        let y = refBox.y + refBox.height / 2;
        if (elToCenter.tagName.toLowerCase() === "text"){
            y += 10;
        }
        elToCenter.setAttribute("y", y);
    }
}

/**
 * Inserisce un'immagine SVG all'interno di un rettangolo, applicando una clipPath se presente.
 * @param {SVGSVGElement} svgDoc - Il nodo SVG principale.
 * @param {string} rectId - id del rettangolo di riferimento.
 * @param {string} imgHref - percorso dell'immagine da inserire. Viene salvato come `"./../" + imgHref`
 * @param {string} clipPathId - id della clipPath da applicare (opzionale).
 * @param {Object} [imgAttrs] - attributi aggiuntivi da applicare all'image (opzionale).
 */
export function insertClippedImage(svgDoc, rectId, imgHref, clipPathId, imgAttrs = {}){
    const rect = svgDoc.getElementById(rectId);
	
    if (!rect) 
		return;
	
    // Imposta attributi opzionali sul rettangolo (es: fill, rx, class)
    if (imgAttrs.rect){
        Object.entries(imgAttrs.rect).forEach(([k, v]) => rect.setAttribute(k, v));
    }

    const img = document.createElementNS(svgNamespace, "image");
    img.setAttribute("href", "./../../" + imgHref);
    img.setAttribute("x", rect.getAttribute("x"));
    img.setAttribute("y", rect.getAttribute("y"));
    img.setAttribute("width", rect.getAttribute("width"));
    img.setAttribute("height", rect.getAttribute("height"));
    if (clipPathId) 
        img.setAttribute("clip-path", `url(#${clipPathId})`);

    // Attributi aggiuntivi sull'image
    if (imgAttrs.image){
        Object.entries(imgAttrs.image).forEach(([k, v]) => img.setAttribute(k, v));
    }

    rect.parentNode.insertBefore(img, rect.nextSibling);
}