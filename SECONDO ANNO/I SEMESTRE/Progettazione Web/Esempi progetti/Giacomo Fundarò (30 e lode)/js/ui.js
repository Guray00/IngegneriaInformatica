import {
    nodes, edges, addNode, findNodeNear, findEdgeNear, selectedNode, editingEdge,
    deleteMode, draggingNode, dragTarget, justDraggedNode, resetGraph, NODE_RADIUS, Edge,
    setNodes, setEdges, setSelectedNode, setEditingEdge, setDeleteMode, setDraggingNode, setDragTarget, setJustDraggedNode, simulationPaused, setSimulationPaused
} from './graph.js';
import { drawGraph } from './draw.js';
import { sliderToDamping } from './utils.js';
import { fruchtermanReingoldLayout, frLayoutActive } from './layout.js';
import { justClosedForm, resetJustClosedForm } from './auth.js';
import { AuthContext } from './authContext.js';
import * as userInfo from './userInfo.js';
import * as apiContext from './apiContext.js';
import { loadAndShowGraphs } from './card.js';


let forzaRepulsione = 1000;
let forzaAttrazione = 100;
let damping = 0.99;

export function inizializza() {
    const authContext = new AuthContext(apiContext, userInfo);
    window.authContext = authContext;

    document.getElementById("logout-btn").addEventListener("click", () => {
        authContext.logout();
    });

    document.getElementById("themeToggle").addEventListener("click", changetheme);

    const canvas = document.getElementById("canvas");
    resizeCanvas();

    canvas.addEventListener("click", canvasClick);

    
    const repulsionSlider = document.getElementById("repulsionRange");
    const repulsionValue = document.getElementById("repulsionValue");
    forzaRepulsione = Number(repulsionSlider.value) * 1000;
    repulsionValue.textContent = forzaRepulsione.toFixed(0);

    repulsionSlider.addEventListener("input", (e) => {
        forzaRepulsione = Number(e.target.value) * 1000;
        repulsionValue.textContent = forzaRepulsione.toFixed(0);
    });

    
    const attractionSlider = document.getElementById("attractionRange");
    const attractionValue = document.getElementById("attractionValue");
    forzaAttrazione = Number(attractionSlider.value) * 2;
    attractionValue.textContent = forzaAttrazione.toFixed(0);

    attractionSlider.addEventListener("input", (e) => {
        forzaAttrazione = Number(e.target.value) * 2;
        attractionValue.textContent = forzaAttrazione.toFixed(0);
    });

    
    const dampingSlider = document.getElementById("dampingRange");
    const dampingValue = document.getElementById("dampingValue");
    damping = sliderToDamping(dampingSlider.value);
    dampingValue.textContent = damping.toFixed(3);

    dampingSlider.addEventListener("input", (e) => {
        damping = sliderToDamping(e.target.value);
        dampingValue.textContent = damping.toFixed(3);
    });

    
    const deleteBtn = document.getElementById("deleteBtn");
    deleteBtn.addEventListener("click", () => {
        setDeleteMode(!deleteMode);
        deleteBtn.classList.toggle("delete-active", deleteMode);
    });

    
    const resetBtn = document.getElementById("resetBtn");
    resetBtn.addEventListener("click", () => resetGraph(drawGraph));

    
    const optimizeBtn = document.getElementById("optimizeBtn");
    optimizeBtn.addEventListener("click", () => {
        fruchtermanReingoldLayout(600);
    });

    
    const randomizeBtn = document.getElementById("randomizeBtn");
    randomizeBtn.addEventListener("click", randomizeNodePositions);

    
    canvas.addEventListener("mousedown", function(e) {
        const rect = canvas.getBoundingClientRect();
        const scaleX = canvas.width / rect.width;
        const scaleY = canvas.height / rect.height;
        const x = (e.clientX - rect.left) * scaleX;
        const y = (e.clientY - rect.top) * scaleY;
        const node = findNodeNear(x, y);
        if (node) {
            setDraggingNode(node);
            document.body.style.userSelect = "none";
        }
    });

    canvas.addEventListener("mousemove", function (e) {
        if (draggingNode) {
            const rect = canvas.getBoundingClientRect();
            const scaleX = canvas.width / rect.width;
            const scaleY = canvas.height / rect.height;
            const newX = (e.clientX - rect.left) * scaleX;
            const newY = (e.clientY - rect.top) * scaleY;

            setJustDraggedNode(true);
            
            draggingNode.x = newX;
            draggingNode.y = newY;
            draggingNode.vx = 0;
            draggingNode.vy = 0;
        }
    });

    canvas.addEventListener("mouseup", function() {
        setDraggingNode(null);
        document.body.style.userSelect = "";
    });
    canvas.addEventListener("mouseleave", function() {
        setDraggingNode(null);
        document.body.style.userSelect = "";
    });

    drawGraph();

    setInterval(() => {
        if (!simulationPaused) {
            aggiornaPosizioni(0.010);
            drawGraph();
        }
    }, 16);
}

