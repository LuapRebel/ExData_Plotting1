## Install necessary packages
library(dplyr)

## Check to see if raw data file exists
if(!file.exists("./household_power_consumption.txt")){
        
        ## Download data if not already present
        fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileUrl, "household_power_consumption.zip")
        
        ## Unzip downloaded zip file
        unzip("./household_power_consumption.zip")
}

## Import data, create data.frame to work with
hpc <- read.table("household_power_consumption.txt", header=T, sep=";", 
                  , nrows = 2075259, colClasses = c(rep("character", 2), rep("numeric", 7)), 
                  na.strings = "?")

## Convert Date column to "date" format
hpc$Date <- as.Date(hpc$Date, format="%d/%m/%Y")

## Create subset of data for plotting
hpc <- filter(hpc, Date == as.Date("2007-02-01") | Date == as.Date("2007-02-02"))

## Add DateTime column, remove Date and Time columns
hpc <- mutate(hpc, DateTime = paste(hpc$Date, hpc$Time))
hpc <- select(hpc, DateTime, Global_active_power:Sub_metering_3)

## Open graphics device and set parameters for plots
png("plot4.png", width=480, height=480)
par(mfcol=c(2,2))

## Create top left plot
plot(as.POSIXct(hpc$DateTime), hpc$Global_active_power, type="l",
     xlab="", ylab="Global Active Power")

## Create bottom left plot
plot(as.POSIXct(hpc$DateTime), hpc$Sub_metering_1, type="l",
     xlab="", ylab="Energy sub metering")
lines(as.POSIXct(hpc$DateTime), hpc$Sub_metering_2, type="l", col="red")
lines(as.POSIXct(hpc$DateTime), hpc$Sub_metering_3, type="l", col="blue")
legend("topright", legend=c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       lty=1, col=c("black", "red", "blue"), bty="n")

## Create top right plot
plot(as.POSIXct(hpc$DateTime), hpc$Voltage, type="l",xlab="datetime", 
     ylab="Voltage")

## Create bottom right plot
plot(as.POSIXct(hpc$DateTime), hpc$Global_reactive_power, type="l",xlab="datetime", 
     ylab="Global_reactive_power")

## Close graphics device
dev.off()
