#!/bin/bash
set -e

# Remove default README
rm -f README.md

# Create directory structure
mkdir -p .github/workflows
mkdir -p assets/css
mkdir -p content/about
mkdir -p content/cv
mkdir -p content/projects
mkdir -p layouts/partials
mkdir -p static/img
mkdir -p static/pdf


cat > '.gitignore' << 'FILEEOF'
public/
resources/
.hugo_build.lock

FILEEOF

cat > 'README.md' << 'FILEEOF'
# sousa-a.github.io

Personal portfolio - Healthcare FWA Detection.

## Setup

```bash
# 1. Install Hugo extended
wget https://github.com/gohugoio/hugo/releases/download/v0.147.1/hugo_extended_0.147.1_linux-amd64.deb
sudo dpkg -i hugo_extended_0.147.1_linux-amd64.deb

# 2. Add PaperMod theme
git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod

# 3. Add profile photo at static/img/profile.jpg (square, 320x320px+)

# 4. Local preview
hugo server -D

# 5. Deploy: push to main, GitHub Actions handles the rest
# Repo Settings > Pages > Source: GitHub Actions
```

## Structure

```
content/
  about/index.md
  cv/index.md
  projects/
    index.md
    fwa-auditing-system.md
```

FILEEOF

cat > 'hugo.yaml' << 'FILEEOF'
baseURL: "https://sousa-a.github.io/"
languageCode: "en-us"
title: "Alessandro O. Sousa"
theme: "PaperMod"

params:
  env: production
  description: "Healthcare Fraud, Waste & Abuse Detection"
  author: "Alessandro O. Sousa"
  defaultTheme: light
  ShowReadingTime: false
  ShowShareButtons: false
  ShowPostNavLinks: false
  ShowBreadCrumbs: false
  ShowCodeCopyButtons: true
  ShowToc: false
  hideSummary: false
  showtags: false

  profileMode:
    enabled: true
    title: "Alessandro O. Sousa"
    subtitle: |
      Healthcare Fraud, Waste & Abuse detection.
      I build systems that find what shouldn't be billed.
    imageUrl: "img/profile.jpg"
    imageWidth: 160
    imageHeight: 160
    buttons:
      - name: Projects
        url: /projects/
      - name: About
        url: /about/
      - name: CV
        url: /cv/

  socialIcons:
    - name: github
      url: "https://github.com/sousa-a"
    - name: linkedin
      url: "https://www.linkedin.com/in/alessandro-sousa-ab8291b2"
    - name: email
      url: "mailto:alessandroodesousa@gmail.com"

  assets:
    favicon: "img/favicon.ico"
    customCSS:
      - "css/custom.css"

menu:
  main:
    - identifier: about
      name: About
      url: /about/
      weight: 10
    - identifier: projects
      name: Projects
      url: /projects/
      weight: 20
    - identifier: cv
      name: CV
      url: /cv/
      weight: 30

outputs:
  home:
    - HTML
    - RSS

markup:
  highlight:
    style: monokai
    lineNos: false
  goldmark:
    renderer:
      unsafe: true

FILEEOF

cat > '.github/workflows/deploy.yml' << 'FILEEOF'
name: Deploy Hugo site

on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

defaults:
  run:
    shell: bash

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      HUGO_VERSION: 0.147.1
    steps:
      - name: Install Hugo CLI
        run: |
          wget -O ${{ runner.temp }}/hugo.deb https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb \
          && sudo dpkg -i ${{ runner.temp }}/hugo.deb

      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Setup Pages
        id: pages
        uses: actions/configure-pages@v5

      - name: Build with Hugo
        env:
          HUGO_CACHEDIR: ${{ runner.temp }}/hugo_cache
          HUGO_ENVIRONMENT: production
          TZ: America/Sao_Paulo
        run: |
          hugo \
            --gc \
            --minify \
            --baseURL "${{ steps.pages.outputs.base_url }}/"

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4

FILEEOF

cat > 'assets/css/custom.css' << 'FILEEOF'
/* ── Impact metrics row on homepage ── */
.metrics {
  display: flex;
  justify-content: center;
  gap: 3rem;
  margin: 2.5rem 0 1rem;
  flex-wrap: wrap;
}

.metric {
  text-align: center;
}

.metric .number {
  font-size: 2.2rem;
  font-weight: 700;
  color: var(--primary);
  line-height: 1.1;
}

.metric .label {
  font-size: 0.85rem;
  color: var(--secondary);
  margin-top: 0.25rem;
  max-width: 160px;
}

