---
layout: page
title: Predictive Modeling
description: Predicting medicine usage in the hospital context.
img: assets/img/time_series_components.png
tags: [Pandas, Plotly, SARIMA, XGBoost]
importance: 3
category: Case Study - YellowLynx MedCorp (fictional)
toc:
  sidebar: left
---

<hr>

# POST IN PROGRESS
# Case Study: Analysis of medicine usage in an integrated hospital network (YellowLynx MedCorp) - Part 3 - Forecasting.
<br>


This project consists of a fictional scenario in which a health-related enterprize, YellowLynx MedCorp, needs to closely monitor inventory and stock usage, particularly medicines, across its various hospital departments located in a metropolitan area.

In the [second section](/projects/2_project/), we deep dived into the data provided, analysed the stock usage and derived features in order to better understand each hospital profile. We explored some inventory and logistic inventoty metrics key performance indicators (KPI) clearly displayed in dashboards.

In this third section, I will explore the **forecasting** aspects of the project.

Forecasting is crucial for organizations as it equips them with the ability to anticipate future trends, make informed decisions, and allocate resources efficiently. In the healthcare sector, the importance of forecasting becomes even more pronounced due to the high stakes involved in patient care, resource utilization, and financial sustainability.

So, let's begin!<br><br>

## 1. Initial evaluation and preliminary considerations<br><br>

Although the data in this case study is fictional, it demonstrates that extracting insights from real-world data is not an easy task. As pointed in the previous section, there is not a clear picture of seasonality at the aggregate level of the total stock usage (TSU) metric.

It is well known that the Sars-CoV (COVID-19) pandemic resulted in an increase in the numbers os hospitalization as well as prices of medications and other healt-related products. In contrast, some healthcare services and elective surgeries procedures where almost haulted during the pandemic.

Time series forecasting is not a easy task. There is not a "one for all" statistical model. Given that it was difficult to extract useful information of TSU at the aggregate level, we decided to redirect our efforts in the prediction of each product in terms of individual quantities.

We used [Prophet](https://facebook.github.io/prophet/) to generate a Plotly dashboard to evaluate the medicine usage forecasting for the next 3 months. [Prophet](https://facebook.github.io/prophet/) is a modular regression model useful for time series that have strong seasonal effects and several seasons of historical data, robust to missing data and shifts in the trend, and capable of handling outliers.<br><br>

The example bellow shows the time series of daily usage for the medicine fentanyl, a synthetic opioid primarily used as an analgesic or sedative. It was widely used to mantain sedation and suppress the cough reflex of COVID-19 patients with severe respiratory symptoms who required orotracheal intubation.<br><br>

{% include dash.html path="dash.html" %}
<div class="caption">Daily Medicine Usage and forecasting using Prophet(https://facebook.github.io/prophet/). The image above shows the number of units used daily in the hospital as well as the following 90 days.</div><br><br>


