#orders
url <- "https://api.vertechain.com:6010/"
missing <- matrix(c(0), nrow = 0, ncol = 1)
for(i in 5001:5496){
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
  JSON<-JSON$order
  saveJSON <- toJSON(JSON)
  write_json(saveJSON,path = gsub(" ", "", paste("~/Blockchain2.0/RScriptJSON/Orderfiles/", gsub(" ","", paste("VC003-",i,"(",j,")",".json")))))
}
}
missing <- gsub(" ","",paste("VC003-",missing))
write.csv(missing, file = "missingorders.csv")