/* ── Project cards ── */
.project-grid {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1.5rem;
  margin: 1.5rem 0;
}

.project-card {
  border: 1px solid var(--border);
  border-radius: 8px;
  padding: 1.5rem;
  transition: border-color 0.2s ease;
}

.project-card:hover {
  border-color: var(--primary);
}

.project-card h3 {
  margin: 0 0 0.5rem;
  font-size: 1.15rem;
}

.project-card h3 a {
  text-decoration: none;
  color: var(--primary);
}

.project-card p {
  margin: 0 0 0.75rem;
  color: var(--secondary);
  font-size: 0.92rem;
  line-height: 1.5;
}

.project-card .tags {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
}

.project-card .tags span {
  font-size: 0.75rem;
  padding: 0.15rem 0.5rem;
  border-radius: 4px;
  background: var(--code-bg);
  color: var(--secondary);
}

.project-card .impact {
  margin-top: 0.75rem;
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--primary);
}

/* ── About page - tech stack pills ── */
.stack-pills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem;
  margin: 0.75rem 0 1.5rem;
}

.stack-pills span {
  font-size: 0.8rem;
  padding: 0.2rem 0.6rem;
  border-radius: 4px;
  background: var(--code-bg);
  color: var(--secondary);
}

/* ── CV timeline ── */
.cv-entry {
  margin-bottom: 1.75rem;
  padding-left: 1rem;
  border-left: 2px solid var(--border);
}

.cv-entry .cv-period {
  font-size: 0.82rem;
  color: var(--secondary);
  font-weight: 600;
}

.cv-entry h3 {
  margin: 0.15rem 0 0.1rem;
  font-size: 1.05rem;
}

.cv-entry .cv-org {
  font-size: 0.9rem;
  color: var(--secondary);
  margin-bottom: 0.5rem;
}

.cv-entry ul {
  margin: 0.25rem 0 0;
  padding-left: 1.2rem;
}

.cv-entry ul li {
  font-size: 0.9rem;
  margin-bottom: 0.3rem;
  line-height: 1.5;
}

/* ── General polish ── */
.post-content h2 {
  margin-top: 2rem;
}

FILEEOF

cat > 'layouts/partials/extend_head.html' << 'FILEEOF'
{{ $css := resources.Get "css/custom.css" | minify }}
<link rel="stylesheet" href="{{ $css.RelPermalink }}" />

FILEEOF

cat > 'layouts/partials/extend_footer.html' << 'FILEEOF'
{{ if .IsHome }}
<script>
  document.addEventListener('DOMContentLoaded', function() {
    const profile = document.querySelector('.profile');
    if (!profile) return;

    const metrics = document.createElement('div');
    metrics.className = 'metrics';
    metrics.innerHTML = `
      <div class="metric">
        <div class="number">R$21M+</div>
        <div class="label">Intercepted fraudulent & abusive claims</div>
      </div>
      <div class="metric">
        <div class="number">110K</div>
        <div class="label">Lives covered by the health plan</div>
      </div>
      <div class="metric">
        <div class="number">8.3M+</div>
        <div class="label">Rows scored in production ML pipeline</div>
      </div>
    `;

    const buttons = profile.querySelector('.buttons');
    if (buttons) {
      profile.insertBefore(metrics, buttons);
    } else {
      profile.appendChild(metrics);
    }
  });
</script>
{{ end }}

FILEEOF

cat > 'content/about/index.md' << 'FILEEOF'
---
title: "About"
layout: "single"
url: "/about/"
summary: "About Alessandro O. Sousa"
showToc: false
---

I lead the fraud, waste, and abuse (FWA) detection unit at a government health plan in Brasilia, Brazil, covering 110,000 beneficiaries. I designed and operate the production auditing ecosystem that has intercepted over R$21 million in fraudulent and abusive claims since April 2026.

The system combines billing rule engines, a LightGBM risk-scoring model trained on 8.3M+ rows with 78 engineered features, documentary reconciliation through adaptive OCR pipelines (PyMuPDF + Tesseract), Isolation Forest anomaly detection, and SHAP-based explainability - all orchestrated in Python and DuckDB, with dashboards served through Apache Superset.

## Technical stack

<div class="stack-pills">
  <span>Python</span>
  <span>DuckDB</span>
  <span>PostgreSQL</span>
  <span>LightGBM</span>
  <span>scikit-learn</span>
  <span>PyMuPDF</span>
  <span>Tesseract OCR</span>
  <span>Pandas</span>
  <span>SHAP</span>
  <span>Apache Superset</span>
  <span>Power BI</span>
  <span>Selenium</span>
  <span>Dash</span>
  <span>SQL</span>
  <span>Git</span>
  <span>Linux</span>
