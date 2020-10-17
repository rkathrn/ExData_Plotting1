##downloading the file from the great blue beyond

tempdl <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", tempdl)
unzip(tempdl, "household_power_consumption.txt")

##reading into table
data <- read.table(file="household_power_consumption.txt", header = TRUE, sep = ";", comment.char = "")

##convert date column to date format and extracting just the dates we want
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
SpecDates <- subset(data, Date >= "2007-02-01" & Date <= "2007-02-02") 

##removing excess files
rm(data)
rm(tempdl)

## converting times to time format and combining into single 'datetime' object
library(chron)
SpecDates$Time <- times(SpecDates$Time)
datetime <- as.POSIXct(paste(SpecDates$Date, SpecDates$Time), format="%Y-%m-%d %H:%M:%S") ##combining two dates and times
SpecDates$Date.Time <- datetime ##saving date time combo as column
SpecDates$Date <- NULL ##removing old date col
SpecDates$Time <- NULL ## removing old time col


##GETTING PLOT 1

SpecDates$Global_active_power <- gsub("?", NA, SpecDates$Global_active_power, fixed = TRUE)

SpecDates$Global_active_power <- as.numeric(SpecDates$Global_active_power) ##turn the right column into numeric because f that

png(filename = "plot1.png")
hist(SpecDates$Global_active_power, main = "Global Active Power", xlab = "Global Active Power (kilowatts)", col = "red")
dev.off()

#how to get PLOT1