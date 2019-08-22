library(tidyverse)
library(scales)

setwd('C:/Users/gakel/Documents/Bootcamp/Capstone')

train_identity <- read_csv("data/train_identity.csv")
test_transaction <- read_csv("data/test_transaction.csv")

train_transaction <- read_csv("data/train_transaction.csv")


all_DT <- bind_rows(train_transaction, test_transaction)

g <- all_DT %>%
  ggplot(aes(TransactionDT))+
  geom_histogram(bins = 100)+
  labs(title = "Training Vs Test Sets",
       y = "Count",
       x = "Transaction Time (In Seconds)")+ 
  scale_x_continuous(labels = comma)

train_transaction <- left_join(train_transaction,train_identity, by = 'TransactionID')

ggsave("plots/time_vis.jpeg",plot = g,dpi = 320, width = 8, height = 4)
#ggsave("plots/missing_data.jpeg",plot = g,dpi = 320, width = 8, height = 4)

# distribution of target feature
g <- train_transaction %>%
  group_by(isFraud)%>%
  summarise(count = n())%>%
  mutate(isFraud1 = ifelse(isFraud == 0,"No","Yes"))%>%
  ggplot(aes(isFraud1,count)) +
  geom_bar(stat = "identity",width = .5)+
  labs(title = "Target Variable Class Distribution",
       y = "Count",
       x = "Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=count),  size=3.5, nudge_y = 20000) 

ggsave("plots/target_class_distribution.jpeg",plot = g,dpi = 320, width = 8, height = 4)

#Distribution of transaction amount
ggplot(train_transaction,aes(TransactionAmt))+
  geom_histogram()+
  labs(title = "Distribution of Transaction Size (log10)",
       y = "Count",
       x = "Transaction Amount (USD)")+ 
  scale_y_continuous(labels = comma)+ 
  scale_x_log10()

# distribution of card type (card4)
g <- train_transaction %>%
  group_by(card4)%>%
  summarise(count = n())%>%
  ggplot(aes(card4,count)) +
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Card Type Used",
       y = "Count",
       x = "")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=count),  size=3.5, nudge_y = 25000) 

ggsave("plots/cards_by_count.jpeg",plot = g,dpi = 320, width = 8, height = 4)

g <- train_transaction %>%
  group_by(card4) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(reorder(reorder(card4,percent_fraud),percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Card Type by Fraud Percentage",
       x = "",
       y = "Percentage of Transactions that are Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .4)

ggsave("plots/cards_by_percent_fraud.jpeg",plot = g,dpi = 320, width = 8, height = 4)

# distribution of transaction type (card6)
train_transaction %>%
  group_by(card6)%>%
  summarise(count = n())%>%
  ggplot(aes(card6,count)) +
  geom_bar(stat = "identity",width = .5)+
  coord_flip()+
  labs(title = "Transaction Type Counts",
       y = "Count",
       x = "")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=count),  size=3.5, nudge_y = 25000) 

g <- train_transaction %>%
  group_by(card6) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(reorder(reorder(card6,percent_fraud),percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Transaction Type by Percentage that are",
       x = "",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .4)

ggsave("plots/transaction_by_percent_fraud.jpeg",plot = g,dpi = 320, width = 8, height = 4)

# distribution of device type
train_identity %>%
  group_by(DeviceType)%>%
  summarise(count = n())%>%
  ggplot(aes(DeviceType,count)) +
  geom_bar(stat = "identity",width = .5)+
  labs(title = "Device Type",
       y = "Count",
       x = "Device Type")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=count),  size=3.5, nudge_y = 5000)