</div>

## Background

My path to FWA detection was non-linear. I hold a PhD in Genetics and a Bachelor's in Pharmaceutical Sciences from the University of Brasilia. This scientific training - experimental design, statistical rigor, hypothesis testing against noisy biological data - turned out to be directly transferable to healthcare billing auditing, where the signal-to-noise ratio is just as hostile.

Before leading the FWA unit, I spent several years in progressive leadership roles within the government healthcare system: managing teams, directing a R$600M budget for medications and health supplies across 14 hospitals and 170+ primary care units, and building the inventory monitoring and procurement analytics infrastructure from scratch. That operational experience - knowing how hospitals actually move drugs, supplies, and billing records - is what makes the detection system effective. The logic is grounded in how the system actually works and where the cracks form.

## What I'm looking for

I'm exploring remote opportunities in the US healthcare FWA market - SIU analytics, claims integrity, provider risk scoring, and related roles. If your organization is building or scaling FWA detection capabilities, I'd welcome a conversation.

<p style="margin-top: 1.5rem;">
  <a href="mailto:alessandroodesousa@gmail.com">alessandroodesousa@gmail.com</a> ·
  <a href="https://github.com/sousa-a" target="_blank">GitHub</a> ·
  <a href="https://www.linkedin.com/in/alessandro-sousa-ab8291b2" target="_blank">LinkedIn</a>
</p>

FILEEOF

cat > 'content/cv/index.md' << 'FILEEOF'
---
title: "CV"
layout: "single"
url: "/cv/"
summary: "Experience, education, and technical background."
showToc: false
---

<!-- <p><a href="/pdf/alessandro-sousa-cv.pdf" target="_blank">Download PDF →</a></p> -->

## Experience

<div class="cv-entry">
  <div class="cv-period">2026 - present</div>
  <h3>Head of Healthcare Monitoring, Compliance & Intelligence</h3>
  <div class="cv-org">Government Health Plan - Brasilia, Brazil</div>
  <ul>
    <li>Designed and operate a production FWA auditing ecosystem that has intercepted R$21M+ in fraudulent and abusive claims since April 2026.</li>
    <li>Lead fraud, waste, and abuse detection and healthcare billing compliance for a plan covering 110,000 lives.</li>
    <li>Built the full ML pipeline: LightGBM risk scoring (8.3M+ rows, 78 features), Isolation Forest anomaly detection, SHAP explainability, and OCR-based documentary reconciliation.</li>
  </ul>
</div>

<div class="cv-entry">
  <div class="cv-period">2024 - 2026</div>
  <h3>Director - Drug and Health Supplies Planning</h3>
  <div class="cv-org">Department of Health of the Federal District - Brasilia, Brazil</div>
  <ul>
    <li>Directed planning and budget oversight (~R$600M) for medications and health supplies across 14 hospitals and 170+ primary care units serving 4.8 million patients.</li>
    <li>Led a directorate of 4 departments and 60 people.</li>
  </ul>
</div>

<div class="cv-entry">
  <div class="cv-period">2023 - 2024</div>
  <h3>Manager - Orthotics and Prosthetics Planning</h3>
  <div class="cv-org">Department of Health of the Federal District - Brasilia, Brazil</div>
  <ul>
    <li>Managed a team of 12 responsible for budgeting, contract management, and monitoring surgical and outpatient use of orthotics and prosthetics across the public hospital network.</li>
  </ul>
</div>

<div class="cv-entry">
  <div class="cv-period">2020 - 2023</div>
  <h3>Analyst / Advisor</h3>
  <div class="cv-org">Department of Health of the Federal District - Brasilia, Brazil</div>
  <ul>
    <li>Developed inventory monitoring methodologies and procurement dashboards using Python, SQL, PostgreSQL, and Power BI.</li>
    <li>Implemented KPIs for medication and supply usage across the hospital network.</li>
  </ul>
</div>

<div class="cv-entry">
  <div class="cv-period">2012 - 2014</div>
  <h3>Lecturer - Parasitology Department</h3>
  <div class="cv-org">Faculty of Medicine, University of Brasilia - Brasilia, Brazil</div>
</div>

## Education

