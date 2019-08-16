# -*- coding: utf-8 -*-
"""
Created on Fri Aug 16 09:42:12 2019

@author: gakel
"""
#from foreign_code import useful_function
#with foreign_code.py
#function to return iteretor for grid serach cv


import numpy as np

def cv_50_50(n, folds = 3):
    mid = int(n/2)
    size = int(mid*(folds - 1)/folds)
    cv_indices = []
    
    for i in range(3):
        train_indices = np.random.choice(range(mid),size = size, replace = False)
        test_indices = np.random.choice(range(mid,n),size = size, replace = False)
        
        cv_indices.append((train_indices,test_indices))
        
    return(cv_indices)
        
    
    