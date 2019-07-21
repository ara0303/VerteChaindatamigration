#ASN
setwd("~/Blockchain2.0/RScriptJSON")
url <- "https://api.vertechain.com:6010/"
newurl <- "https://api.projectverte.io:6010/api/vertechain/setASN"
authurl <- "https://api.projectverte.io:6010/users/authenticate"
token <- content(POST(url = authurl, body = list(username = "Admin", password = "Admin123!"), encode = c("json")))$token
ASN <- as.data.frame(read.csv("ASNfile.csv", header = T, stringsAsFactors = F))
missingasn <- matrix(c(0), nrow = 0, ncol = 1)

for(i in 1:nrow(ASN)){
  path <- gsub(" ","", paste("api/Vertechain/GetASN?=",ASN[i,]))
  raw.result <- GET(url = url, path = path)
  if(length(content(raw.result)) == 0){
    missingasn <- rbind(missingasn,ASN[i,])
    print(ASN[i,])
    next
  } 
  else {
    JSON = content(raw.result)
    JSON<-JSON$asn
    saveJSON <- toJSON(JSON)
    POST(newurl, body = saveJSON, add_headers('Content-Type'='application/json','Authorization'='Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkFkbWluIiwicm9sZSI6IkFkbWluIiwibmJmIjoxNTYzNDg3NzE1LCJleHAiOjE1NjQwOTI1MTUsImlhdCI6MTU2MzQ4NzcxNX0.DqEiQtrxtubkNGgmWu4pBSGwdYxSiNGRJWbLpe4_oxw'))
  }
}
write.csv(missingasn, file = "missingasn.csv")
