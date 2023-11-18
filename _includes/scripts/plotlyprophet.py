import pandas as pd
import numpy as np
import plotly.express as px
from prophet import Prophet
from prophet.plot import plot_plotly
from dash import Dash, html, dcc, callback, Input, Output
from dash.exceptions import PreventUpdate

hospitals_df = pd.read_csv("hospitals_palivizumab.csv")

df = hospitals_df

# Create a Dash web application
app = Dash(__name__)

# Define the layout of the dashboard
app.layout = html.Div(
    [
        # Dropdown for hospital selection
        dcc.Dropdown(
            id="hospital-dropdown",
            options=[
                {"label": selected_hospital, "value": selected_hospital}
                for selected_hospital in df["SenderLocationID"].unique()
            ],
            value=sorted(df["SenderLocationID"].unique())[
                0
            ],  # Set the default value to the first hospital
            multi=False,
            style={"width": "50%"},
        ),
        # Dropdown for product selection
        dcc.Dropdown(
            id="product-dropdown",
            options=[
                {"label": product, "value": product}
                for product in sorted(df["Product"].unique())
            ],
            value=sorted(df["Product"].unique())[0],
            multi=False,
            style={"width": "50%"},
        ),
        # Graph to display time series and forecast
        dcc.Graph(id="forecast-graph"),
    ]
)


# Define callback to update product dropdown based on selected hospital
@app.callback(
    Output("product-dropdown", "options"), [Input("hospital-dropdown", "value")]
)
def update_product_dropdown(selected_hospital):
    products = df[df["SenderLocationID"] == selected_hospital]["Product"].unique()
    return [{"label": product, "value": product} for product in products]


# Define callback to update graph based on selected hospital and product
@app.callback(
    Output("forecast-graph", "figure"),
    [Input("hospital-dropdown", "value"), Input("product-dropdown", "value")],
)
def update_graph(selected_hospital, product):
    if selected_hospital is None or product is None:
        raise PreventUpdate

    # Filter data based on selected hospital and product
    selected_data = df[
        (df["SenderLocationID"] == selected_hospital) & (df["Product"] == product)
    ]

    # Prepare data for fbprophet
    prophet_df = selected_data[["Date", "StockValue"]]
    prophet_df.columns = ["ds", "y"]

    # Initialize and fit the Prophet model
    model = Prophet()
    model.fit(prophet_df)

    # Create future dataframe for forecasting
    future = model.make_future_dataframe(periods=3, freq="M")

    # Make predictions
    forecast = model.predict(future)

    # Plot the time series and forecast
    fig = plot_plotly(model, forecast)

    fig.update_layout(
        title=f"Total stock usage (TSU) and Forecast<br>{selected_hospital} - {product}",
        yaxis_title="TSU ($)",
        title_x=0.5,
        title_y=0.95,
    )

    return fig


# Run the app
if __name__ == "__main__":
    app.run_server(debug=True)
