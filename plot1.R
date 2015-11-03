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
df$Global_active_power <- as.numeric(df$Global_active_power)

# plot 1
png(filename = "plot1.png", width = 480, height = 480, bg = "transparent")
hist(df$Global_active_power,  
     col = "red",
     breaks = 24,
     xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power")
dev.off()