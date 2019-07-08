library(rvest)
library(dplyr)
##
PTT<-"https://www.wincustomize.com"
PTT1<-"https://www.wincustomize.com/explore/start_buttons"
underline1<-NULL
underlineUrl1<-NULL
for (a in 1:30) {
  httml<-read_html(PTT1)%>%html_nodes("a.pnext")%>%html_attr("href")
  
  PTT1<-paste0(PTT,httml[1])
  PTT1
  underline<-MediaReport%>% html_nodes("#skincontainer h1 a")%>%html_text()
  underlineUrl<-MediaReport%>% html_nodes(".rating")%>% html_attr("class")
  
  underline1<-c(underline1,underline)
  underlineUrl1<-c(underlineUrl1,underlineUrl)
}
##
thrmedia<-data.frame(
  title=underline1,
  link=underlineUrl1
)
thrmedia$link<-substr(thrmedia$link,start = 18,stop = 19)
View(thrmedia)
str(thrmedia$link)
thrmedia$link<-as.numeric(thrmedia$link)
