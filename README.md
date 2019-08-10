# Credit Card Fraud Detection  

Project to classify credit card transactions as fraudulent. Part of Kaggle competition. Data exploration done in R and machine learning done in python. 

## Important File List

 * data_description.txt - descriptions for data features from kaggle
 * Housing_Data_EDA.rmd - R markdown file for initial data EDA
 * Keleher_model_compare.ipynb – Reads in all datasets and fits a Lasso and XGBoost model for each with 10 fold cross validation. The datasets were generated in Clean_code_Datasets.ipynb
 * Clean_code_Datasets.ipynb – Generates different datasets from Kaggle data using various feature engineer techniques
 * clustering_categoric_features.ipynb – Performs Agglomerative clustering on different levels of categoric features and subsequently reduces dimensionality by merging levels 
 * Model_Validation_final.ipynb – validates the models found in Keleher_model_compare.ipynb
