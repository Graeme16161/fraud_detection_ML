# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
import numpy as np

#read training data
train_identity = pd.read_csv('../data/train_identity.csv',
                             index_col='TransactionID')
train_transaction = pd.read_csv('../data/train_transaction.csv',
                                index_col='TransactionID')

#read testing data
test_identity = pd.read_csv('../data/test_identity.csv',
                            index_col='TransactionID')
test_transaction = pd.read_csv('../data/test_transaction.csv',
                               index_col='TransactionID')

#read in submission format
submission_format = pd.read_csv('../data/sample_submission.csv',
                             index_col='TransactionID')

print("Data loading finished")

#Merge identity and transaction datasets from tain and test
train  = train_transaction.merge(train_identity, how = "left",
                                 left_index = True, right_index = True)
del train_identity,train_transaction


test  = test_transaction.merge(test_identity, how = "left",
                               left_index = True, right_index = True)
del test_identity,test_transaction

print("identity and transaction data frames have been merged")

#### use 5% of data to star (comment out to actually run)
train = train.sample(frac = .05)
test = test.sample(frac = .05)

print("Data reduced to 5%!!!")

# new feature based on email domains
def domains_process(row): 
    if pd.isnull(row['P_emaildomain']) and pd.isnull(row['R_emaildomain']):
        return "Both_Missing"
    elif pd.isnull(row['P_emaildomain']):
        return "P_Missing"
    elif pd.isnull(row['R_emaildomain']):
        return "R_Missing"
    elif row['P_emaildomain'] == row['R_emaildomain']:
        return("Same_Emails")
    else:
        return("Different_Emails")

train['email_status'] = train.apply(domains_process, axis=1)
test['email_status'] = test.apply(domains_process, axis=1)

print("Email domain feature created")

# seperate domains into levels of risk

def domain_risk(row):
    




##create target, training and testing data frames
target = train['IsFraud'].copy()

X_train = train.drop('isFraud', axis = 1)
X_test = test.copy()
del test, train

print("Data converted to X and target data frames")

##

