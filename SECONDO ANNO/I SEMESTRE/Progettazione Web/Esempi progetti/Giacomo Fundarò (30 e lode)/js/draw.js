import { nodes, edges, NODE_RADIUS, editingEdge } from './graph.js';
import { frLayoutActive } from './layout.js';

export function drawGraph() {
    const canvas = document.getElementById("canvas");
    const ctx = canvas.getContext("2d");
    const ratio = window.devicePixelRatio || 1;
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.setTransform(1, 0, 0, 1, 0, 0);

    const darkMode = document.body.classList.contains("dark-mode");
    const nodeColor = darkMode ? "#00bfff" : "#007acc";
    const edgeColor = darkMode ? "#aaa" : "#444";
    const highlightColor = "#ff9800";

    
    // --- Calcola trasformazione solo se ottimizzazione attiva ---
    let tx = x => x, ty = y => y;
    if (frLayoutActive) {
        let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
        for (let n of nodes) {
            if (n.x < minX) minX = n.x;
            if (n.x > maxX) maxX = n.x;
            if (n.y < minY) minY = n.y;
            if (n.y > maxY) maxY = n.y;
        }
        const margin = NODE_RADIUS * 5;
        const width = canvas.width;
        const height = canvas.height;
        const targetWidth = width - 2 * margin;
        const targetHeight = height - 2 * margin;
        const scaleX = targetWidth / (maxX - minX || 1);
        const scaleY = targetHeight / (maxY - minY || 1);
        const scale = Math.min(scaleX, scaleY);

        const boxWidth = (maxX - minX) * scale;
        const boxHeight = (maxY - minY) * scale;
        const offsetX = (width - boxWidth) / 2 - minX * scale;
        const offsetY = (height - boxHeight) / 2 - minY * scale;

        tx = x => x * scale + offsetX;
        ty = y => y * scale + offsetY;
    }
    const showWeights = edges.some(edge => edge.weight !== 10);

    ctx.lineWidth = NODE_RADIUS/10;
    edges.forEach(edge => {
        const n1 = nodes[edge.from];
        const n2 = nodes[edge.to];
        ctx.beginPath();
        ctx.moveTo(tx(n1.x), ty(n1.y));
        ctx.lineTo(tx(n2.x), ty(n2.y));
        ctx.strokeStyle = (editingEdge === edge) ? highlightColor : edgeColor;
        ctx.stroke();

        if (showWeights) {
            const mx = (n1.x + n2.x) / 2;
            const my = (n1.y + n2.y) / 2;
            ctx.save();
            ctx.fillStyle = darkMode ? "#fff" : "#222";
            ctx.font = "18px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(edge.weight, tx(mx), ty(my - 8));
            ctx.restore();
        }
    });

    const showMass = nodes.some(nodes => nodes.massa !== 10);

    nodes.forEach(node => {
        ctx.beginPath();
        ctx.arc(tx(node.x), ty(node.y), NODE_RADIUS, 0, 2 * Math.PI);
        if (node.selected) {
            ctx.fillStyle = highlightColor;
        } else {
            ctx.fillStyle = nodeColor;
        }
        ctx.fill();

        if (showMass) {
            ctx.save();
            ctx.fillStyle = "#fff";
            ctx.font = "bold 18px sans-serif";
            ctx.textAlign = "center";
            ctx.textBaseline = "middle";
            ctx.fillText(node.massa, tx(node.x), ty(node.y));
            ctx.restore();
        }
    });
}
