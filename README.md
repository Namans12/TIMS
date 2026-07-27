# TIMS — Inventory Demand Prediction

Flask web app that predicts product demand levels from a random forest trained on historical inventory and order data, backed by MySQL.

> **Note:** this repository previously contained a `README.txt` holding database credentials in plain text. Nothing in the code reads them — `backend.py` connects to no database — so they were stale notes rather than live configuration. They have been replaced by this file.

## Overview

Given a year, month, product, and supplier, the model classifies expected demand into a level. Training happens offline in `demand_model.py`, which serialises the classifier and its label encoders to `.pkl` files; the Flask app loads those and serves predictions through a single form.

The MySQL side holds the inventory schema and the source data the model was trained from.

## Features

- Demand-level prediction from year, month, product, and supplier
- Random forest classifier with label encoders for each categorical input
- Single-page Flask form and result view
- MySQL inventory schema with products, suppliers, orders, and order items
- Committed dataset and SQL dumps, so the model can be retrained from scratch
- Six analysis queries over the inventory data

## Tech Stack

Python · Flask · scikit-learn (random forest) · pandas · joblib · MySQL

## Prerequisites

- Python 3.8+
- MySQL, only if you want to work with the database side — the Flask app itself does not connect to it

## Installation

```bash
git clone https://github.com/Namans12/TIMS.git
cd TIMS
pip install flask scikit-learn pandas joblib numpy
```

### Database (optional)

```bash
mysql -u <user> -p < database_structure.sql
mysql -u <user> -p <database> < database_backup.sql
```

`database_structure.sql` creates four tables — `products`, `suppliers`, `orders`, `orderitems`. `database_backup.sql` populates them.

## Usage

### Train the model

```bash
python demand_model.py
```

Reads `product_dataset.csv` and writes five artefacts:

- `random_forest_model.pkl`
- `month_encoder.pkl`
- `product_encoder.pkl`
- `supplier_encoder.pkl`
- `demand_level_encoder.pkl`

**Run this first.** The repository ships the four encoders but **not** `random_forest_model.pkl`, so `backend.py` will fail to start until training has produced it.

### Serve predictions

```bash
python backend.py
```

Flask starts on <http://localhost:5000> in debug mode. Fill in year, month, product, and supplier; the page returns the predicted demand level.

## How it works

```
product_dataset.csv
        │
        ▼
demand_model.py ──► random_forest_model.pkl + 4 encoders
                            │
                            ▼
                      backend.py  (Flask)
                            │
                            ▼
                     templates/abc.html
```

Each categorical input is label-encoded with the encoder fitted during training, so the encoders must stay paired with the model that was trained alongside them. Retraining regenerates all five together.

## Project Structure

```
backend.py                 Flask app — loads the pickles, serves / and /predict
demand_model.py            training script
abc.html                   prediction form and result page
product_dataset.csv        training data (~450 KB)

database_structure.sql     schema — products, suppliers, orders, orderitems
database_backup.sql        data dump (~124 KB)
Inventory_Product.csv      product data
Inventory_Supplier.csv     supplier data
Inventory_Order.csv        order data

Query1.sql … Query6.sql    analysis queries

month_encoder.pkl          fitted label encoders
product_encoder.pkl
supplier_encoder.pkl
demand_level_encoder.pkl
```

## Notes and limitations

- **`app.run(debug=True)`** is fine locally but must not be used in production — it exposes the Werkzeug debugger
- **`abc.html` sits at the repository root**, while Flask's `render_template` looks in `templates/`. Move it into `templates/` if rendering fails
- No input validation — submitting a product or supplier the encoders never saw raises rather than reporting a useful error
- No train/test split reported, so accuracy is unmeasured
- Single-user, no authentication
