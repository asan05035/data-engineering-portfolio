<div align="center">

# SQL Data Warehouse Project

**An end-to-end data engineering project demonstrating the design and implementation of a modern data warehouse using SQL Server and the Medallion Architecture.**

![SQL Server](https://img.shields.io/badge/Database-SQL_Server-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![Notion](https://img.shields.io/badge/Planning-Notion-000000?style=flat-square&logo=notion&logoColor=white)
![Figma](https://img.shields.io/badge/Design-Figma-F24E1E?style=flat-square&logo=figma&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Medallion-orange?style=flat-square)
![Status](https://img.shields.io/badge/Status-In_Progress-yellow?style=flat-square)

</div>

---

## 📑 Table of Contents

1. [Project Overview](#1-project-overview)
2. [Background Concepts](#2-background-concepts)
   - [What is a Data Warehouse?](#what-is-a-data-warehouse)
   - [What is ETL?](#what-is-etl)
3. [Data Architecture](#3-data-architecture)
4. [Project Phases](#4-project-phases)
5. [Repository Structure](#5-repository-structure)
6. [Naming Conventions](#6-naming-conventions)
7. [Tech Stack](#7-tech-stack)
8. [Progress Log](#8-progress-log)

---

## 🎯 1. Project Overview

This project simulates a real-world data engineering workflow, from initial requirement gathering through to a business-ready analytical data model. It is designed as a portfolio piece to demonstrate practical skills in:

- Data warehouse design and architecture planning
- ETL/ELT pipeline development
- Data cleansing, standardization, and integration
- Dimensional modeling (star schema)
- Engineering best practices — naming standards, documentation, and version control

**Objective:** Build a fully functional data warehouse in SQL Server that ingests raw source data, progressively refines it through the Bronze, Silver, and Gold layers, and exposes clean, aggregated, business-ready views for reporting and analysis.

---

## 📚 2. Background Concepts

### What is a Data Warehouse?

A **Data Warehouse (DWH)** is a centralized repository of data designed to support management decision-making. It is defined by three core characteristics:

| Property | Description |
|---|---|
| **Subject-oriented** | Organized around key business subjects (e.g. sales, customers) rather than operational processes |
| **Integrated** | Consolidates data from multiple, disparate sources into a consistent format |
| **Time-variant** | Retains historical data to support trend analysis over time |

### What is ETL?

**ETL (Extract, Transform, Load)** is the process of identifying source systems, extracting the required data, transforming it into a clean and standardized format, and loading it into a target destination.

#### Extraction

Data can be extracted via two primary methods:

| Method | Description |
|---|---|
| **Pull** | The system actively retrieves data (as a **full** or **incremental** load) |
| **Push** | The source system sends data directly to the target |

Common extraction sources include database queries, file parsing, event-based streaming, API calls, and Change Data Capture (CDC).

#### Transformation

| Technique | Description |
|---|---|
| **Data Cleansing** | Identifying and removing/filtering duplicates; handling nulls, blank spaces, and empty strings |
| **Data Normalization** | Applying business rules to derive new columns from existing data |
| **Data Integration** | Combining data from multiple sources into a unified structure |
| **Data Aggregation** | Summarizing data to support reporting requirements |

#### Load

Loading can occur as a **batch** or **stream** process, in either **full** or **incremental** form, and may involve managing **Slowly Changing Dimensions (SCD)** to preserve historical accuracy.

#### ETL Approach Used in This Project

| Stage | Approach |
|---|---|
| **Extraction** | Pull-based, full load, from file parsing |
| **Transformation** | Cleansing, normalization, integration, and aggregation |
| **Load** | Batch processing, full load (truncate & insert) |

---

## 🏗️ 3. Data Architecture

Several architectural patterns exist for structuring a data platform:

| Architecture | Data Flow |
|---|---|
| **Inmon** | Staging → Enterprise Data Warehouse → Data Marts |
| **Kimball** | Staging → Data Marts |
| **Data Vault** | Staging → Raw Vault → Data Vault → Data Marts |
| **Medallion** ✅ *(used in this project)* | Bronze → Silver → Gold |

This project implements a **Data Warehouse using the Medallion Architecture**, with the following end-to-end flow:

```
Source Files  →  Data Warehouse (Bronze → Silver → Gold)  →  Consumption (BI / Reporting)
```

A complete visual diagram of the architecture — covering source systems, the warehouse layers, and downstream consumption — was designed in **Figma** to support clear, end-to-end understanding of the data flow.

### Layer Specifications

| Layer | Object Type | Load Strategy | Transformation Applied | Data Model |
|---|---|---|---|---|
| **Bronze** | Table | Full load | None (raw as-is) | None |
| **Silver** | Table | Full load (truncate & insert) | Cleansing, normalization, standardization | None |
| **Gold** | View | N/A (virtualized) | Aggregation, integration | Star schema — fact & aggregated tables |

---

## 🚀 4. Project Phases

The project is structured into six sequential phases:

| # | Phase | Description |
|---|---|---|
| 1 | **Project Plan** | Define scope, epics, and tasks |
| 2 | **Design Data Architecture** | Select and diagram the target architecture |
| 3 | **Project Setup** | Establish conventions, repo structure, and database |
| 4 | **Bronze Layer** | Ingest raw source data |
| 5 | **Silver Layer** | Cleanse and standardize data |
| 6 | **Gold Layer** | Deliver business-ready, analytics-friendly models |

### 🗂️ Phase 1 — Project Plan

Project planning was managed in **Notion**, structured around high-level **epics**, each broken down into detailed tasks:

- Requirement Analysis
- Design Architecture
- Project Initialization
- Build Bronze Layer
- Build Silver Layer
- Build Gold Layer

**Requirement Analysis** focused on understanding:
- Source systems and data availability
- Data cleaning requirements
- Data integration needs
- Scope of historization — whether **SCD Type 1** or **Type 2** applies
- Documentation requirements

### 📐 Phase 2 — Design Data Architecture

Architectural approaches were evaluated across four categories: **Data Warehouse**, **Data Lake**, **Data Lakehouse**, and **Data Mesh**. Based on project requirements, a **Data Warehouse built on Medallion Architecture** (see [Section 3](#3-data-architecture)) was selected.

The full source-to-consumption design was visualized in **Figma** for stakeholder clarity.

### ⚙️ Phase 3 — Project Setup

The following foundational setup tasks were completed:

1. Defined detailed project tasks for each layer (Bronze, Silver, Gold)
2. Established the project's [naming conventions](#6-naming-conventions)
3. Set up the Git repository and folder structure (see [Section 5](#5-repository-structure))
4. Created the project database and schemas

### 🥉 Phase 4 — Bronze Layer

| Attribute | Detail |
|---|---|
| Purpose | Raw data ingestion, stored as-is from source |
| Object Type | Table |
| Load Strategy | Full load |
| Transformation | None |
| Data Model | None |

### 🥈 Phase 5 — Silver Layer

| Attribute | Detail |
|---|---|
| Purpose | Cleaned and standardized data |
| Object Type | Table |
| Load Strategy | Full load (truncate & insert) |
| Transformation | Cleansing, normalization, standardization |
| Data Model | None |

### 🥇 Phase 6 — Gold Layer

| Attribute | Detail |
|---|---|
| Purpose | Business-ready, consumption-layer data |
| Object Type | View |
| Load Strategy | N/A — virtualized on top of Silver |
| Transformation | Aggregation, integration |
| Data Model | Star schema — fact tables and aggregated tables |

---

## 📁 5. Repository Structure

```
├── datasets/       # Raw source data files
├── scripts/        # SQL / ETL scripts for Bronze, Silver, and Gold layers
├── docs/           # Documentation — architecture diagrams, naming conventions, notes
└── README.md       # Project overview and progress log
```

---

## 🏷️ 6. Naming Conventions

A consistent naming standard is applied across all tables, columns, and stored procedures to keep the data model readable and maintainable.

**General Principles**
- Use `snake_case` for all object and column names
- Avoid reserved words as identifiers (e.g. use `column_name` instead of `column`, `table_name` instead of `table`)

**Table Naming**

| Layer | Convention | Example |
|---|---|---|
| Bronze | `<source_system>_<entity>` | `crm_customers` |
| Silver | `<source_system>_<entity>` | `erp_sales_orders` |
| Gold | `<category>_<entity>` | `fact_sales`, `agg_monthly_revenue` |

**Column Naming**

| Column Type | Convention | Example |
|---|---|---|
| Surrogate key | Suffix `_key` | `customer_key` |
| Technical/metadata column | Prefix `dwh_` | `dwh_load_date` |

**Stored Procedures**

| Type | Convention | Example |
|---|---|---|
| Load procedure | `load_<purpose>` | `load_bronze_crm_customers` |

> Full details are documented in [`docs/naming_conventions.md`](docs/naming_conventions.md).

---

## 🛠️ 7. Tech Stack

| Category | Tool |
|---|---|
| Database | SQL Server |
| Language | SQL (T-SQL) |
| Project Planning | Notion |
| Architecture Design | Figma |
| Version Control | Git / GitHub |

---

## 📈 8. Progress Log

| Date | Milestone |
|---|---|
| _Ongoing_ | Completed Project Plan, Data Architecture Design, and Project Setup phases |

> This log is updated continuously as each phase of the project is completed.

---

<div align="center">

*A work-in-progress portfolio project showcasing end-to-end data warehouse design and ETL development using SQL Server.*

</div>
