library(httr)
library(jsonlite)
library(lubridate)
library(rjson)
#orders
url <- "https://api.vertechain.com:6010/"
newurl <- "https://api.projectverte.io:6010/api/vertechain/setOrder"
authurl <- "https://api.projectverte.io:6010/users/authenticate"
token <- content(POST(url = authurl, body = list(username = "Admin", password = "Admin123!"), encode = c("json")))$token
missing <- matrix(c(0), nrow = 0, ncol = 1)
for(i in 1:25200){
path <- gsub(" ","", paste("api/Vertechain/GetOrder?OrderID=VC003-",i))
raw.result <- GET(url = url, path = path)
if(length(content(raw.result)) == 0){
  print(i) 
  missing <- rbind(missing,i)
  next
  } 
  else {
  n <- length(content(raw.result)$transaction)
  }
for(j in 1:n){
  transaction = content(raw.result)$transaction[j]
  JSON <- read_json(gsub(" ","",paste("https://api.vertechain.com:6010/api/VerteChain/GetOrderTransaction?key=",transaction)))
  JSON <- JSON$order
  JSON$shipment$ReleaseOrders
  JSON$shipment$ReleaseOrders[[1]]
  JSON$shipment$ReleaseOrders[[1]]$ReleaseOrder <- NULL
  JSON$shipment$ReleaseOrders[[1]]$Carton <- JSON$shipment$carton
  JSON$shipment$carton <- NULL
  saveJSON <- toJSON(JSON)
  POST(newurl, body = saveJSON, add_headers('Content-Type'='application/json','Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkFkbWluIiwicm9sZSI6IkFkbWluIiwibmJmIjoxNTYzNDg3NzE1LCJleHAiOjE1NjQwOTI1MTUsImlhdCI6MTU2MzQ4NzcxNX0.DqEiQtrxtubkNGgmWu4pBSGwdYxSiNGRJWbLpe4_oxw'))
}
}

write.csv(missing, file = "missingorders.csv")


