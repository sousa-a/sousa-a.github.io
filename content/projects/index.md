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

