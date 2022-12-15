getwd()

library(dplyr)
library(tidyr)
install.packages("janitor")
library(janitor)
install.packages("splitstackshape")
library(splitstackshape)


my_data <- read.delim("elena_seq.txt", header=FALSE)
str(my_data)

my_data$V1 <= as.character(my_data$V1)


df <- do.call("cbind", split(my_data, rep(c(1, 2), length.out = nrow(my_data))))

colnames(df)
df <- janitor::clean_names(df)

df<- cSplit(df, 1, sep = "-", type.convert = FALSE)
df <- cSplit(df, 8, sep = ".", type.convert = FALSE)
df <- cSplit(df, 1, sep = ":", type.convert = FALSE)

names(df)[15] <- "Barcode"
