library(dplyr)
nasa1 <-as_data_frame(nasa)

### selection of rows using a condition
nasa1<-nasa1 %>% filter((lat>=29.56) & (lat<=33.09) & (long<=-90.55) & (long>=-110.93))

nasa1 <-nasa1 %>% mutate(temp.surftemp = temperature/surftemp)

nasa1 %>% 
  group_by(year) %>%
  summarise(mean.pressure=mean(pressure,na.rm=T), 
            mean.ozone=mean(ozone,na.rm=T),
            mean.temp.surftemp=mean(temp.surftemp,na.rm=T),
            sd.pressure=sd(pressure,na.rm=T), 
            sd.ozone=sd(ozone,na.rm=T),
            sd.temp.surftemp=sd(temp.surftemp,na.rm=T))%>%
    arrange(desc(mean.ozone))


