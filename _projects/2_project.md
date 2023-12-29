---
layout: post
title: "YellowLynx MedCorp. Pt2"
description: Predicting medicine usage in the hospital context.
author: "Alessandro O de Sousa"
tags: [Python, Linear regression, Naive Bayes, XGBoost]
img: assets/img/3.jpg
importance: 2
category: work
---

<hr>


# asdasds
We used [Prophet](https://facebook.github.io/prophet/) to generate a Plotly dashboard to evaluate the Total Stock Usage (TSU)forecasting for the next 3 months. [Prophet](https://facebook.github.io/prophet/) is a modular regression model useful for time series that have strong seasonal effects and several seasons of historical data, robust to missing data and shifts in the trend, and capable of handling outliers.<br><br>

The example bellow shows the time series of TSU for the medicine fentanyl, a synthetic opioid primarily used as an analgesic or sedative. It was widely used to mantain sedation and suppress the cough reflex of COVID-19 patients with severe respiratory symptoms who required orotracheal intubation.<br><br>

{% include dash.html path="dash.html" %}
<div class="caption">Figure 1. Daily Medicine Usage and forecasting using Prophet(https://facebook.github.io/prophet/). The image above shows the number of units used daily in the hospital as well as the following 90 days.</div><br><br>