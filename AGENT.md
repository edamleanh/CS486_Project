# AGENTS.md — cs486-demo

CS486 database systems teaching demo. Repository is empty; expect code to be added during sessions.

## Recurring context

- Root directory: <!-- YOUR ROOT DIRECTORY -->
- This is a demo project, not production.
- Run `ls -la` to detect new files before assuming anything exists.

# Database Design Agent Rules

This project transforms business requirements into database design artifacts.

<!---YOU COULD CHANGE THE FOLLOW SECTIONS --->
## Workflow Order
Always follow this order:

1. Analyze business requirements.
2. Produce conceptual ERD using Crow's Foot notation.
3. Produce logical database design.
4. Validate design against business requirements.
5. Provide Database Definition (DDL) scripts.
6. Provide Sample Data (DML) scripts.
7. Provide Query Design (DQL) scripts.

Do not jump directly to DDL. The documents from the prior steps should be followed in the later steps.

## Required Outputs

- `outputs/01-business-req-analysis-G03.md`
- `outputs/02-erd-design-G03.md`
- `outputs/03-logical-design-G03.md`
- `outputs/04-design-validation-G03.md`
- `outputs/05-db-definition-G03.sql`
- `outputs/06-sample-data-G03.sql`
- `outputs/07-query-design-G03.sql`

## DBMS

Use Microsoft SQL Server unless the user specifies another DBMS.

## Design Rules

- Record assumptions explicitly.
- Record open questions explicitly.
- Preserve traceability from requirement → entity → relationship → table → constraint.
- Use Mermaid `erDiagram` for ERD.
- Do not silently invent business rules.