export function resizeCanvas() {
    const canvas = document.getElementById("canvas");
    const ratio = window.devicePixelRatio || 1;
    const width = canvas.parentElement.offsetWidth;
    const height = canvas.parentElement.offsetHeight;
    canvas.width = width * ratio;
    canvas.height = height * ratio;
    canvas.style.width = width + "px";
    canvas.style.height = height + "px";
    drawGraph();
}

// --- Funzioni di interazione ---

function canvasClick(e) {
    if (frLayoutActive) return;

    if (justDraggedNode) {
        setJustDraggedNode(false); 
        return; 
    }
    if (justClosedForm) {
        resetJustClosedForm();
        return;
    }

    const canvas = document.getElementById("canvas");
    const rect = canvas.getBoundingClientRect();
    const scaleX = canvas.width / rect.width;
    const scaleY = canvas.height / rect.height;
    const x = (e.clientX - rect.left) * scaleX;
    const y = (e.clientY - rect.top) * scaleY;

    // --- ELIMINA MODE ---
    if (deleteMode) {
        const node = findNodeNear(x, y);
        if (node) {
            const idx = node.indice;
            
            for (let i = edges.length - 1; i >= 0; i--) {
                if (edges[i].from === idx || edges[i].to === idx) {
                    edges.splice(i, 1);
                }
            }
            
            nodes.splice(idx, 1);
            
            nodes.forEach((n, i) => n.indice = i);
            
            edges.forEach(e => {
                if (e.from > idx) e.from--;
                if (e.to > idx) e.to--;
            });
            drawGraph();
            return;
        }
        const edge = findEdgeNear(x, y);
        if (edge) {
            edges.splice(edges.indexOf(edge), 1);
            drawGraph();
            return;
        }
        return;
    }

    // --- SELEZIONE E CREAZIONE ARCHI ---
    const node = findNodeNear(x, y);
    if (node) {
        if (!selectedNode) {
            nodes.forEach(n => n.selected = false);
            node.selected = true;
            setSelectedNode(node);
        } else if (selectedNode === node) {
            showNodePrompt(node);
            return;
        } else {
            if (!edges.some(e => (e.from === selectedNode.indice && e.to === node.indice) ||
                                 (e.from === node.indice && e.to === selectedNode.indice))) {
                edges.push(new Edge(selectedNode.indice, node.indice, 10));
            }
            selectedNode.selected = false;
            setSelectedNode(null);
        }
        drawGraph();
        return;
    }

    
    if (selectedNode) {
        selectedNode.selected = false;
        setSelectedNode(null);
        drawGraph();
        return;
    }

    
    const edge = findEdgeNear(x, y);
    if (edge) {
        setEditingEdge(edge);
        showEdgePrompt(edge);
        return;
    }

    
    nodes.forEach(n => n.selected = false);
    addNode(x, y);
    setSelectedNode(null);
    drawGraph();
}

function changetheme() {
    document.body.classList.toggle("dark-mode");
    const btn = document.getElementById("themeToggle");
    if (document.body.classList.contains("dark-mode")) {
        btn.textContent = "☀️ Modalità Chiara";
    } else {
        btn.textContent = "🌙 Modalità Scura";
    }
    drawGraph();
}

