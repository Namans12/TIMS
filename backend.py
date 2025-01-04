from flask import Flask, render_template, request
import joblib
import numpy as np

# Initialize Flask app
app = Flask(__name__)

# Load the trained model and encoders
rf = joblib.load('random_forest_model.pkl')
month_encoder = joblib.load('month_encoder.pkl')
product_encoder = joblib.load('product_encoder.pkl')
supplier_encoder = joblib.load('supplier_encoder.pkl')
demand_level_encoder = joblib.load('demand_level_encoder.pkl')

# Home route
@app.route('/')
def home():
    return render_template('abc.html')

# Prediction route
@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':
        # Extract input values from the form
        year = int(request.form['year'])
        month = request.form['month']
        product_name = request.form['product_name']
        supplier = request.form['supplier']
        
        # Encode the inputs
        month_encoded = month_encoder.transform([month])[0]
        product_name_encoded = product_encoder.transform([product_name])[0]
        supplier_encoded = supplier_encoder.transform([supplier])[0]
        
        # Prepare the input for prediction
        input_data = np.array([[year, month_encoded, product_name_encoded, supplier_encoded]])
        
        # Predict demand level
        demand_level_encoded = rf.predict(input_data)[0]
        demand_level = demand_level_encoder.inverse_transform([demand_level_encoded])[0]
        
        return render_template('abc.html', prediction=demand_level)

if __name__ == "__main__":
    app.run(debug=True)