#email domain feature
train_transaction %>%
  group_by(P_emaildomain) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  arrange(desc(percent_fraud))%>%
  top_n(30,desc(percent_fraud)) %>%
  ggplot(aes(reorder(P_emaildomain,percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Purchaser Domain by Fraud Percentage (Top 15)",
       y = "",
       x = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=total),  size=3.5, nudge_y = 2)


g <- train_transaction %>%
  group_by(R_emaildomain) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  arrange(desc(percent_fraud))%>%
  top_n(15,percent_fraud) %>%
  ggplot(aes(reorder(R_emaildomain,percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Recipient Domain by Fraud Percentage (Top 15)",
       x = "",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = 4)

ggsave("plots/R_domain_fraud.jpeg",plot = g,dpi = 320, width = 8, height = 4)

g <- train_transaction %>%
  group_by(R_emaildomain) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(percent_fraud))+
  geom_histogram()+
  labs(title = "Recipient Domain by Fraud Percentage Histogram",
       y = "Count",
       x = "Percentage Fraud")

ggsave("plots/R_domain_fraud_hist.jpeg",plot = g,dpi = 320, width = 8, height = 4)

## email situatoin
email_sit <- function(P, R) {
  case_when(
    is.na(P) & is.na(R) ~ "Both\n Emails Missing",
    is.na(P)        ~ "Only Purchaser \nEmail Missing",
    is.na(R)       ~ "Only Recipient \nEmail MIssing",
    P ==  R        ~ "Same Emails",
    P != R         ~ "Different Emails"
  )
}

g <- train_transaction %>%
  select(isFraud,R_emaildomain,P_emaildomain)%>%
  mutate(emails = email_sit(P_emaildomain, R_emaildomain))%>%
  group_by(emails)%>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(emails,percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Email Information by Fraud Percentage",
       x = "",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .5)

ggsave("plots/email_status_fraud.jpeg",plot = g,dpi = 320, width = 8, height = 4)


train_transaction %>%
  select(isFraud,R_emaildomain,P_emaildomain)%>%
  mutate(emails = email_sit(P_emaildomain, R_emaildomain))%>%
  group_by(emails)%>%
  summarise(count = n())%>%
  ggplot(aes(emails,count)) +
  geom_bar(stat = "identity",width = .5)+
  coord_flip()+
  labs(title = "Email Info",
       y = "Count",
       x = "Email Info")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=count),  size=3.5, nudge_y = 20000)



#id_30
t = train_transaction %>%
  group_by(id_30) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  filter(total > 20)%>%
  arrange(desc(percent_fraud))%>%
  top_n(30,percent_fraud) %>%
  ggplot(aes(reorder(id_30,percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "id_31 by Fraud Percentage (Top 30)",
       y = "",
       x = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=total),  size=3.5, nudge_y = 2)

train_transaction%>%
  select(id_33,isFraud)%>%
  drop_na()%>%
  separate(id_33, c("L","W"),sep = "x")%>%
  mutate(pixels = as.numeric(L)*as.numeric(W))%>%
  group_by(isFraud)%>%
  summarise(m = mean(pixels))



#device info
t = train_transaction %>%
  group_by(DeviceInfo) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  filter(total > 20)%>%
  arrange(desc(percent_fraud))%>%
  top_n(30,percent_fraud) %>%
  ggplot(aes(reorder(DeviceInfo,percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "id_31 by Fraud Percentage (Top 30)",
       y = "",
       x = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=total),  size=3.5, nudge_y = 2)


#train['Transaction_day_of_week'] = np.floor((train['TransactionDT'] / (3600 * 24) - 1) % 7)


g <- train_transaction %>%
  mutate(dow = floor((TransactionDT/ (3600 * 24) - 1) %% 7))%>%
  group_by(dow)%>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(dow,percent_fraud))+
  geom_bar(stat = "identity")+
  labs(title = "Day of Week by Fraud Percentage",
       x = "Day of Week",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .2)

ggsave("plots/dow_fraud.jpeg",plot = g,dpi = 320, width = 8, height = 4)


g <- train_transaction %>%
  mutate(hod = floor((TransactionDT/3600) %% 24))%>%
  group_by(hod)%>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(hod,percent_fraud))+
  geom_bar(stat = "identity")+
  labs(title = "Hour of Day by Transaction Fraud Percentage",
       x = "Hour of Day",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .3)