function showEdgePrompt(edge) {
    const promptDiv = document.getElementById("edgePrompt");
    const input = document.getElementById("edgeWeightInput");
    const okBtn = document.getElementById("edgePromptOkBtn");

    promptDiv.style.display = "block";
    input.value = edge.weight;
    input.focus();

    function cleanup() {
        promptDiv.style.display = "none";
        setEditingEdge(null); 
        okBtn.removeEventListener("click", onOk);
        input.removeEventListener("keydown", onEnter);
        document.removeEventListener("mousedown", onOutside, true);
        document.removeEventListener("keydown", onEsc);
    }

    function onOk() {
        const w = parseInt(input.value);
        if (!isNaN(w) && w > 0) {
            edge.weight = w; 
            drawGraph();
        }
        cleanup();
    }

    function onEnter(e) {
        if (e.key === "Enter") onOk();
    }

    function onOutside(e) {
        if (!promptDiv.contains(e.target)) cleanup();
    }

    function onEsc(e) {
        if (e.key === "Escape") cleanup();
    }

    okBtn.addEventListener("click", onOk);
    input.addEventListener("keydown", onEnter);
    document.addEventListener("mousedown", onOutside, true);
    document.addEventListener("keydown", onEsc);
}

function showNodePrompt(node) {
    const promptDiv = document.getElementById("nodePrompt");
    const input = document.getElementById("nodeMassInput");
    const okBtn = document.getElementById("nodePromptOkBtn");

    promptDiv.style.display = "block";
    input.value = node.massa;
    input.focus();

    function cleanup() {
        promptDiv.style.display = "none";
        okBtn.removeEventListener("click", onOk);
        input.removeEventListener("keydown", onEnter);
        document.removeEventListener("mousedown", onOutside, true);
        document.removeEventListener("keydown", onEsc);
    }

    function onOk() {
        const m = parseInt(input.value);
        if (!isNaN(m) && m > 0) {
            node.massa = m;
            drawGraph();
        }
        cleanup();
    }

    function onEnter(e) {
        if (e.key === "Enter") onOk();
    }

    function onOutside(e) {
        if (!promptDiv.contains(e.target)) cleanup();
    }

    function onEsc(e) {
        if (e.key === "Escape") cleanup();
    }

    okBtn.addEventListener("click", onOk);
    input.addEventListener("keydown", onEnter);
    document.addEventListener("mousedown", onOutside, true);
    document.addEventListener("keydown", onEsc);
}

function randomizeNodePositions() {
    if (frLayoutActive) return;

    const canvas = document.getElementById("canvas");
    const width = canvas.width;
    const height = canvas.height;
    nodes.forEach(n => {
        n.x = Math.random() * (width - 2 * NODE_RADIUS) + NODE_RADIUS;
        n.y = Math.random() * (height - 2 * NODE_RADIUS) + NODE_RADIUS;
        n.vx = 0;
        n.vy = 0;
    });
    drawGraph();
}

// --- Funzione di simulazione ---
import { calcolaForze } from './graph.js';

function aggiornaPosizioni(dt = 0.016) {
    nodes.forEach(node => {
        node._oldAx = node.ax;
        node._oldAy = node.ay;
    });

    
    nodes.forEach(node => {
        node.x += node.vx * dt + 0.5 * node.ax * dt * dt;
        node.y += node.vy * dt + 0.5 * node.ay * dt * dt;
    });

    
    calcolaForze(forzaRepulsione, forzaAttrazione, damping);

    nodes.forEach(node => {
        node.vx += 0.5 * (node._oldAx + node.ax) * dt;
        node.vy += 0.5 * (node._oldAy + node.ay) * dt;
        node.vx *= (1-damping);
        node.vy *= (1-damping);

        
        const canvas = document.getElementById("canvas");
        const width = canvas.width;
        const height = canvas.height;
        node.x = Math.max(NODE_RADIUS, Math.min(width - NODE_RADIUS, node.x));
        node.y = Math.max(NODE_RADIUS, Math.min(height - NODE_RADIUS, node.y));
    });
}
