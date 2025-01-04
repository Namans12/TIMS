import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
from imblearn.over_sampling import SMOTE
import joblib

# Load the dataset
df = pd.read_csv("product_dataset.csv")

# Encode categorical features
month_encoder = LabelEncoder()
product_encoder = LabelEncoder()
supplier_encoder = LabelEncoder()

df['Month'] = month_encoder.fit_transform(df['Month'])
df['Product Name'] = product_encoder.fit_transform(df['Product Name'])
df['Supplier'] = supplier_encoder.fit_transform(df['Supplier'])

# Encode target variable 'Demand Level'
demand_level_encoder = LabelEncoder()
df['Demand Level'] = demand_level_encoder.fit_transform(df['Demand Level'])

# Prepare features and target
X = df[['Year', 'Month', 'Product Name', 'Supplier']]
y = df['Demand Level']

# Handle class imbalance using SMOTE
smote = SMOTE(random_state=42)
X_res, y_res = smote.fit_resample(X, y)

# Train the Random Forest Classifier
rf = RandomForestClassifier(random_state=42)
rf.fit(X_res, y_res)

# Save the trained model and encoders
joblib.dump(rf, 'random_forest_model.pkl')
joblib.dump(month_encoder, 'month_encoder.pkl')
joblib.dump(product_encoder, 'product_encoder.pkl')
joblib.dump(supplier_encoder, 'supplier_encoder.pkl')
joblib.dump(demand_level_encoder, 'demand_level_encoder.pkl')

print("Model and encoders saved successfully!")
