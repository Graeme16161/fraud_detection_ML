# -*- coding: utf-8 -*-
"""
Created on Fri Aug 16 10:51:28 2019

@author: gakel
"""

#these functions are for binning versions of categorical variab
#point is to stop data bleeding
#also deal with unseen versions in test data


import pandas as pd

#df['events'] = df['data'].apply(count_ones, total_bits=60, group_size=12)
#second two are arguements to count_ones function, first arguement is in df



#for using with pandas apply function
def process_row(cat, buckets):
    s1 = buckets[0]
    s2 = buckets[1]
    s3 = buckets[2]
    s4 = buckets[3]
    
    if cat in s1:
        return "s1"
    elif cat in s2:
        return "s2"
    elif cat in s3:
        return "s3"
    elif cat in s4:
        return "s4"
    else:
        return "other"

def process_size_buckets(train, test, feature):
    
    n = train.groupby(by =feature).size()
    risk = train.groupby(by = feature)['isFraud'].mean()*100
    
    n_and_risk = pd.DataFrame({"n" : n,
                               "fraud_per": risk})
    
    total = n_and_risk.n.sum()
    
    s1 = list(n_and_risk[n_and_risk.n < total/1000].index)
    s2 = list(n_and_risk[(n_and_risk.n > total/1000) & (n_and_risk.n < total/100)].index)
    s3 = list(n_and_risk[(n_and_risk.n > total/100) & (n_and_risk.n < total/10)].index)
    s4 = list(n_and_risk[n_and_risk.n > total/10].index)
    
    train_buckets = [s1,s2,s3,s4]
    
    n = test.groupby(by = feature).size()
    risk = test.groupby(by = feature)['isFraud'].mean()*100
    
    n_and_risk = pd.DataFrame({"n" : n,
                               "fraud_per": risk})
    
    total = n_and_risk.n.sum()
    
    s1 = list(n_and_risk[n_and_risk.n < total/1000].index)
    s2 = list(n_and_risk[(n_and_risk.n > total/1000) & (n_and_risk.n < total/100)].index)
    s3 = list(n_and_risk[(n_and_risk.n > total/100) & (n_and_risk.n < total/10)].index)
    s4 = list(n_and_risk[n_and_risk.n > total/10].index)
    
    test_buckets = [s1,s2,s3,s4]
    
    return(train_buckets, test_buckets)
    
    

    
    
    
    
