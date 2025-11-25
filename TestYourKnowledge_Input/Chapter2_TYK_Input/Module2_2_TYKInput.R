# Graphing example 

library(tidyverse)

x=data.frame(group = c("A", "A", "A", "B", "B", "B", "C", "C", "C"), value = c(1, 2, 3, 4, 5, 6, 7, 8, 9))

m=x %>% group_by(group) %>% summarise(across(value,mean)) %>% rename("mean"="value")

s=x %>% group_by(group) %>% summarise(across(value,sd)) %>% rename("sd"="value")

ms=left_join(m,s,by="group")

ggplot()+geom_col(data=ms,aes(x=group, y=mean))+geom_errorbar(data=ms,aes(x=group,ymin=mean-sd,ymax=mean+sd,width = 0.2)) + 
  geom_jitter(data=x,aes(x=group,y=value),position=position_jitter(0.15), size = 2)
