###############################################################################################################
###
###Require packages to run analysis
install.packages("devtools")
require(devtools)
install_github("CenterForAssessment/SGP")
require(SGP)

require(data.table)
require(reshape)
require(plyr)
require(snow)
###############################################################################################################



###############################################################################################################
###
###Read in Long Data
WIDA_NV_Data_LONG <- as.data.table(read.delim("//EMETRIC-NAS/NevadaLDS/Growth/WIDA/2015/WIDA_GrowthInput_File_2015/WIDA_GrowthInput_File_2015.txt", sep="|", colClasses=rep("character",8)))
###############################################################################################################




###############################################################################################################
###
###Clean up data for SGP and check for duplicates
###Remove missing achievement levels, scale scores and grades
WIDA_NV_Data_LONG <- WIDA_NV_Data_LONG[ACHIEVEMENT_LEVEL!=""]
WIDA_NV_Data_LONG <- WIDA_NV_Data_LONG[SCALE_SCORE!=""]
WIDA_NV_Data_LONG <- WIDA_NV_Data_LONG[GRADE!=""]

###Taken from Damian's WIDA_NV_Data_LONG.R script
WIDA_NV_Data_LONG[,Assessment:=NULL]
WIDA_NV_Data_LONG[YEAR=="2012_2013",YEAR:="2013"]
WIDA_NV_Data_LONG[YEAR=="2013_2014",YEAR:="2014"]
WIDA_NV_Data_LONG[YEAR=="2014_2015",YEAR:="2015"]
WIDA_NV_Data_LONG[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]
WIDA_NV_Data_LONG[,GRADE:=as.character(as.numeric(GRADE))]
WIDA_NV_Data_LONG[,ACHIEVEMENT_LEVEL:=as.character(ACHIEVEMENT_LEVEL)]

###Verify missing data removed
AchSclScrCheck <- table(WIDA_NV_Data_LONG$ACHIEVEMENT_LEVEL,WIDA_NV_Data_LONG$SCALE_SCORE)
GradeCheck <- table(WIDA_NV_Data_LONG$GRADE)
AchSclScrCheck # print table
GradeCheck # print table


names(WIDA_NV_Data_LONG)[2:3] <- c("STATE_UNIQUE_ID", "LOCAL_UNIQUE_ID")
WIDA_NV_Data_LONG$ID <- as.factor(WIDA_NV_Data_LONG$ID)
levels(WIDA_NV_Data_LONG$LAST_NAME) <- sapply(levels(WIDA_NV_Data_LONG$LAST_NAME), capwords)
levels(WIDA_NV_Data_LONG$FIRST_NAME) <- sapply(levels(WIDA_NV_Data_LONG$FIRST_NAME), capwords)

WIDA_NV_Data_LONG$ACHIEVEMENT_LEVEL <- ordered(WIDA_NV_Data_LONG$ACHIEVEMENT_LEVEL, levels=c("1.00", "2.00", "3.00", "4.00", "5.00", "6.00"))
###WIDA_NV_Data_LONG$EMH_LEVEL <- NULL

WIDA_NV_Data_LONG$SCHOOL_ENROLLMENT_STATUS <- as.factor(WIDA_NV_Data_LONG$SCHOOL_ENROLLMENT_STATUS)
levels(WIDA_NV_Data_LONG$SCHOOL_ENROLLMENT_STATUS) <- c("Enrolled School: No", "Enrolled School: Yes")

WIDA_NV_Data_LONG$DISTRICT_ENROLLMENT_STATUS <- as.factor(WIDA_NV_Data_LONG$DISTRICT_ENROLLMENT_STATUS)
levels(WIDA_NV_Data_LONG$DISTRICT_ENROLLMENT_STATUS) <- c("Enrolled District: No", "Enrolled District: Yes")

WIDA_NV_Data_LONG$STATE_ENROLLMENT_STATUS <- as.factor(WIDA_NV_Data_LONG$STATE_ENROLLMENT_STATUS)
levels(WIDA_NV_Data_LONG$STATE_ENROLLMENT_STATUS) <- c("Enrolled State: No", "Enrolled State: Yes")

WIDA_NV_Data_LONG$VALID_CASE <- factor(1, levels=1:2, labels=c("VALID_CASE", "INVALID_CASE"))
WIDA_NV_Data_LONG <- as.data.table(WIDA_NV_Data_LONG)

### Set key

setkeyv(WIDA_NV_Data_LONG,c("VALID_CASE","CONTENT_AREA","YEAR","ID"))
summary(duplicated(WIDA_NV_Data_LONG))
###############################################################################################################
