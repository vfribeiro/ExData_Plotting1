# Download and unzip file but first check if a file with only the desired dates
# exists or not.
if (!file.exists("desireddata.csv")) {
  # check for original files. download and unzip if it's the case
  if (!file.exists("../dataproj1/exdata-data-household_power_consumption.zip")) {
    url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(url,
                  destfile="../dataproj1/exdata-data-household_power_consumption.zip",
                  method="curl")  
  } 
  if (!file.exists("../dataproj1/household_power_consumption.txt")) {
    unzip("../dataproj1/exdata-data-household_power_consumption.zip",
          exdir = "../dataproj1")
  }
  # read data
  df <- read.csv("../dataproj1/household_power_consumption.txt", 
                 header = TRUE, stringsAsFactors = FALSE, sep = ";")
  # filter dataset
  df <- df[df$Date=="1/2/2007" | df$Date=="2/2/2007",]
  
  # save dataset for other plots
  write.csv(df, file = "desireddata.csv")
} else {
  df <- read.csv("desireddata.csv", header = TRUE, stringsAsFactors = FALSE)
}

# convert data
df$DateTime <- strptime( paste(df$Date, df$Time), format = "%d/%m/%Y %H:%M:%S")
df$Global_active_power <- as.numeric(df$Global_active_power)
df$Sub_metering_1 <- as.numeric(df$Sub_metering_1)
df$Sub_metering_2 <- as.numeric(df$Sub_metering_2)
df$Sub_metering_3 <- as.numeric(df$Sub_metering_3)
df$Voltage <- as.numeric(df$Voltage)
df$Global_reactive_power <- as.numeric(df$Global_reactive_power)

# plot 4
png(filename = "plot4.png", width = 480, height = 480, bg = "transparent")
par(mfrow = c(2,2))

# chart top left
plot(df$DateTime,
     df$Global_active_power,  
     type = 'l',
     ylab = "Global Active Power",
     xlab = "")

# chart top right
plot(df$DateTime,
     df$Voltage,  
     type = 'l',
     ylab = "Voltage",
     xlab = "datetime")

# chart botton left
plot(df$DateTime,
     df$Sub_metering_1,  
     type = 'l',
     ylab = "Energy sub metering",
     xlab = "")
lines(df$DateTime, df$Sub_metering_2, col = "red")
lines(df$DateTime, df$Sub_metering_3, col = "blue")
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lty = c(1,1,1),
       lwd = c(2,2,2),
       col = c("black", "red", "blue"),
       bty = "n")

# chart botton right
plot(df$DateTime,
     df$Global_reactive_power,  
     type = 'l',
     xlab = "datetime",
     ylab = "Global_reactive_power")

dev.off()