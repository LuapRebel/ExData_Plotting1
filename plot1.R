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

## Create plot
png(filename="plot1.png", width=480, height=480)
hist(hpc$Global_active_power, col="red", main="Global Active Power", 
     xlab="Global Active Power (kilowatts)")
dev.off()
