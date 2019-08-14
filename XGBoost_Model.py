# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd

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

print("Data read in")

#Merge identity and transaction datasets from tain and test
train  = train_transaction.merge(train_identity, how = "left",
                                 left_index = True, right_index = True)
del train_identity,train_transaction


test  = test_transaction.merge(test_identity, how = "left",
                               left_index = True, right_index = True)
del test_identity,test_transaction

print("identity and transaction data frames have been merged")

target = train['IsFraud'].copy()

