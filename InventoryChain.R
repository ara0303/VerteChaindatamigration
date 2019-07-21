#Inventory
setwd("~/Blockchain2.0/RScriptJSON")
url <- "https://api.vertechain.com:6010/"
newurl <- "https://api.projectverte.io:6010/api/Vertechain/SetInventory"
authurl <- "https://api.projectverte.io:6010/users/authenticate"
token <- content(POST(url = authurl, body = list(username = "Admin", password = "Admin123!"), encode = c("json")))$token
INV <- as.data.frame(read.csv("Inventoryfiles.csv", header = T, stringsAsFactors = F))
missinginv <- matrix(c(0), nrow = 0, ncol = 1)

for(i in 1:nrow(INV)){
  path <- gsub(" ","", paste("api/Vertechain/GetInventory?=",INV[i,]))
  raw.result <- GET(url = url, path = path)
  if(length(content(raw.result)) == 0){
    b <- INV[i,]
    missinginv <- rbind(missinginv,b)
    print(b)
    next
  } 
  else {
    n <- length(content(raw.result)$transaction)
  }
  for(j in 1:n){
    transaction = content(raw.result)$transaction[[j]][1]
    JSON <- read_json(gsub(" ","",paste("https://api.vertechain.com:6010/api/VerteChain/GetInventoryTransaction?key=",transaction)))
    JSON<-JSON$inventory
    JSON <- JSON$facilityQty[[1]]$allocatedQty <- "0"
    saveJSON <- toJSON(JSON)
    POST(newurl, body = saveJSON, add_headers('Content-Type'='application/json','Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkFkbWluIiwicm9sZSI6IkFkbWluIiwibmJmIjoxNTYzNDg3NzE1LCJleHAiOjE1NjQwOTI1MTUsImlhdCI6MTU2MzQ4NzcxNX0.DqEiQtrxtubkNGgmWu4pBSGwdYxSiNGRJWbLpe4_oxw'))
  }
}
