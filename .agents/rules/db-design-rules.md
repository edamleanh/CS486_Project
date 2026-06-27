# Database Design Guardrails & Rules

## 1. Workflow Order
* Always follow this order: (1) Analyze business requirements -> (2) Produce conceptual ERD -> (3) Logical Database Design -> etc.
* Do not jump directly to writing SQL DDL.
* The documents from the prior steps should be followed in the later steps.

## 2. DBMS Standard
* Use **Microsoft SQL Server** unless the user specifies another DBMS.

## 3. Diagramming Standard
* Use **Mermaid `erDiagram`** for the ERD.
* Produce conceptual ERD using **Crow's Foot** notation.

## 4. Agent Behavior & Design Rules
* **Inspect the project first:** Before assuming anything, run `ls -la` to locate requirement files (e.g., under `req/`, `outputs/`) and read them fully before designing.
* **No invention:** Do not silently invent business rules.
* **Traceability:** Preserve traceability from requirement → entity → relationship → table → constraint.
* **Assumptions & Open Questions:** If the requirement is incomplete, continue with explicit assumptions, but also create an explicit "unresolved questions" or "open questions" section.

## 5. Cost Control & Security
* Do not repeatedly regenerate all files from scratch. Update only the specific file or section that needs improvement.
* Never commit API keys, access tokens, or private credentials to Git.
