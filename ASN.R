#ASN
url <- "https://api.vertechain.com:6010/"
ASN <- as.data.frame(read.csv("ASNfile.csv", header = T, stringsAsFactors = F))
missingasn <- matrix(c(0), nrow = 0, ncol = 1)

for(i in 1:nrow(ASN)){
  path <- gsub(" ","", paste("api/Vertechain/GetASN?=",ASN[i,]))
  raw.result <- GET(url = url, path = path)
  if(length(content(raw.result)) == 0){
    missingasn <- rbind(missinginv,ASN[i,])
    print(ASN[i,])
    next
  } 
  else {
    JSON = content(raw.result)
    JSON<-JSON$asn
    saveJSON <- toJSON(JSON)
    write_json(saveJSON,path = gsub(" ", "", paste("~/Blockchain2.0/RScriptJSON/ASNfiles/",ASN[i,],".json")))
  }
}
write.csv(missingasn, file = "missingasn.csv")
