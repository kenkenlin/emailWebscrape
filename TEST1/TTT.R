library(readr)
data_103_FStu_Country <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=25f64d5125016dcd6aed42e50c972ed0")
data_103_FStu_School <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=a6d1469f39fe41fb81dbfc373aef3331")
data_104_FStu_Country <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=4d3e9b37b7b0fd3aa18a388cdbc77996")
data_104_FStu_School <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=8baeae81cba74f35cf0bb1333d3d99f5")
data_105_FStu_Country <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=19bedf88cf46999da12513de755c33c6")
data_105_FStu_School <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=1a485383cf9995da679c3798ab4fd681")
data_106_FStu_Country <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=50e3370f9f8794f2054c0c82a2ed8c91")
data_106_FStu_School <- read_csv("https://quality.data.gov.tw/dq_download_csv.php?nid=6289&md5_url=883e2ab4d5357f70bea9ac44a47d05cc")
Student_RPT_07 <- Student_RPT_07 <- read_csv("C:/Users/Jack/Downloads/Student_RPT_07.csv", locale = locale(encoding = "BIG5"), skip = 1)
first_row <- Student_RPT_07[1,]
Student_RPT_07 <- Student_RPT_07[-1,]
colnames(Student_RPT_07)[c(4,5,6,12,14,15)]  <- first_row[1,c(4,5,6,12,14,15)]

library(dplyr)

data_103_FStu_Country <- mutate(data_103_FStu_Country, FStudent_103 = `學位生-正式修讀學位外國生`+ `學位生-僑生(含港澳)`+ `學位生-正式修讀學位陸生`+
                                  `非學位生-外國交換生`+ `非學位生-外國短期研習及個人選讀`+ `非學位生-大專附設華語文中心學生`+ 
                                  `非學位生-大陸研修生`+ `非學位生-海青班`+ 境外專班)

data_104_FStu_Country <- mutate(data_104_FStu_Country, FStudent_104 = `學位生-正式修讀學位外國生`+ `學位生-僑生(含港澳)`+ `學位生-正式修讀學位陸生`+
                                  `非學位生-外國交換生`+ `非學位生-外國短期研習及個人選讀`+ `非學位生-大專附設華語文中心學生`+ 
                                  `非學位生-大陸研修生`+ `非學位生-海青班`+ 境外專班)

data_105_FStu_Country <- mutate(data_105_FStu_Country, FStudent_105 = 學位生_正式修讀學位外國生+ `學位生_僑生(含港澳)`+ 學位生_正式修讀學位陸生+
                                  非學位生_外國交換生+ 非學位生_外國短期研習及個人選讀+ 非學位生_大專附設華語文中心學生+ 
                                  非學位生_大陸研修生+ 非學位生_海青班+ 境外專班)

data_106_FStu_Country <- mutate(data_106_FStu_Country, FStudent_106 = 學位生_正式修讀學位外國生+ `學位生_僑生(含港澳)`+ 學位生_正式修讀學位陸生+
                                  非學位生_外國交換生+ 非學位生_外國短期研習及個人選讀+ 非學位生_大專附設華語文中心學生+ 
                                  非學位生_大陸研修生+ 非學位生_海青班+ 境外專班)
Total <- full_join(data_103_FStu_Country, data_104_FStu_Country, by = '國別')
Total <- full_join(Total, data_105_FStu_Country, by = '國別')
Total <- full_join(Total, data_106_FStu_Country, by = '國別')

Total[is.na(Total)] <- as.numeric(0)


Total <- mutate(Total, Total_FStudent = FStudent_103+ FStudent_104+ FStudent_105+ FStudent_106,)%>%
  arrange(desc(Total_FStudent))


Else <- filter(Total,Total_FStudent<200)%>%summarise(Else_Total = sum(Total_FStudent))
Total_Concise <- Total[,c(2,46)]%>%filter(Total_FStudent>= 200)%>% rbind(c("其他",Else$Else_Total))
Total_Concise$Total_FStudent <- as.numeric(Total_Concise$Total_FStudent)

plot <- ggplot()+ geom_bar(data = Total_Concise, aes(x = 國別, y = Total_FStudent), stat = "identity", width = 1)+ 
          theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5, size = 7))



Total_Concise
str(Total_Concise)
TOP_10_Country <- head(Total_Concise,10)

data_103_FStu_School$`非學位生-大陸研修生`[grepl("…", data_103_FStu_School$`非學位生-大陸研修生`)] <- 0
data_104_FStu_School$`非學位生-大陸研修生`[grepl("…", data_104_FStu_School$`非學位生-大陸研修生`)] <- 0
data_103_FStu_School$`非學位生-大陸研修生` <- as.numeric(data_103_FStu_School$`非學位生-大陸研修生`)
data_104_FStu_School$`非學位生-大陸研修生` <- as.numeric(data_104_FStu_School$`非學位生-大陸研修生`)

