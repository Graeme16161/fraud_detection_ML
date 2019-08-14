# -*- coding: utf-8 -*-
"""
Spyder Editor

This is a temporary script file.
"""

import pandas as pd
import os

os.chdir('C:/Users/gakel/Documents/Bootcamp/Capstone')

#read training data
train_identity = pd.read_csv('data/train_identity.csv',
                             index_col='TransactionID')
train_transaction = pd.read_csv('data/train_transaction.csv',
                                index_col='TransactionID')

#read testing data
test_identity = pd.read_csv('data/test_identity.csv',
                            index_col='TransactionID')
test_transaction = pd.read_csv('data/test_transaction.csv',
                               index_col='TransactionID')

#read in submission format
submission_format = pd.read_csv('data/sample_submission.csv',
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

extreme_emails = ["protonmail.com"]
very_high_emails = ["mail.com"]
high_emails = ["outlook.es","aim.com","outlook.com","netzero.net","icloud"]
medium_emails = ["hotmail.es","live.com.mx","hotmail.com","gmail.com"]


def P_domain_risk(row):
    if row['P_emaildomain'] in extreme_emails:
        return "Extreme"
    elif row['P_emaildomain'] in very_high_emails:
        return "Very_high"
    elif row['P_emaildomain'] in high_emails:
        return "high"
    elif row['P_emaildomain'] in medium_emails:
        return "medium"
    else:
        return "nominal"
    
def R_domain_risk(row):
    if row['R_emaildomain'] in extreme_emails:
        return "Extreme"
    elif row['R_emaildomain'] in very_high_emails:
        return "Very_high"
    elif row['R_emaildomain'] in high_emails:
        return "high"
    elif row['R_emaildomain'] in medium_emails:
        return "medium"
    else:
        return "nominal"

train['R_email_risk'] = train.apply(R_domain_risk, axis=1)
test['R_email_risk'] = test.apply(R_domain_risk, axis=1)

train['P_email_risk'] = train.apply(P_domain_risk, axis=1)
test['P_email_risk'] = test.apply(P_domain_risk, axis=1)

train.drop(['R_emaildomain', 'P_emaildomain'], axis=1, inplace = True)
test.drop(['R_emaildomain', 'P_emaildomain'], axis=1, inplace = True)

print("Email domain risk assigned")

#create pixal feature
new = train["id_33"].str.split("x", n = 1, expand = True).fillna(0)
train["pixel_n"]= new[0].astype(int) * new[1].astype(int)
train.drop(columns =["id_33"], inplace = True) 

new = test["id_33"].str.split("x", n = 1, expand = True).fillna(0)
test["pixel_n"]= new[0].astype(int) * new[1].astype(int)
test.drop(columns =["id_33"], inplace = True) 

print("Screen Size Data Converted to Pixels")


#id_31 which is browser
recent_browsers = ["samsung browser 7.0",
                  "opera 53.0",
                  "mobile safari 10.0",
                  "google search application 49.0",
                  "firefox 60.0",
                  "edge 17.0",
                  "chrome 69.0",
                  "chrome 67.0 for android",
                  "chrome 63.0",
                  "chrome 63.0 for android",
                  "chrome 63.0 for ios",
                  "chrome 64.0",
                  "chrome 64.0 for android",
                  "chrome 64.0 for ios",
                  "chrome 65.0",
                  "chrome 65.0 for android",
                  "chrome 65.0 for ios",
                  "chrome 66.0",
                  "chrome 66.0 for android",
                  "chrome 66.0 for ios",
                  "chrome generic",
                  "chrome generic for android"]


def browser_process(row):
    if row['id_31'] in recent_browsers:
        return "recent"
    else:
        return "other"

train['browser_status'] = train.apply(browser_process, axis=1)
test['browser_status'] = test.apply(browser_process, axis=1)

train.drop('id_31', axis=1, inplace = True)
test.drop('id_31', axis=1, inplace = True)

print("Browser status assigned")


#id_30 which is operating system

highest_risk_os = ['Android 5.1.1',
                'Android 4.4.2']

small_high_risk_os = ['Android 7.1.2',
                      'Mac OS X 10_12_1',
                      'iOS 11.0.1',
                      'iOS 11.1.0',
                      'iOS 11.2.2',
                      'Windows 8',
                      'Android 7.1.1']

big_higher_risk_os = ['iOS 11.2.5',
                      'iOS 11.2.2',
                      'Android',
                      'Linux',
                      'Windows 8.1',
                      'iOS 11.3.0',
                      'Android 7.0']

def os_process(row):
    if row['id_30'] in small_high_risk_os:
        return "small_high"
    elif row['id_30'] in big_higher_risk_os:
        return "big_higher"
    elif row['id_30'] in highest_risk_os:
        return "highest"
    else:
        return "other"

train['os_risk'] = train.apply(os_process, axis=1)
test['os_risk'] = test.apply(os_process, axis=1)

train.drop('id_30', axis=1, inplace = True)
test.drop('id_30', axis=1, inplace = True)

print("OS Risk assigned")

#Device Info

highest_risk_d = ['SM-N920A Build/MMB29K',
                'VS5012 Build/NRD90M',
                'Z835 Build/NMF26V',
                'LG-D320 Build/KOT49I.V10a',
                'TA-1039 Build/NMF26F',
                'VS425PP Build/LMY47V',
                'SM-A510M Build/MMB29K',
                'KFFOWI Build/LVY48F',
                'CRO-L03 Build/HUAWEICRO-L03',
                'SM-G920P Build/NRD90M',
                'SAMSUNG SM-J120H Build/LMY47V',
                'SAMSUNG SM-G891A Build/NRD90M',
                'SM-G530H Build/KTU84P',
                'Moto G (5) Plus Build/NPNS25.137-15-11',
                'TA-1038 Build/NMF26O',
                'LG-H650 Build/MRA58K',
                'Hisense L675 Build/MRA58K',
                'moto x4 Build/OPWS27.57-40-6',
                'E6603 Build/32.4.A.1.54',
                'F5121 Build/34.3.A.0.238']

small_med_risk_d = ['F5121 Build/34.3.A.0.252',
                      'SM-J500M Build/LMY48B',
                      'LG-D680 Build/KOT49I',
                      'CHC-U03 Build/HuaweiCHC-U03',
                      'SM-J105B Build/LMY47V',
                      'SAMSUNG SM-J327T1 Build/NRD90M',
                      'SM-G9600 Build/R16NW',
                      'Moto G (5) Plus Build/NPN25.137-82',
                      'SM-J327T1 Build/NRD90M',
                      'Blade A510 Build/MRA58K',
                      'Blade L2 Plus Build/KOT49H',
                      'Moto G Play Build/MPIS24.241-15.3-26',
                      'M4 SS4456 Build/LMY47V',
                      'SM-J327P Build/MMB29M',
                      'RNE-L03 Build/HUAWEIRNE-L03',
                      'SM-J320M Build/LMY47V',
                      'GT-I9060M Build/KTU84P',
                      'LG-H320 Build/LRX21Y',
                      'SM-G550T1 Build/MMB29K',
                      'SM-J727T1 Build/NRD90M',
                      'MotoG3 Build/MPIS24.65-33.1-2-16']

small_high_risk_d = ['hi6210sft Build/MRA58K',
                      'SM-A300H Build/LRX22G']

big_higher_risk_d = ['Windows',
                      'iOS Device']

def device_info_process(row):
    if row['DeviceInfo'] in small_high_risk_d:
        return "small_high"
    elif row['DeviceInfo'] in big_higher_risk_d:
        return "big_higher"
    elif row['DeviceInfo'] in small_med_risk_d:
        return "small_med"
    elif row['DeviceInfo'] in highest_risk_d:
        return "highest"
    else:
        return "other"

train['device_info_risk'] = train.apply(device_info_process, axis=1)
test['device_info_risk'] = test.apply(device_info_process, axis=1)

train.drop('DeviceInfo', axis=1, inplace = True)
test.drop('DeviceInfo', axis=1, inplace = True)

print("Device Info Risk assigned")



#########################################################################################
##create target, training and testing data frames
target = train['isFraud'].copy()

X_train = train.drop('isFraud', axis = 1)
X_test = test.copy()
del test, train

print("Data converted to X and target data frames")

X_train = pd.get_dummies(X_train,dummy_na = True)
X_test = pd.get_dummies(X_test,dummy_na = True)

# find dummy features in train set but not test
missing_cols = set( X_train.columns ) - set( X_test.columns )
# Afill missing columns with zero
for c in missing_cols:
    X_test[c] = 0
# keep order the same
X_test = X_test[X_train.columns]

print("Dummification Complete")

### set nans to -999
