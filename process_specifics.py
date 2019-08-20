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
def process_size_row(cat, buckets):
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
        return "missing"
    
def process_risk_row(cat, buckets):
    r0 = buckets[0]
    r1 = buckets[1]
    r2 = buckets[2]
    r3 = buckets[3]
    r4 = buckets[4]
    r5 = buckets[5]
    r6 = buckets[6]
    
    if cat in r0:
        return "r0"
    elif cat in r1:
        return "r1"
    elif cat in r2:
        return "r2"
    elif cat in r3:
        return "r3"
    elif cat in r4:
        return "r4"
    elif cat in r5:
        return "r5"
    elif cat in r6:
        return "r6"
    else:
        return "missing"

def process_buckets(train, test, feature):
    
    n = train.groupby(by =feature).size()
    risk = train.groupby(by = feature)['isFraud'].mean()*100
    
    n_and_risk = pd.DataFrame({"n" : n,
                               "risk": risk})
    
    total = n_and_risk.n.sum()
    
    s1 = list(n_and_risk[n_and_risk.n < total/1000].index)
    s2 = list(n_and_risk[(n_and_risk.n > total/1000) & (n_and_risk.n < total/100)].index)
    s3 = list(n_and_risk[(n_and_risk.n > total/100) & (n_and_risk.n < total/10)].index)
    s4 = list(n_and_risk[n_and_risk.n > total/10].index)
    
    train_buckets = [s1,s2,s3,s4]
    
    r0 = list(n_and_risk[n_and_risk.risk <= 2.8].index)
    r1 = list(n_and_risk[(n_and_risk.risk > 2.8) & (n_and_risk.risk <= 5)].index)
    r2 = list(n_and_risk[(n_and_risk.risk > 5) & (n_and_risk.risk <= 10)].index)
    r3 = list(n_and_risk[(n_and_risk.risk > 10) & (n_and_risk.risk <= 20)].index)
    r4 = list(n_and_risk[(n_and_risk.risk > 20) & (n_and_risk.risk <= 50)].index)
    r5 = list(n_and_risk[(n_and_risk.risk > 50) & (n_and_risk.risk <= 80)].index)
    r6 = list(n_and_risk[n_and_risk.risk > 80].index)
    
    risk_buckets = [r0,r1,r2,r3,r4,r5,r6]
    
    
    #test
    n = test.groupby(by = feature).size()
    n_and_risk = pd.DataFrame({"n" : n})
    
    total = n_and_risk.n.sum()
    
    s1 = list(n_and_risk[n_and_risk.n < total/1000].index)
    s2 = list(n_and_risk[(n_and_risk.n > total/1000) & (n_and_risk.n < total/100)].index)
    s3 = list(n_and_risk[(n_and_risk.n > total/100) & (n_and_risk.n < total/10)].index)
    s4 = list(n_and_risk[n_and_risk.n > total/10].index)
    
    test_buckets = [s1,s2,s3,s4]
    
    return(train_buckets, test_buckets, risk_buckets)
    

    
    
    
    
