---
title: "Production FWA Auditing Ecosystem"
layout: "single"
url: "/projects/fwa-auditing-system/"
summary: "End-to-end healthcare fraud, waste, and abuse detection in production."
showToc: true
---

This is the detection and auditing ecosystem I designed and operate at a government health plan in Brasilia, Brazil. It monitors claims and documentary evidence across a network serving 110,000 beneficiaries.

Since entering production in April 2026, the system has intercepted over **R$21 million** in fraudulent and abusive claims.

## Architecture overview

The system is not a single model. It is a multi-layer pipeline where each stage feeds the next:

**Layer 1 - Billing rule engine.**
Deterministic rules derived from TISS/TUSS standards, ANS regulatory norms, and contractual terms. These catch structural violations: disallowed procedure codes, pricing above Brasindice/Simpro reference tables, duplicated billing lines, non-reimbursable inputs, and contractual exclusions.

**Layer 2 - Statistical anomaly detection.**
Provider-level behavioral profiling across 78 engineered features - billing velocity, procedure mix concentration, temporal patterns, cost-per-beneficiary ratios, and cross-provider benchmarks. An Isolation Forest model flags statistical outliers for further investigation.

**Layer 3 - ML risk scoring.**
A LightGBM gradient-boosted model trained on 8.3M+ rows with temporal train/test split. Primary evaluation metrics are AUC-PR and Precision@K, chosen because the class distribution is highly imbalanced (legitimate claims vastly outnumber fraudulent ones). SHAP values provide per-claim explainability, enabling auditors to understand exactly which features drove each score.

**Layer 4 - Documentary reconciliation.**
OCR-based extraction pipeline that reads supporting documentation (authorization forms, medical reports, prescriptions) and cross-references extracted text against billed procedure and medication codes. Uses a hybrid PyMuPDF to Tesseract approach with multi-DPI and multi-PSM fallback strategies. Includes signature verification and document layout detection via heuristics.

**Layer 5 - Prioritization.**
A module that ranks flagged claims by financial exposure relative to documentary evidence volume, directing human auditors to the highest-value, most-actionable cases first.

## Technical stack

| Component | Technology |
|---|---|
| Core language | Python 3.11+ |
| Analytical database | DuckDB |
| Production database | PostgreSQL |
| ML models | LightGBM, Isolation Forest (scikit-learn) |
| Explainability | SHAP |
| OCR pipeline | PyMuPDF, Tesseract (multi-DPI/PSM) |
| Dashboards | Apache Superset |
| Processing | Multiprocessing with dual-pool architecture |
| Infrastructure | Linux (Ubuntu), on-premise |

## Design principles

**Accuracy over performance.** Every design decision prioritizes detection precision. False negatives are costlier than compute time.

**Explainability is non-negotiable.** Every flag must be traceable to specific evidence - a billing rule violation, a SHAP attribution, or a documentary mismatch. Auditors need to defend findings in administrative proceedings.

**No black boxes.** The pipeline is fully transparent and auditable. No step produces outputs that cannot be inspected, logged, and reproduced.

## Constraints and disclosure

This system operates on government data subject to privacy and institutional confidentiality requirements. This page describes the architecture and methodology; it does not include source code, model weights, data samples, or screenshots of production dashboards.

The detection logic, feature engineering, and ML approach are my original design. The system runs on standard on-premise hardware - no cloud infrastructure or GPU clusters.