ggsave("plots/hod_fraud.jpeg",plot = g,dpi = 320, width = 8, height = 4)



######### histogram feautres by percent missing
g <- train_transaction %>% 
  summarise_each(funs(100*mean(is.na(.))))%>%
  gather("column","Percentage_Missing")%>%
  ggplot(aes(Percentage_Missing))+
  geom_histogram()+
  labs(title = "Histogram of Feature Missingness",
       x = "Features by Percentage of Observations Missing",
       y = "Count")
  
ggsave("plots/feature_missing.jpeg",plot = g,dpi = 320, width = 8, height = 4)


##### look for pattern shift with time

g <- train_transaction %>%
  mutate(bin = cut_interval(TransactionDT, 40))%>%
  group_by(bin) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(bin,percent_fraud))+
  geom_bar(stat = "identity")+
  labs(title = "Percentage of Fraudulent Transactions Through Time",
       x = "Sequential Time Bins of Equal Interval",
       y = "Percentage of Transactions that are Fraudulent")+
  theme(axis.ticks.x=element_blank(),
        axis.text.x=element_blank())

ggsave("plots/fraud_through_time.jpeg",plot = g,dpi = 320, width = 8, height = 4)

g <- train_transaction %>%
  filter(ProductCD == "H") %>%
  mutate(bin = cut_interval(TransactionDT, 40))%>%
  group_by(bin) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(bin,percent_fraud))+
  geom_bar(stat = "identity")+
  labs(title = "Product \"H\" Percentage of Fraudulent Transactions Through Time",
       x = "Sequential Time Bins of Equal Interval",
       y = "Percentage of Transactions that are Fraudulent")+
  theme(axis.ticks.x=element_blank(),
        axis.text.x=element_blank())

ggsave("plots/Product_H_fraud_through_time.jpeg",plot = g,dpi = 320, width = 8, height = 4)

##################v258

g <- train_transaction %>%
  mutate(bin = cut_interval(TransactionDT, 5))%>%
  group_by(bin,V258) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(V258,percent_fraud))+
  geom_bar(stat="identity")+
  facet_wrap(~bin)+
  labs(title = "Discrete V258 Values by Fraud Percentage",
       x = "Value of V258",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)

ggsave("plots/V258.jpeg",plot = g,dpi = 320, width = 8, height = 4)

###### decimals

g <- train_transaction %>%
  mutate(f = if_else(as.integer(TransactionAmt*100) != TransactionAmt*100,'Yes','No'))%>%
  group_by(f) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(f,percent_fraud))+
  geom_bar(stat = "identity",width = .5)+
  labs(title = "Possible Foreign Transaction by Fraud Percentage",
       y = "Percentage Fraud",
       x = "Does Amount Variable have More than Two Decimals?")+ 
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .3) 

ggsave("plots/decimal.jpeg",plot = g,dpi = 320, width = 8, height = 4)




g <- train_transaction %>%
  separate(id_33,sep = "x",c("H","W"))%>%
  mutate(total_pixel = as.integer(H)*as.integer(W))%>%
  mutate(bin = ntile(total_pixel, 20))%>%
  group_by(bin) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(bin,percent_fraud))+
  geom_bar(stat = "identity")+
  labs(title = "Percentage Fraud by Total Pixels (Binned)",
       x = "Total Pixels Bins",
       y = "Percentage of Transactions that are Fraudulent")

ggsave("plots/pixel.jpeg",plot = g,dpi = 320, width = 8, height = 4)


train_transaction %>%
  separate(id_33,sep = "x",c("H","W"))%>%
  mutate(total_pixel = as.integer(H)*as.integer(W))%>%
  ggplot(aes(total_pixel,fill = as.factor(isFraud)))+
  geom_histogram()+ 
  scale_x_log10(labels = comma)+
  labs(title = "P",
       x = "Total Pixels",
       y = "Count")

