##downloading the file from the great blue beyond
tempdl <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", tempdl)
unzip(tempdl, "household_power_consumption.txt")
data <- read.table(file="household_power_consumption.txt", header = TRUE, sep = ";", comment.char = "")

##now that puppy's all read into a table!

rm(tempdl) ##just to cover our bases

data$Date <- as.Date(data$Date, format = "%d/%m/%Y") ##convert first column to date format in R

SpecDates <- subset(data, Date >= "2007-02-01" & Date <= "2007-02-02") ## saving just the dates we want into SpecDates object

rm(data) ## get rid of that sucka because it's too big

## TURNING THE TIMES INTO ACTUAL TIMES
library(chron)
SpecDates$Time <- times(SpecDates$Time)
datetime <- as.POSIXct(paste(SpecDates$Date, SpecDates$Time), format="%Y-%m-%d %H:%M:%S") ##combining two dates and times
SpecDates$Date.Time <- datetime ##saving date time combo as column
SpecDates$Date <- NULL ##removing old date col
SpecDates$Time <- NULL ## removing old time col


##GETTING PLOT 4
##Prep Work
##remove ? values from submeter 2 and converting to numeric
SpecDates$Sub_metering_2 <- gsub("?", NA, SpecDates$Sub_metering_2, fixed = TRUE)
SpecDates$Sub_metering_2 <- as.numeric(SpecDates$Sub_metering_2)

##remove ? values from submeter 1 and converting to numeric
SpecDates$Sub_metering_1 <- gsub("?", NA, SpecDates$Sub_metering_1, fixed = TRUE)
SpecDates$Sub_metering_1 <- as.numeric(SpecDates$Sub_metering_1)

#creating numeric vectors for submeters 2 and 3 to add them to the plot with line function
submeter2 <-SpecDates$Sub_metering_2
submeter3 <-SpecDates$Sub_metering_3

##Actual Plotting
png(filename = "plot4.png")
par(mfcol = c(2,2))
plot(SpecDates$Date.Time, SpecDates$Global_active_power, type = "l", xlab = "", ylab = "Global Active Power (kilowatts)") ## add plot 2

plot(SpecDates$Date.Time, SpecDates$Sub_metering_1, type="l", xlab = "", ylab = "Energy sub metering")


lines(SpecDates$Date.Time, submeter2, col = "red")
lines(SpecDates$Date.Time, submeter3, col = "blue")

legend("topright", lty = 1, col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
plot(SpecDates$Date.Time, SpecDates$Voltage, type = "l", xlab = "datetime", ylab= "Voltage")

plot(SpecDates$Date.Time, SpecDates$Global_reactive_power, type = "l", xlab = "datetime", ylab= "Global_reactive_power")
dev.off()