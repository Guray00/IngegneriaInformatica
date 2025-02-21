# Istruzioni per l'installazione e l'uso del progetto

Per installare e usare il progetto, seguire le istruzioni presenti nella sezione **Manuale utente** della documentazione.

Per far funzionare l'invio nella parte di test, all'inizio del file bisogna settare `INDIRIZZO_TEST` a una email esistente, così da ricevere i prospetti.

---

# Osservazioni sull'esame

L'esame è andato bene. Le uniche osservazioni sono state le seguenti:

1. **Documentazione**:
   - Il wireframe fatto da me andava nella sezione **Analisi**.
   - Nella sezione dei **Requisiti**, ci andava lo screenshot fornito dal professore, senza modifiche.

2. **Generazione dei PDF**:
   - Avrebbe preferito che per generare i PDF della commissione avessi riutilizzato quelli già generati per il laureando.

3. **Formula del voto**:
   - La formula del voto avrebbe dovuto essere creata una volta sola in `GeneratoreProspetti`, invece di essere definita separatamente in `ProspettoPDFLaureando` e in `ProspettoConSimulazione`.

4. **Check del tipo di laureando**:
   - Avrebbe preferito che il controllo sul tipo di laureando (se informatica o no) fosse centralizzato in un unico punto, ma non ho capito come voleva implementarlo. Ha fatto un discorso un po’ confuso, quindi questa parte può essere tranquillamente ignorata.

5. **Invio dei prospetti**:
   - Tiene molto alla possibilità di inviare solo alcuni prospetti e non tutti quelli generati.
   - È importante consentire di:
     - Riprendere l'invio da dove era rimasto dopo un errore.
     - Chiedere una lista di matricole da inviare (come implementato nel mio progetto).

6. **Relazione mancante**:
   - Mi sono dimenticato di aggiungere la relazione di utilizzo da `InvioProspetti` a `GestioneCarrieraStudente` per recuperare l'email.

---

# Note sull'esame

- Le domande riguardano esclusivamente il progetto, non la teoria.
- Anche se non avevo finito tutti i checkpoint, il prof è abbastanza alto di voti.
  
## Cosa è importante per il professore:
- **Test**:
  - Tiene molto ai test e alla possibilità di aggiungerne facilmente di nuovi.
  - I test devono coprire anche funzioni basilari, come il calcolo della media.
  - Devono confrontare l'output con un risultato atteso, indicando il successo o il fallimento.

- **Codice**:
  - Anche se a lezione dice di no (_perché non c'è la propedeuticità con pweb_), in realtà guarda molto il codice.
  - Non sempre fa domande, ma quando le fa, può chiedere dettagli sul codice