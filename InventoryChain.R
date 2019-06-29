#Inventory
url <- "https://api.vertechain.com:6010/"
sku <- as.data.frame(read.csv("Inventory test file.csv", header = T, stringsAsFactors = F))
missinginv <- matrix(c(0), nrow = 0, ncol = 1)

for(i in 1:nrow(sku)){
  path <- gsub(" ","", paste("api/Vertechain/GetInventory?inventoryID=VIA-",sku[i,]))
  raw.result <- GET(url = url, path = path)
  if(length(content(raw.result)) == 0){
    b <- gsub(" ","",paste("VIA-",sku[i,]))
    missinginv <- rbind(missinginv,b)
    print(b)
    next
  } 
  else {
    n <- length(content(raw.result)$transaction)
  }
  for(j in 1:n){
    transaction = content(raw.result)$transaction[j]
    JSON <- read_json(gsub(" ","",paste("https://api.vertechain.com:6010/api/VerteChain/GetInventoryTransaction?key=",transaction)))
    JSON<-JSON$inventory
    saveJSON <- toJSON(JSON)
    write_json(saveJSON,path = gsub(" ", "", paste("~/Blockchain2.0/RScriptJSON/Inventoryfiles/", gsub(" ","", paste(sku[i,],"(",j,")",".json")))))
  }
}

