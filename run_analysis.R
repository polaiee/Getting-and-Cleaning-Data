# Coursera Getting and Cleaning Data - Course Project 
library(data.table)

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename<- download.file( url, destfile = "./data.zip" )
#revisar si existe
if (!file.exists("UCI HAR Dataset")) { 
        unzip("./data.zip") 
}
#########################################################
#1. Crear una base de datos

x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# Crear base X
x_base <- rbind(x_train, x_test)

# crear base Y
y_base <- rbind(y_train, y_test)

# crear subject base
subject_base <- rbind(subject_train, subject_test)

#####################################################
#2-Sacar promedios y desviacion estandar
features <- read.table("./UCI HAR Dataset/features.txt")

#promedios y sd
mean.sd <- grep("-(mean|std)\\(\\)", features[, 2])

# subset columnas
x_base <- x_base[, mean.sd]

# Corregir nombres
names(x_base) <- features[mean.sd, 2]

#########################################################
#3- Renombrar actividades
act <- read.table("./UCI HAR Dataset/activity_labels.txt")

# actualizar valores con actividades
y_base[, 1] <- act[y_base[, 1], 2]

# Corregir nombre
names(y_base) <- "actividad"

################################################
#4- Nombres descriptivos
# Corregir nombres
names(subject_base) <- "subject"

# Combinar bases
base <- cbind(x_base, y_base, subject_base)

################################################
#5- Nueva base con promedio de datos

Mean.Base <- base %>%
        group_by(subject, actividad) %>%
        summarise_all(funs(mean))

write.table(Mean.Base, "Base.txt", row.name=FALSE)

View(Mean.Base)
