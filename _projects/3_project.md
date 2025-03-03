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

Time series forecasting is not a easy task. There is not a "one for all" statistical model. Given that it was difficult to extract useful information of TSU at the aggregate level, we decided to redirect our efforts to predict of each product in terms of quantity used by month.

We took advantage of the XGBoost algorithm's speed and efficiency to perform forecasts of the usage of several medicines. We show bellow the forecast for the usage of the medicine sugammadex at LGH1 hospital. Sugammadex is used in the reversal of neuromuscular blockade induced by rocuronium and vecuronium in general anaesthesia.

{% include figure.html path="/assets/img/sugammadex_xgboost_forecast.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 1. Xgboost forecast of sugammadex at LGH1 hospital.</div>
<br>

For this example in particular, the model performed pretty well, showed low error values and a high R², as summarized in the table below.

<caption><b>Table 6. Regression-based evaluation metrics for sugammadex usage prediction using XGBoost.</b></caption>

| Metric |   Value  |
|:------:|:--------:|
|   MAE  | 4.605989 |
|  RMSE  | 5.118092 |
|   R²   | 0.930788 |

<br>


{% include figure.html path="/assets/img/aspirin_xgboost_forecast.jpg" class="img-fluid rounded z-depth-1" zoomable=true %} 
<div class="caption">Figure 1. Xgboost forecast of aspirin at LGH1 hospital.</div>
<br><br><br>




TEXT ABOUT ASPIRIN, ERROS AND OTHER THINGS.

<caption><b>Table 6. Regression-based evaluation metrics for sugammadex usage prediction using XGBoost.</b></caption>

| Metric |    Value   |
|:------:|:----------:|
|   MAE  | 418.350098 |
|  RMSE  | 507.437264 |
|   R²   |  0.672920  |

<br>

