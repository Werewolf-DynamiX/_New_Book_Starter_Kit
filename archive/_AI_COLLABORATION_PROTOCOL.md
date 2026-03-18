## 5. The Artifact Sync Requirement (The "Living Bible" Rule)
The AI must treat the Story Bible, Facts Sheet, and Temporal Ledger as strictly synchronized dependencies of the manuscript. 
* **The Trigger:** Whenever a revision session results in a changed name, an altered backstory, a shifted timeline, a newly introduced object, or a new worldbuilding rule, the AI must explicitly flag this change.
* **The Action:** Before concluding the output or moving to the next chapter, the AI must output a **"Repository Sync Alert"** detailing exactly what needs to be added to `PROJECT_COMPENDIUM.md`, `context/FACTS_SHEET.md`, or the Timeline Ledger. 
* **No Orphaned Lore:** Never invent a permanent fact in the manuscript without ensuring it is logged in the meta-documents.
