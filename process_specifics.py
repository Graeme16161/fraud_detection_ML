# -*- coding: utf-8 -*-
"""
Created on Fri Aug 16 10:51:28 2019

@author: gakel
"""

#these functions are for binning versions of categorical variab
#point is to stop data bleeding
#also deal with unseen versions in test data


import pandas as pd
#want to 
feature = 'P_emaildomain'

n = train.groupby(by = feature).size()
risk = train.groupby(by = feature)['isFraud'].mean()*100

n_and_risk = pd.DataFrame({"n" : n,
                           "fraud_per": risk})

smallest = list(n_and_risk[n_and_risk.n < 100].index)


def process_specifics(train, test, feature):
    
