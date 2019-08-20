# Credit Card Fraud Detection  

Project to classify credit card transactions as fraudulent. Part of Kaggle competition. Data exploration done in R and machine learning done in python. 

## Important Files and Folders List

 * Data_EDA.R – Data visualization code. Done with dplyr and ggplot
 * XGBoost_Model.py – XGBoost classify model. Also includes data cleaning and feature engineering
 * cv_50_50.py – Python fie containing a function for custom data splitting in cross validation. Function samples CV training data from first half of total training dataset and CV test data from second half of total training dataset. This is in attempt to mimic the actual training and test sets in the Kaggle competition. 
 * process_specifics.py – Python file contains functions to bin categorial data based on correlation with fraud and the frequency of the category. 
 * XGBoost_Model_kaggle_code.py – Based on XGBoost_Model.py but with extra features found in Kaggle kernels. Credit to authors is in comments. 
 * data – Contains data for IEEE-CIS Fraud Detection competition. Downloadable from Kaggle.com.
 * plots – Output folder for EDA plots created in Data_EDA.R script.
 

