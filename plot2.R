# Loading the data

library(data.table)
temp <- tempfile()
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
datafilename <- "household_power_consumption.txt"
destfile <- "household_power_consumption.zip"
if (!file.exists(datafilename)) {
        download.file(fileURL, destfile,method="auto") 
        unzip(destfile, exdir=getwd())
}


con <- file(datafilename, "r", blocking = FALSE) 
ColumnNames <- read.csv(con, nrows= 1, header = FALSE, sep = ";", stringsAsFactors = FALSE)


df <- data.frame(matrix(NA, nrow = 0, ncol = 9))
reachedeof <- FALSE
while (reachedeof == FALSE )   { 
        tempdata <- tryCatch(read.csv(con,nrows= 10000, header = FALSE, 
                                      stringsAsFactors = FALSE, sep = ";"), 
                             error = function(e) data.frame(matrix(NA, nrow = 0, ncol = 9)))
        reachedeof <- dim(tempdata)[1] < 10000       
        df <- rbind(df, tempdata[tempdata$V1 %in% "1/2/2007" | tempdata$V1 %in% "2/2/2007", ])
        
}
close(con)
colnames(df) <- ColumnNames
df[df == "?"] <- NA
df$Date <- as.Date(df$Date, "%d/%m/%Y")
df$Time <- strptime(paste(df$Date, df$Time), format = "%Y-%m-%d %H:%M:%S")
plot(x = df$Time, y = as.numeric(df$Global_active_power), type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")
dev.print(png, 'plot2.png', width = 843, height = 637)
dev.off()
