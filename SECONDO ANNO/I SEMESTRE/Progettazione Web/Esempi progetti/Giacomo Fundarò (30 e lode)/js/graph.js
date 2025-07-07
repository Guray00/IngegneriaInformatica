export const NODE_RADIUS = 20;
export const CENTER_FORCE = 0.05;
export const DRAG_SPRING = 2;

export class Node {
    constructor(x, y, indice, massa = 10) {
        this.x = x;
        this.y = y;
        this.vx = 0;
        this.vy = 0;
        this.ax = 0;
        this.ay = 0;
        this.indice = indice;
        this.massa = massa;
    }
}

export class Edge {
    constructor(from, to, weight = 10) {
        this.from = from;
        this.to = to;
        this.weight = weight;
    }
}

export let nodes = [];
export let edges = [];
export let selectedNode = null;
export let editingEdge = null;
export let deleteMode = false;
export let draggingNode = null;
export let dragTarget = { x: 0, y: 0 };
export let justDraggedNode = false;
export let simulationPaused = false;


export function setNodes(newNodes) { nodes = newNodes; }
export function setEdges(newEdges) { edges = newEdges; }
export function setSelectedNode(n) { selectedNode = n; }
export function setEditingEdge(e) { editingEdge = e; }
export function setDeleteMode(val) { deleteMode = val; }
export function setDraggingNode(n) { draggingNode = n; }
export function setDragTarget(obj) { dragTarget = obj; }
export function setJustDraggedNode(val) { justDraggedNode = val; }
export function setSimulationPaused(val) { simulationPaused = val; }

export function addNode(x, y) {
    const newNode = new Node(x, y, nodes.length);
    nodes.push(newNode);
}

export function findNodeNear(x, y) {
    const ratio = window.devicePixelRatio || 1;
    return nodes.find(n => Math.hypot(n.x - x, n.y - y) < NODE_RADIUS * ratio);
}

export function findEdgeNear(x, y) {
    const ratio = window.devicePixelRatio || 1;
    for (const edge of edges) {
        const n1 = nodes[edge.from];
        const n2 = nodes[edge.to];
        const dx = n2.x - n1.x;
        const dy = n2.y - n1.y;
        const len2 = dx*dx + dy*dy;
        if (len2 === 0) continue;
        let t = ((x - n1.x) * dx + (y - n1.y) * dy) / len2;
        t = Math.max(0, Math.min(1, t));
        const px = n1.x + t * dx;
        const py = n1.y + t * dy;
        const dist = Math.hypot(px - x, py - y);
        if (dist < 10 * ratio) return edge;
    }
    return null;
}

export function resetGraph(drawGraph) {
    nodes.length = 0;
    edges.length = 0;
    selectedNode = null;
    editingEdge = null;
    deleteMode = false;
    const deleteBtn = document.getElementById("deleteBtn");
    if (deleteBtn) deleteBtn.classList.remove("delete-active");
    if (drawGraph) drawGraph();
}

export function calcolaForze(forzaRepulsione = 1000, forzaAttrazione = 100) {
    const ratio = window.devicePixelRatio || 1;
    nodes.forEach(n => {
        n.ax = 0;
        n.ay = 0;
    });

    
    for (let i = 0; i < nodes.length; i++) {
        for (let j = i + 1; j < nodes.length; j++) {
            const dx = nodes[j].x - nodes[i].x;
            const dy = nodes[j].y - nodes[i].y;
            const dist2 = dx * dx + dy * dy;
            const minDist = NODE_RADIUS * 2 * ratio;
            const d = Math.max(Math.sqrt(dist2), minDist);

            const F = forzaRepulsione / (d * d);
            const fx = F * dx / d;
            const fy = F * dy / d;

            
            if (nodes[i] !== draggingNode) {
                nodes[i].ax -= fx / nodes[i].massa;
                nodes[i].ay -= fy / nodes[i].massa;
            }
            if (nodes[j] !== draggingNode) {
                nodes[j].ax += fx / nodes[j].massa;
                nodes[j].ay += fy / nodes[j].massa;
            }
        }
    }

    
    edges.forEach(edge => {
        const n1 = nodes[edge.from];
        const n2 = nodes[edge.to];
        const dx = n2.x - n1.x;
        const dy = n2.y - n1.y;
        const dist = Math.hypot(dx, dy);

        const desired = (40 + edge.weight * 10) * ratio;
        
        const k = forzaAttrazione * 0.01;
        const F = k * (dist - desired);

        if (dist > 0.01) {
            const fx = F * dx / dist;
            const fy = F * dy / dist;
            if (n1 !== draggingNode) {
                n1.ax += fx / n1.massa;
                n1.ay += fy / n1.massa;
            }
            if (n2 !== draggingNode) {
                n2.ax -= fx / n2.massa;
                n2.ay -= fy / n2.massa;
            }
        }
    });

    
    if (nodes.length > 0) {
        const canvas = document.getElementById("canvas");
        const centerX = canvas.width / 2;
        const centerY = canvas.height / 2;
        const avgX = nodes.reduce((sum, n) => sum + n.x, 0) / nodes.length;
        const avgY = nodes.reduce((sum, n) => sum + n.y, 0) / nodes.length;
        const dx = centerX - avgX;
        const dy = centerY - avgY;
        const dist = Math.hypot(dx, dy);
        const minCanvas = Math.min(canvas.width, canvas.height);
        const soglia = minCanvas / 6;

        if (dist > soglia) {
            nodes.forEach(n => {
                if (n !== draggingNode) {
                    n.ax += dx * CENTER_FORCE / n.massa;
                    n.ay += dy * CENTER_FORCE / n.massa;
                }
            });
        }
    }
}
