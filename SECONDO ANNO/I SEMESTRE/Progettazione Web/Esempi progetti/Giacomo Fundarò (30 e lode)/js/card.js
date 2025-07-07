import { NODE_RADIUS, setNodes, setEdges } from './graph.js';
import { drawGraph } from './draw.js';
import { ApiContext } from './apiContext.js';
import { nodes, edges } from './graph.js';

const api = new ApiContext();

document.getElementById("browse-graphs-btn").onclick = function() {
  document.getElementById("import-graphs-modal").classList.remove("hidden");
  loadAndShowGraphs();
};

document.getElementById("close-import-graphs").onclick = function() {
  document.getElementById("import-graphs-modal").classList.add("hidden");
};

export async function loadAndShowGraphs() {
  const container = document.getElementById("import-graphs-container");
  container.innerHTML = "";

  const saveCard = document.createElement("div");
  saveCard.id = "save-graph-card";
  saveCard.className = "graph-card save-graph-card";
  saveCard.innerHTML = `
    <div class="save-icon">💾</div>
    <div class="save-label">Salva grafo corrente</div>
  `;
  saveCard.onclick = async () => {
    const name = prompt("Nome del grafo da salvare:");
    if (!name) return;
    const graph = {
      name,
      data: {
        nodes,
        edges
      }
    };
    const res = await api.saveGraph(graph);
    if (res.status === "ok") {
      alert("Grafo salvato!");
      loadAndShowGraphs();
    } else {
      alert("Errore: " + (res.message || "Impossibile salvare"));
    }
  };
  container.appendChild(saveCard);

  const res = await api.getGraphs();
  if (res.status !== "ok") {
    container.innerHTML += "<div>Errore nel caricamento dei grafi.</div>";
    return;
  }
  const graphs = res.graphs;

  for (const graph of graphs) {
    const card = document.createElement("div");
    card.className = "graph-card";

    const previewDiv = document.createElement("div");
    previewDiv.className = "graph-preview";
    const canvas = document.createElement("canvas");
    canvas.width = 200;
    canvas.height = 120;
    previewDiv.appendChild(canvas);
    drawGraphPreview(canvas, graph.data);
    card.appendChild(previewDiv);

    const infoDiv = document.createElement("div");
    infoDiv.className = "graph-info";
    infoDiv.innerHTML = `
      <div class="graph-name">${graph.name}</div>
      <div class="graph-author">Autore: ${graph.author}</div>
    `;
    const importBtn = document.createElement("button");
    importBtn.className = "import-graph-btn";
    importBtn.textContent = "Importa";
    importBtn.onclick = () => {
      importGraph(graph.data);
      document.getElementById("import-graphs-modal").classList.add("hidden");
    };
    infoDiv.appendChild(importBtn);

    card.appendChild(infoDiv);
    container.appendChild(card);
  }
}


export function drawGraphPreview(canvas, data) {
  if (!data || !data.nodes || !data.edges) return;
  const cssWidth = 200;
  const cssHeight = 120;
  const dpr = window.devicePixelRatio || 1;
  canvas.width = cssWidth * dpr;
  canvas.height = cssHeight * dpr;
  canvas.style.width = cssWidth + "px";
  canvas.style.height = cssHeight + "px";
  const ctx = canvas.getContext("2d");
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  ctx.scale(dpr, dpr);
  ctx.clearRect(0, 0, cssWidth, cssHeight);

  
  let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
  data.nodes.forEach(n => {
    if (n.x < minX) minX = n.x;
    if (n.x > maxX) maxX = n.x;
    if (n.y < minY) minY = n.y;
    if (n.y > maxY) maxY = n.y;
  });

  
  const margin = 18;
  const w = maxX - minX || 1;
  const h = maxY - minY || 1;
  const scale = Math.min(
    (cssWidth - 2 * margin) / w,
    (cssHeight - 2 * margin) / h
  );

  
  const offsetX = (cssWidth - w * scale) / 2 - minX * scale;
  const offsetY = (cssHeight - h * scale) / 2 - minY * scale;

  
  const baseRadius = typeof NODE_RADIUS !== "undefined" ? NODE_RADIUS : 18;
  const minRadius = 3;
  const maxRadius = baseRadius * 0.7;
  const nodeCount = data.nodes.length;
  
  const nodeRadius = Math.max(minRadius, Math.min(maxRadius, 30 / Math.sqrt(nodeCount)));

  const darkMode = document.body.classList.contains("dark-mode");
  const nodeColor = darkMode ? "#00bfff" : "#007acc";
  const edgeColor = darkMode ? "#aaa" : "#444";
  const edgeWidth = 2;

  ctx.strokeStyle = edgeColor;
  ctx.lineWidth = edgeWidth;
  data.edges.forEach(edge => {
    const from = data.nodes[edge.from];
    const to = data.nodes[edge.to];
    ctx.beginPath();
    ctx.moveTo(from.x * scale + offsetX, from.y * scale + offsetY);
    ctx.lineTo(to.x * scale + offsetX, to.y * scale + offsetY);
    ctx.stroke();
  });

  data.nodes.forEach(node => {
    ctx.beginPath();
    ctx.arc(
      node.x * scale + offsetX,
      node.y * scale + offsetY,
      nodeRadius,
      0,
      2 * Math.PI
    );
    ctx.fillStyle = nodeColor;
    ctx.fill();
  });
}


export function importGraph(data) {
  const canvas = document.getElementById("canvas");
  const CANVAS_WIDTH = canvas ? canvas.width : 1150;
  const CANVAS_HEIGHT = canvas ? canvas.height : 650;

  
  let minX = Infinity, maxX = -Infinity, minY = Infinity, maxY = -Infinity;
  data.nodes.forEach(n => {
    if (n.x < minX) minX = n.x;
    if (n.x > maxX) maxX = n.x;
    if (n.y < minY) minY = n.y;
    if (n.y > maxY) maxY = n.y;
  });

  
  const margin = 60;
  const w = maxX - minX || 1;
  const h = maxY - minY || 1;
  const scale = Math.min(
    (CANVAS_WIDTH - 2 * margin) / w,
    (CANVAS_HEIGHT - 2 * margin) / h
  );

  
  const offsetX = (CANVAS_WIDTH - w * scale) / 2 - minX * scale;
  const offsetY = (CANVAS_HEIGHT - h * scale) / 2 - minY * scale;

  const nodesCopy = data.nodes.map((n, i) => ({
    x: n.x * scale + offsetX,
    y: n.y * scale + offsetY,
    indice: n.indice !== undefined ? n.indice : i,
    massa: n.massa !== undefined ? n.massa : 10,
    vx: n.vx !== undefined ? n.vx : 0,
    vy: n.vy !== undefined ? n.vy : 0,
    ax: n.ax !== undefined ? n.ax : 0,
    ay: n.ay !== undefined ? n.ay : 0
  }));

  const edgesCopy = data.edges.map(e => ({
    from: e.from,
    to: e.to,
    weight: e.weight !== undefined ? e.weight : 10
  }));

  setNodes(nodesCopy);
  setEdges(edgesCopy);
  drawGraph();
}