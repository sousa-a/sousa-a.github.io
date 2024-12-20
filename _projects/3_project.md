---
layout: page
title: Predictive Modeling
description: Predicting medicine usage in the hospital context.
img: assets/img/time_series_components.png
tags: [Python, Linear regression, Naive Bayes, XGBoost]
importance: 3
category: Case Study - YellowLynx MedCorp (fictional)
toc:
  sidebar: left
---

<hr>

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

However, further analysis should allow the identification of groups of seasonal products and their impact in the TSU.<br><br>

## 2. SARIMA and SARIMAX<br><br>

Time series forecasting is not a easy task. There is not a "one for all" statistical model. Given that it was difficult to extract useful information of TSU at the aggregate level, we decided to redirect our efforts in the prediction of each product in terms of individual quantities.

We chose to compare the accuracy of the SARIMA (Seasonal Autoregressive Integrated Moving Average) and SARIMAX (Seasonal AutoRegressive Integrated Moving Average with eXogenous regressors) models. As the name indicates, the SARIMAX model takes into account exogenous variables and we decided to explore the number of COVID cases as a exogenous variable.


<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dataframe structure check</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism-themes/1.9.0/prism-material-dark.min.css" rel="stylesheet">
</head>

<body>
<details>
    <summary><b>Click to expand/collapse code</b></summary>
    <pre class="line-numbers"><code class="language-python">from itertools import product    	
	from tqdm import tqdm
	from statsmodels.tsa.statespace.sarimax import SARIMAX
	import xgboost as xgb
	from sklearn.metrics import mean_absolute_error, mean_squared_error

	def filter_and_aggregate_data(df, sender_id, product):
	    """
	    Filters and aggregates the data for a specific hospital and product.
	    """
	    
	    df_filtered = df[(df['SenderLocationID'] == sender_id) & (df['Product'] == product)]
	    df_filtered = df_filtered.groupby('year_month')['Quantity'].sum().sort_index()

	    if df_filtered.empty:
		raise ValueError(f"No data found for SenderLocationID '{sender_id}' and Product '{product}'.")

	    return df_filtered


	def plot_acf_pacf(time_series, seasonal_period):
	    """
	    Plots the ACF and PACF of the time series.
	    """
	    
	    print("Plotting ACF and PACF...")
	    plt.figure(figsize=(12, 6))
	    sm.graphics.tsa.plot_acf(time_series, lags=seasonal_period, ax=plt.subplot(121))
	    sm.graphics.tsa.plot_pacf(time_series, lags=seasonal_period, ax=plt.subplot(122))
	    plt.show()


	def sarima_grid_search(time_series, seasonal_period):
	    """
	    Performs a grid search to find the best SARIMA parameters.
	    """
	    
	    print("Performing SARIMA Grid Search...")
	    p = q = range(0, 3)
	    d = range(0, 2)
	    P = Q = range(0, 3)
	    D = range(0, 2)
	    param_combinations = list(product(p, d, q, P, D, Q))

	    best_params = None
	    best_aic = float("inf")

	    for params in tqdm(param_combinations, desc="Testing SARIMA parameters"):
		try:
		    model = SARIMAX(time_series, 
		                    order=(params[0], params[1], params[2]),
		                    seasonal_order=(params[3], params[4], params[5], seasonal_period))
		    results = model.fit(disp=False)
		    if results.aic < best_aic:
		        best_aic = results.aic
		        best_params = params
		except:
		    continue

	    print(f"Best SARIMA Parameters: {best_params}, AIC: {best_aic}")
	    return best_params, best_aic


	def fit_and_forecast_sarima(time_series, best_params, seasonal_period):
	    """
	    Fits the best SARIMA model and produces a forecast.
	    """
	    
	    print("Fitting Best SARIMA Model...")
	    sarima_model = SARIMAX(time_series, 
		                   order=(best_params[0], best_params[1], best_params[2]),
		                   seasonal_order=(best_params[3], best_params[4], best_params[5], seasonal_period))
	    sarima_results = sarima_model.fit(disp=False)
	    return sarima_results.forecast(steps=seasonal_period)


	def xgboost_forecast(time_series, seasonal_period):
	    """
	    Trains an XGBoost model and produces a forecast.
	    """
	    
	    print("Training XGBoost Model...")
	    lag_features = seasonal_period * 2
	    xgboost_df = pd.DataFrame({'y': time_series})
	    for lag in range(1, lag_features + 1):
		xgboost_df[f'lag_{lag}'] = xgboost_df['y'].shift(lag)

	    xgboost_df.dropna(inplace=True)
	    X = xgboost_df.drop(columns='y')
	    y = xgboost_df['y']

	    train_size = int(len(X) * 0.8)
	    X_train, X_test = X[:train_size], X[train_size:]
	    y_train, y_test = y[:train_size], y[train_size:]

	    xgb_model = xgb.XGBRegressor(objective='reg:squarederror')
	    xgb_model.fit(X_train, y_train)
	    forecast = xgb_model.predict(X_test)

	    return pd.Series(forecast, index=y_test.index)


	def compare_results(time_series, sarima_forecast, xgboost_forecast, seasonal_period):
	    """
	    Compares SARIMA and XGBoost forecasts and calculates evaluation metrics.
	    """
	    
	    metrics = {
		"Model": ["SARIMA", "XGBoost"],
		"MAE": [
		    mean_absolute_error(time_series[-seasonal_period:], sarima_forecast),
		    mean_absolute_error(time_series[-seasonal_period:], xgboost_forecast)
		],
		"RMSE": [
		    mean_squared_error(time_series[-seasonal_period:], sarima_forecast, squared=False),
		    mean_squared_error(time_series[-seasonal_period:], xgboost_forecast, squared=False)
		]
	    }
	    results_df = pd.DataFrame(metrics)

	    summary = (
		f"SARIMA showed an MAE of {metrics['MAE'][0]:.2f} and RMSE of {metrics['RMSE'][0]:.2f}. "
		f"It effectively captured seasonality but may struggle with nonlinear patterns.\n\n"
		f"XGBoost demonstrated an MAE of {metrics['MAE'][1]:.2f} and RMSE of {metrics['RMSE'][1]:.2f}. "
		f"It is flexible with nonlinear data but relies on proper feature engineering."
	    )

	    return results_df, summary