<div class="cv-entry">
  <div class="cv-period">2012</div>
  <h3>PhD in Genetics</h3>
  <div class="cv-org">University of Brasilia</div>
</div>

<div class="cv-entry">
  <div class="cv-period">2008</div>
  <h3>Bachelor of Pharmaceutical Sciences</h3>
  <div class="cv-org">University of Brasilia</div>
</div>

## Certifications

<div class="cv-entry">
  <div class="cv-period">2023</div>
  <h3>Google Advanced Data Analytics Certificate</h3>
  <div class="cv-org">Coursera</div>
</div>

<div class="cv-entry">
  <div class="cv-period">2023</div>
  <h3>Google Data Analytics Certificate</h3>
  <div class="cv-org">Coursera</div>
</div>

## Technical stack

| Domain | Tools |
|---|---|
| Languages | Python, SQL |
| ML / Stats | LightGBM, scikit-learn, SHAP, Isolation Forest, Statsmodels |
| Data | DuckDB, PostgreSQL, Pandas |
| OCR / Documents | PyMuPDF, Tesseract |
| Visualization | Apache Superset, Power BI, Matplotlib, Seaborn, Plotly |
| Automation | Selenium, Dash |
| Infrastructure | Linux (Ubuntu/Mint), Git, systemd |

## Domains

Healthcare, Government, Public Administration, Leadership, FWA Detection, Claims Integrity, Pharmaceutical Sciences, Regulatory Compliance

FILEEOF

cat > 'content/projects/index.md' << 'FILEEOF'
---
title: "Projects"
layout: "single"
url: "/projects/"
summary: "Selected projects in healthcare FWA detection and data engineering."
showToc: false
---

<div class="project-grid">

<div class="project-card">
<h3><a href="/projects/fwa-auditing-system/">Production FWA Auditing Ecosystem</a></h3>
<p>
End-to-end fraud, waste, and abuse detection system in production at a government health plan covering 110K lives. Combines billing rule engines, ML-based provider risk scoring (LightGBM, Isolation Forest), documentary reconciliation via adaptive OCR, and SHAP explainability.
</p>
<div class="tags">
  <span>Python</span>
  <span>DuckDB</span>
  <span>LightGBM</span>
  <span>Tesseract</span>
  <span>PyMuPDF</span>
  <span>SHAP</span>
  <span>Superset</span>
</div>
<div class="impact">R$21M+ intercepted since April 2026</div>
</div>

<div class="project-card">
<h3><a href="https://github.com/sousa-a/medicare-upcoding-unbundling-engine" target="_blank">Medicare Upcoding & Unbundling Detection Engine</a></h3>
<p>
Automated detection pipeline for the two most prevalent forms of Medicare billing fraud - DRG upcoding, E&M upcoding, and NCCI unbundling - validated on all 20 samples (~35GB) of the CMS DE-SynPUF dataset. Composite risk scoring via Isolation Forest on 230 million synthetic claims.
</p>
<div class="tags">
  <span>Python</span>
  <span>DuckDB</span>
  <span>scikit-learn</span>
  <span>CMS DE-SynPUF</span>
</div>
<div class="impact"><a href="https://medium.com/@alessandro.oof/detecting-medicare-fraud-at-scale-building-an-upcoding-unbundling-detection-engine-on-230-4de555db568d" target="_blank">Read the deep-dive on Medium →</a></div>
</div>

<div class="project-card">
<h3><a href="https://github.com/sousa-a/medicare-phantom-billing-engine" target="_blank">Medicare Phantom Billing Detection Engine</a></h3>
<p>
Four-module detection pipeline targeting phantom billing schemes: post-mortem billing (claims after beneficiary death), impossible service days, pre-mortem billing surges, and composite anomaly scoring via Isolation Forest. Built on the full CMS DE-SynPUF dataset.
</p>
<div class="tags">
  <span>Python</span>
  <span>DuckDB</span>
  <span>scikit-learn</span>
  <span>CMS DE-SynPUF</span>
</div>
<div class="impact"><a href="https://github.com/sousa-a/medicare-phantom-billing-engine" target="_blank">View on GitHub →</a></div>
</div>

</div>

FILEEOF

cat > 'content/projects/fwa-auditing-system.md' << 'FILEEOF'
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

FILEEOF

echo "All files created. Now run:"
echo "  git submodule add --depth=1 https://github.com/adityatelange/hugo-PaperMod.git themes/PaperMod"
echo "  git add -A"
echo "  git commit -m \"Initial build: Hugo + PaperMod portfolio\""
echo "  git push origin main"
