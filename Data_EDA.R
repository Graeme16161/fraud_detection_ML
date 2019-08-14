library(tidyverse)
library(scales)

setwd('C:/Users/gakel/Documents/Bootcamp/Capstone')

train_identity <- read_csv("data/train_identity.csv")
train_transaction <- read_csv("data/train_transaction.csv")

train_transaction <- left_join(train_transaction,train_identity, by = 'TransactionID')

#ggsave("plots/missing_data.jpeg",plot = g,dpi = 320, width = 8, height = 4)

# distribution of target feature
train_transaction %>%
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

#Distribution of transaction amount
ggplot(train_transaction,aes(TransactionAmt))+
  geom_histogram()+
  labs(title = "Distribution of Transaction Size (log10)",
       y = "Count",
       x = "Transaction Amount (USD)")+ 
  scale_y_continuous(labels = comma)+ 
  scale_x_log10()

# distribution of card type (card4)
train_transaction %>%
  group_by(card4)%>%
  summarise(count = n())%>%
  ggplot(aes(card4,count)) +
  geom_bar(stat = "identity",width = .5)+
  labs(title = "Card Type Used",
       y = "Count",
       x = "Card Type")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=count),  size=3.5, nudge_y = 15000) 

train_transaction %>%
  group_by(card4) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(reorder(reorder(card4,percent_fraud),percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Card Type by Fraud Percentage",
       x = "",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .4)

# distribution of transaction type (card6)
train_transaction %>%
  group_by(card6)%>%
  summarise(count = n())%>%
  ggplot(aes(card6,count)) +
  geom_bar(stat = "identity",width = .5)+
  labs(title = "Transaction Type",
       y = "Count",
       x = "Transaction Type")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=count),  size=3.5, nudge_y = 15000) 

train_transaction %>%
  group_by(card6) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(reorder(reorder(card6,percent_fraud),percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Transaction Type by Fraud Percentage",
       x = "",
       y = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .4)


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


train_transaction %>%
  group_by(R_emaildomain) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  arrange(desc(percent_fraud))%>%
  top_n(15,percent_fraud) %>%
  ggplot(aes(reorder(R_emaildomain,percent_fraud),percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Recipient Domain by Fraud Percentage (Top 15)",
       y = "",
       x = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=total),  size=3.5, nudge_y = 4)


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

train_transaction %>%
  select(isFraud,R_emaildomain,P_emaildomain)%>%
  mutate(emails = email_sit(P_emaildomain, R_emaildomain))%>%
  group_by(emails)%>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  ggplot(aes(emails,percent_fraud))+
  geom_bar(stat = "identity")+
  coord_flip()+
  labs(title = "Email Information by Fraud Percentage",
       y = "",
       x = "Percentage Fraud")+ 
  scale_y_continuous(labels = comma)+
  geom_text(aes(label=percent_fraud),  size=3.5, nudge_y = .7)


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
train_transaction %>%
  group_by(id_30) %>%
  summarise(total = n(),total_f = sum(isFraud))%>%
  mutate(percent_fraud = round(digits = 2,total_f/total*100))%>%
  filter(total > 1000)%>%
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


