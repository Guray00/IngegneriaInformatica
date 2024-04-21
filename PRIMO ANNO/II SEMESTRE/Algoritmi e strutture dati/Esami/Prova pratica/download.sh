if [ -d "prove_pratiche_algoritmi" ]; then
    echo "fatal: prove_pratiche_algoritmi already exists"
    exit 1
fi
TARGET_DIR="$(pwd)"
cd $(mktemp -d)
git clone --filter=blob:none --no-checkout https://github.com/Guray00/IngegneriaInformatica.git
cd IngegneriaInformatica
git sparse-checkout set --no-cone 'PRIMO ANNO/II SEMESTRE/Algoritmi e strutture dati/Esami/Prova pratica'
git fetch origin
git checkout master
cd ..
mv 'IngegneriaInformatica/PRIMO ANNO/II SEMESTRE/Algoritmi e strutture dati/Esami/Prova pratica' prove_pratiche_algoritmi
mv prove_pratiche_algoritmi "$TARGET_DIR"