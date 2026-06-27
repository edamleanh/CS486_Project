---
name: db-design-pipeline
description: Analyze business requirements and produce conceptual ERD, logical database design, and DDL documents step by step.
compatibility: antigravity
---

# Database Design Pipeline Skill

Use this skill when the user asks to transform business requirements into a database design.

## Important behavior

Before assuming anything, inspect the project:

1. Locate requirement files under `req/`, `outputs/`, or files passed by the user.
2. Read the relevant requirement files fully before designing.
3. If the requirement is incomplete, continue with explicit assumptions, but also create an unresolved questions section.

## Required output files

Create or update the following files in order:

1. `outputs/01-business-req-analysis-G03.md`
2. `outputs/02-erd-design-G03.md`
3. `outputs/03-logical-design-G03.md`
4. `outputs/04-design-validation-G03.md`
5. `outputs/05-db-definition-G03.sql`
6. `outputs/06-sample-data-G03.sql`
7. `outputs/07-query-design-G03.sql`

Do not skip any file.

---

# Step 1: Business Requirement Analysis

Save to: `outputs/01-business-req-analysis-G03.md`

Analyze the requirements to identify the following. The document must include:
- Business purpose
- Actors / Users
- Entities and their attributes
- Relationships and cardinalities
- Business rules

# Step 2: Conceptual Database Design / ERD

Save to: `outputs/02-erd-design-G03.md`

Design an ERD showing the main conceptual elements. The document must include:
- Main entities and attributes
- Relationships, cardinalities, and participation constraints
- A Mermaid.js diagram (`erDiagram`) of the ERD

# Step 3: Logical Database Design

Save to: `outputs/03-logical-design-G03.md`

Convert the ERD into a relational schema. The document must include:
- Relations (Tables) and their attributes
- Primary keys and Foreign keys
- Candidate keys and Key constraints

# Step 4: Database Design Validation

Save to: `outputs/04-design-validation-G03.md`

The document must evaluate and validate the design. It must include:
- Evaluation of whether the relational schema correctly represents the ERD.
- Verification that it satisfies all business rules.
- Confirmation of the use of appropriate keys, relationships, and constraints.

# Step 5: Database Implementation (DDL)

Save to: `outputs/05-db-definition-G03.sql`

Provide the raw SQL to create the database schema.
The script must include:
- `CREATE TABLE` statements with appropriate data types.
- Keys (PK, FK), constraints, checks, and default values where appropriate.
- `DROP TABLE IF EXISTS` statements at the beginning for idempotency.

# Step 6: Sample Data Preparation (DML)

Save to: `outputs/06-sample-data-G03.sql`

Provide the raw SQL to insert sample data.
The script must include:
- `INSERT INTO` statements for all tables.
- Realistic sample data to support testing of normal operations and important exceptional cases.

# Step 7: Query Design (DQL)

Save to: `outputs/07-query-design-G03.sql`

Design and execute at least 5 meaningful SQL queries that are valid for the database and useful for answering business questions in the given context.
For each of the 5 queries, the script must include:
- Business question
- Target user(s) that would use the query
- Short explanation of why the query is useful
- SQL statement