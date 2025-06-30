# TileTide

**NOTA PER L'ESAMINATORE**: Nel database è presente un account demo con le credenziali:
- **Username**: test
- **Password**: testtest

A web-based Wave Function Collapse (WFC) pattern generator that creates infinite, coherent patterns from small input samples.

## Solo per studenti UNIPI
**Mie osservazioni**: A Vecchio piacciono, nell'ordine:

- le idee originali
- i featureset minimali, ma che funzionano
- i giochi interattivi
- la grafica semplice ma efficace

Per cui, secondo me, l'idea e la realizzazione delle funzionalità di base sono molto più importanti del numero di righe nel vostro progetto.

Non ho altro da dire. Per il resto seguite religiosamente le indicazioni di [Fabio Gulmini](https://github.com/Guray00/IngegneriaInformatica/blob/40738eae8fab1cdf4733f50019b4de1895c29f6c/SECONDO%20ANNO/I%20SEMESTRE/Progettazione%20Web/Esempi%20progetti/Fabio%20Gulmini%20(30%20e%20lode)/README.md).

## What is TileTide?

TileTide is an interactive implementation of the **Wave Function Collapse algorithm** using the overlapping model. It analyzes small pattern samples and generates larger, coherent patterns that maintain the visual relationships and structure of the original input.

### Key Features

- **Visual Pattern Editor** - Paint patterns with a 16-color palette
- **Real-time WFC Generation** - Watch patterns emerge step by step
- **Adjustable Parameters** - Control tile size, output dimensions, and generation speed
- **Save & Load System** - Store your patterns with user accounts
- **Wrapping Options** - Generate seamless, tileable patterns
- **Interactive Controls** - Play, pause, step through generation process

## How It Works

TileTide uses the **overlapping model** of Wave Function Collapse:

1. **Pattern Extraction** - Extracts all NxN overlapping patterns from your input
2. **Adjacency Analysis** - Determines which patterns can be placed adjacent by checking overlapping regions
3. **Constraint Propagation** - Maintains consistency across the entire output
4. **Progressive Collapse** - Gradually determines each cell by resolving the most constrained areas first

### Quick Start

1. **Create a Pattern**: Use the color palette to paint a small pattern (start with 10x10)
2. **Set Parameters**:
   - Tile Length: 3-4 works well for most patterns
   - Enable wrapping for seamless textures
3. **Generate**: Click "TRY" to switch to Wave Mode
4. **Watch It Grow**: Click "PLAY" to start the generation process

For detailed instructions, interface explanations, troubleshooting tips, and advanced usage, see the [User Guide](./guide.html).

## Acknowledgments

- Inspired by the Wave Function Collapse algorithm by [Maxim Gumin](https://github.com/mxgmn/WaveFunctionCollapse)

## Possible Improvements

- **Optimize Adjacency Checking**: Use more efficient data structures during constraint propagation
- **Image Download**: Add functionality to export generated patterns as PNG/JPEG files

## Links

- [User Guide](./guide.html)
- [Wave Function Collapse Paper](https://adamsmith.as/papers/wfc_is_constraint_solving_in_the_wild.pdf)