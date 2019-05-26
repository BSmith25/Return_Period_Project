# This program reads in Annual Peaks and Peaks OVer Threshold for a streamflow gauge,
# then fits the GEV and GPD distributions (respectively) using MLE, then calculates
# the 95% CI for the 5-year return periods, and finally calculates the % difference
# between the 5-year return period estimates using Annual Peaks and POT

# Input files are:  anpeak.txt for annual peaks, using the 5th column
#                   POT.text for Peaks OVer Threshold using the 6th column
#                   len.txt for length of the record POT were derived from
# Output file is:   R_EVDS.txt with a format of:  (annual peaks)# records, shape parameter, min CI value, 5yr return period, max CI value, (POT)# records, shape parameter, min CI value, 5yr return period, max CI value,  % difference in 5-year return period

#install.packages("extRemes",repos = "http://cran.us.r-project.org")
library("extRemes")
Outfile = file("C:/Return_Period_Project/R_EVDs.txt")

anpeak = read.delim("C:/Return_Period_Project/anpeak.txt", header=FALSE)
POT = read.table("C:/Return_Period_Project/POT.txt", quote="\"", comment.char="")
reclen = read.table("C:/Return_Period_Project/len.txt", quote="\"", comment.char="")

# Fit annual peaks to a GEV and calculate return period
AnGEV=fevd(anpeak$V5,type="GEV")
AnT5CI = ci.fevd(AnGEV,return.period=5)
AnNum = length(anpeak$V5)

# Fit POT to a GPD and calculate return period
POTGP=fevd(POT$V6,threshold=min(POT$V6),span=reclen$V3,type="GP") 
POTT5CI = ci.fevd(POTGP,return.period=5)
POTNum=length(POT$V6)

# Calculate the % difference between return period estimates
PDiff=(AnT5CI[2]-POTT5CI[2])/AnT5CI[2]

# Write to file
write(c(AnNum,AnGEV$results$par[3],AnT5CI,POTNum,POTGP$results$par[2],POTT5CI,PDiff),Outfile)
close(Outfile)

# Plot the fits GEV GPD fits
plot(AnGEV,type="primary")
plot(POTGP,type="primary")

