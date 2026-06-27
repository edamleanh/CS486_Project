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

The document must include:
- Executive Summary
- Actors / Users
- Key Business Entities
- Major Business Processes / Use Cases
- Business Rules & Constraints
- Assumptions & Unresolved Questions

# Step 2: Conceptual Design / ERD

Save to: `outputs/02-erd-design-G03.md`

The ERD should be based on the document from Step 1.
The document must include:
- Entities & Attributes
- Relationships & Cardinality
- A Mermaid.js diagram of the ERD

# Step 3: Logical Database Design

Save to: `outputs/03-logical-design-G03.md`

Convert the conceptual ERD into a relational schema.
The document must include:
- Tables, Columns, Data Types
- Primary Keys (PK) and Foreign Keys (FK)
- Normalization explanations (up to 3NF)

# Step 4: Design Validation

Save to: `outputs/04-design-validation-G03.md`

The document must include:
- Cross-referencing tables with business rules
- Security & Access Control considerations
- Performance considerations (Indexes)

# Step 5: Database Definition (DDL)

Save to: `outputs/05-db-definition-G03.sql`

Provide the raw SQL to create the database schema.
The script must include:
- `CREATE TABLE` statements with appropriate data types.
- Primary key and foreign key constraints.
- `DROP TABLE IF EXISTS` statements at the beginning for idempotency.

# Step 6: Sample Data (DML)

Save to: `outputs/06-sample-data-G03.sql`

Provide the raw SQL to insert sample data.
The script must include:
- `INSERT INTO` statements for all tables.
- Sufficient data to properly test all queries in Step 7.

# Step 7: Query Design (DQL)

Save to: `outputs/07-query-design-G03.sql`

Provide the SQL queries based on the project requirements.
The script must include:
- 5 distinct analytical queries.
- Comments explaining what each query does.
- Proper use of JOINs, GROUP BY, aggregates, etc.