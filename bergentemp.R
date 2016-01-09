##Temperatur i Bergen i dag

library(RCurl)
library(XML)

dato <- Sys.Date()
url <- paste0("http://eklima.met.no/met/MetService?invoke=getMetDataValues&timeserietypeID=2&format=&from=2016-01-01", "&to=", dato, "&stations=50540&elements=ta&hours=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23&months=&username=")

temp <- getURL(url)
temp <- xmlParse(temp)
temp <- xmlToDataFrame(getNodeSet(temp, "//value"), stringsAsFactors=FALSE)

make.csv <- function(x){
  t <- as.numeric(x[,1])
  txt <- character()
  lgth <- length(x[,1])
  for (i in 1:lgth) {
    txt <- paste0(txt, t[i], ",")
  }
  txt <- paste0("[", txt, "]", collapse="")
  return(txt)
}

data <- make.csv(temp)
data <- gsub("(.*)\\,(.*)", "\\1\\2", data)
data <- paste0("var temps = { name: 'Temperatur', data: ", data, "};")
write.table(data, "data/temps.js", row.names=FALSE, col.names=FALSE, quote=FALSE)