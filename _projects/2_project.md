---
layout: page
title: "YellowLynx MedCorp. Pt2"
description: Predicting medicine usage in the hospital context.
author: "Alessandro O de Sousa"
tags: [Python, Linear regression, Naive Bayes, XGBoost]
img: assets/img/3.jpg
importance: 2
category: work
---
# asdasds
We used [Prophet](https://facebook.github.io/prophet/) to generate a Plotly dashboard to evaluate the Total Stock Usage(TSU)forecasting for the next 3 months.<br>
The example bellow shows the TSU for the medicine propofol 10mg/ml, a hypnotic or sedative agent used to mantain anesthesioa or sedation. It was widely used to mantain sedation of in COVID-19 patients with severe respiratory symptoms who required orotracheal intubation.<br>
[Prophet](https://facebook.github.io/prophet/) is a useful for time series that have strong seasonal effects and several seasons of historical data, robust to missing data and shifts in the trend, and capable of handling outliers.

{% include figure.html path="/assets/img/plotlyprophet.png" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 1. Total Stock Usage ($) forecasting using [Prophet](https://facebook.github.io/prophet/).</div>