data_103_FStu_School <-mutate(data_103_FStu_School, FStudent_103 = `學位生-正式修讀學位外國生`+ `學位生-僑生(含港澳)`+ `學位生-正式修讀學位陸生`+ 
                                `非學位生-外國交換生`+ `非學位生-外國短期研習及個人選讀`+ `非學位生-大專附設華語文中心學生`+
                                `非學位生-大陸研修生`+ `非學位生-海青班`+ 境外專班)

data_104_FStu_School <- mutate(data_104_FStu_School, FStudent_104 = `學位生-正式修讀學位外國生`+ `學位生-僑生(含港澳)`+ `學位生-正式修讀學位陸生`+
                                 `非學位生-外國交換生`+ `非學位生-外國短期研習及個人選讀`+ `非學位生-大專附設華語文中心學生`+ 
                                 `非學位生-大陸研修生`+ `非學位生-海青班`+ 境外專班)

data_105_FStu_School <- mutate(data_105_FStu_School, FStudent_105 = 學位生_正式修讀學位外國生+ `學位生_僑生(含港澳)`+ 學位生_正式修讀學位陸生+
                                 非學位生_外國交換生+ 非學位生_外國短期研習及個人選讀+ 非學位生_大專附設華語文中心學生+ 
                                 非學位生_大陸研修生+ 非學位生_海青班+ 境外專班)

data_106_FStu_School <- mutate(data_106_FStu_School, FStudent_106 = 學位生_正式修讀學位外國生+ `學位生_僑生(含港澳)`+ 學位生_正式修讀學位陸生+
                                 非學位生_外國交換生+ 非學位生_外國短期研習及個人選讀+ 非學位生_大專附設華語文中心學生+ 
                                 非學位生_大陸研修生+ 非學位生_海青班+ 境外專班)



Total_2 <- full_join(data_103_FStu_School, data_104_FStu_School, by = '學校名稱')
Total_2 <- full_join(Total_2, data_105_FStu_School, by = '學校名稱')
Total_2 <- full_join(Total_2, data_106_FStu_School, by = '學校名稱')
Total_2[is.na(Total_2)] <- as.numeric(0)

Total_2 <- mutate(Total_2, Total_FStudent = FStudent_103+ FStudent_104+ FStudent_105+ FStudent_106)
remove(Else)
Else <- filter(Total_2,Total_FStudent<200)%>%summarise(Else_Total = sum(Total_FStudent))
Total_2_Concise <- Total_2[,c(3,50)]%>%filter(Total_FStudent>= 200)%>% rbind(c("其他",Else$Else_Total)))
Total_2_Concise$Total_FStudent <- as.numeric(Total_2_Concise$Total_FStudent)

library(ggplot2)
Total_2_Concise$學校名稱
plot <- ggplot()+ geom_bar(data = Total_2_Concise, aes(x = 學校名稱, y = Total_FStudent), stat = "identity", width = 1)+ 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.3, size = 5))

library(dplyr)  
library(tidyr)

Student_RPT_07 <- Student_RPT_07[complete.cases(Student_RPT_07),]
Student_RPT_07$`本國學生出國進修、交流人數` <- as.numeric(Student_RPT_07$`本國學生出國進修、交流人數`)

Stu_Tw_to_Country <- group_by(Student_RPT_07, `對方學校(機構)國別(地區)`)%>%
                      summarise(TS = sum(as.numeric(`本國學生出國進修、交流人數`)))%>%
                      arrange(desc(TS))
##4
Top_10_Stu_Tw_to_Country <- head(Stu_Tw_to_Country,10)



Sch_Stu_abroad <- group_by(Student_RPT_07, 學校名稱)%>%
                   summarise(TS = sum(as.numeric(`本國學生出國進修、交流人數`)))%>%
                   arrange(desc(TS))
##5
ggplot() + geom_bar(data = Stu_Tw_to_Country, aes(x = `對方學校(機構)國別(地區)`, y = TS),stat = "identity", width = 1)+ 
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.3, size = 5))


##6
b

##7




a <- group_by(Student_RPT_07,`對方學校(機構)國別(地區)`)%>%
  summarise(Count=n())%>%arrange(desc(Count))
ggplot()+ geom_bar(data = a, aes(x= `對方學校(機構)國別(地區)`, y = Count), stat = "identity", width = 2)+ 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 4))

library(choroplethrMaps)
library(choroplethr)





world <- map_data("world")
worldmap <- ggplot(world, aes(x=long, y=lat)) +
  geom_path() +
  scale_y_continuous(breaks=(-2:2) * 30) +
  scale_x_continuous(breaks=(-4:4) * 45) +
  geom_polygon(data = Total_3,)


library(ggmap)
twmap <- get_googlemap(center = "World", 
                       zoom = 2,
                       language = "zh-TW")



ggmap(twmap)

install.packages("choroplethr")
data(df_pop_state)

library(choroplethr)

data(choroplethr)

state_choropleth(df_pop_state) 


choroplethr(df_pop_county, “county”, title=”2012 County Population Estimates”)
data(map.states)

data(country.names)

df = data.frame(region=country.names, value=sample(1:length(country.names)))

choroplethr(df, lod="world")
data(continental_us_states)
state_choropleth(reference_map = TRUE)
a <- choroplethr()