</code></pre>
</details>
<script src="https://cdn.jsdelivr.net/npm/prismjs/prism.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/components/prism-python.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/prismjs/plugins/line-numbers/prism-line-numbers.min.js"></script>
</body>
</html><br>














We used [Prophet](https://facebook.github.io/prophet/) to generate a Plotly dashboard to evaluate the Total Stock Usage (TSU) forecasting for the next 3 months. [Prophet](https://facebook.github.io/prophet/) is a modular regression model useful for time series that have strong seasonal effects and several seasons of historical data, robust to missing data and shifts in the trend, and capable of handling outliers.<br><br>

The example bellow shows the time series of TSU for the medicine fentanyl, a synthetic opioid primarily used as an analgesic or sedative. It was widely used to mantain sedation and suppress the cough reflex of COVID-19 patients with severe respiratory symptoms who required orotracheal intubation.<br><br>

{% include dash.html path="dash.html" %}
<div class="caption">Daily Medicine Usage and forecasting using Prophet(https://facebook.github.io/prophet/). The image above shows the number of units used daily in the hospital as well as the following 90 days.</div><br><br>



Every project has a beautiful feature showcase page.
It's easy to include images in a flexible 3-column grid format.
Make your photos 1/3, 2/3, or full width.

To give your project a background in the portfolio page, just add the img tag to the front matter like so:

    ---
    layout: page
    title: project
    description: a project with a background image
    img: /assets/img/12.jpg
    ---

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/1.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/3.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/5.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Caption photos easily. On the left, a road goes through a tunnel. Middle, leaves artistically fall in a hipster photoshoot. Right, in another hipster photoshoot, a lumberjack grasps a handful of pine needles.
</div>
<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.html path="assets/img/5.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    This image can also have a caption. It's like magic.
</div>

You can also put regular text between your rows of images.
Say you wanted to write a little bit about your project before you posted the rest of the images.
You describe how you toiled, sweated, *bled* for your project, and then... you reveal its glory in the next row of images.


<div class="row justify-content-sm-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.html path="assets/img/6.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.html path="assets/img/11.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    You can also have artistically styled 2/3 + 1/3 images, like these.
</div>


The code is simple.
Just wrap your images with `<div class="col-sm">` and place them inside `<div class="row">` (read more about the <a href="https://getbootstrap.com/docs/4.4/layout/grid/">Bootstrap Grid</a> system).
To make images responsive, add `img-fluid` class to each; for rounded corners and shadows use `rounded` and `z-depth-1` classes.
Here's the code for the last row of images above:

{% raw %}
```html
<div class="row justify-content-sm-center">
    <div class="col-sm-8 mt-3 mt-md-0">
        {% include figure.html path="assets/img/6.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm-4 mt-3 mt-md-0">
        {% include figure.html path="assets/img/11.jpg" title="example image" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
```
{% endraw %}
