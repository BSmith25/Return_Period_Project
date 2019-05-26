# This program reads in data on watershed characteristics and return periods for many USGS stream gages that fit the criteria:
# > 10 years of instantaneous streamflow data, > 1 POT per year, included in the USGS GAGESII dataset, and east of the Rockies 
# The program analyzes 95% CIs for the 5-year return periods calculated by two methods:
# 1) Annual Peaks (anpeaks) fit to a GEV 
# 2) Peaks Over Threshold (POT) fit to a GPD with a threshold of 1 m^3/s/km^2 and de-clustering time threshold of 6 hours


# Input files are:
# All_Return_Period_Data.txt with a format of:  stnID (annual peaks)# records, shape parameter, min CI value, 5yr return period, max CI value, (POT)# records, shape parameter, min CI value, 5yr return period, max CI value,  % difference in 5-year return period
# All_Char_Data.txt with a format of: stnID AreaSqKm Lat Lon BasComp MaxOrder HGA HGD DevPct RdDens DmDens


# Load Packages (need to install these before running the program)
library(ggplot2)
library(reshape)

# Open Datasets
All_Return_Period_Data = read.csv("C:/Return_Period_Project/All_Return_Period_Data.txt", sep="")
All_Char_Data = read.csv("C:/Return_Period_Project/All_Char_Data.txt",sep="\t")

# Make a density plot of the 5 year return period Percent Difference data
JustPctDiff=data.frame(PctDiff=All_Return_Period_Data$PctDiff*100)
ggplot(JustPctDiff,aes(x=PctDiff))+geom_density(color="lightskyblue3",fill="lightskyblue3",alpha=.5)+labs(title="Percent Difference between 5-year Return\nPeriods for Annual Peak and POT Methods",x="5yr Return Period Percent Difference", y="Density")+ theme(plot.title = element_text(hjust = 0.5))
# Those are some large differences!

# Compare Shape Parameters for the two methods in a box plot
# ShapeParams=data.frame(Anpeak=All_Return_Period_Data$AnpeakShape,POT=All_Return_Period_Data$POTShape)
# LongShapeParams=melt(ShapeParams)
# ggplot(LongShapeParams,aes(x=variable,y=value))+geom_boxplot(alpha=.6,fill="lightskyblue3",color="navyblue")+scale_x_discrete(name="Method")+scale_y_continuous(name="Shape Parameter")+labs(title="Shape Parameters for Annual Peak\nand POT Methods")+ theme(plot.title = element_text(hjust = 0.5))
# Pretty similar!

# Compare widths of the 95% CI (in width/T5 value)
Widths=data.frame(Anpeaks=(All_Return_Period_Data$AnpeakMax-All_Return_Period_Data$AnpeakMin)/All_Return_Period_Data$AnpeakT5,POT=(All_Return_Period_Data$POTMax-All_Return_Period_Data$POTMin)/All_Return_Period_Data$POTT5)
#LongCIWidths=melt(Widths)
#ggplot(LongCIWidths,aes(x=variable,y=value))+geom_boxplot(alpha=.6,fill="salmon2",color="red4")+scale_x_discrete(name="Method")+scale_y_continuous(name="Normalized CI Width")+labs(title="CI Width/5 year Return Periods\n for Annual Peak and POT Methods")+ theme(plot.title = element_text(hjust = 0.5))
# Yikes, the POT/GPD fit looks pretty uncertain

# How do percent difference and CI width relate? i.e. Are large % differences driven by uncertainty in the POT distribution fit?
par(mar=c(5, 6, 4, 2) + 0.1)
plot(Widths$POT,All_Return_Period_Data$PctDiff*100,col="steelblue",pch=16,xlab="Width of 5yr Return Period CI using POT Method",ylab="Percent Difference between 5-year Return\nPeriods for Annual Peak and POT Methods")
# Large % differences seem to be caused by uncertainty in the POT GPD fit

# WWhat correlates with greater POT CI widths?
CMatrix=cor(cbind(Widths$POT,All_Char_Data[,-1]),method="kendall")
LongCMatrix=melt(CMatrix)
ggplot(data=LongCMatrix,aes(x=X1,y=X2,fill=value))+geom_tile()+scale_fill_gradient2(low="steelblue4",high="red4",mid="white",midpoint=0,limit=c(-1,1),space="Lab",name="Kendall's Tau")+theme(axis.title.x=element_blank(),axis.title.y=element_blank(),axis.text.x=element_text(angle=90,hjust=1,vjust=.5),plot.title = element_text(hjust = 0.5))+labs(title="Heat Map for Correlations between Hydrologic Parameters and\nWidth of 5yr Return Period CI using POT Method")
# Development increases the certainty of the POT/GPD fit

# If more development means less uncertainty in the POT Return Period - is it because of fewer POT?
#par(mar=c(5, 6, 4, 2) + 0.1)
#plot(All_Return_Period_Data$NumPOT,Widths$POT,col="steelblue",pch=16,ylab="Width of CI for 5-Year Return\nPeriod using POT",xlab="Number of POTs")
# Yes, more POT appears to decrease uncertainty

# So, is there ever a level of development where POT is more certain than Annual Peaks?
WidthDev=data.frame(Percent_Developed=All_Char_Data$DevPct,POT=Widths$POT,AnnualPeaks=Widths$Anpeaks)
LongWidthDev=melt(WidthDev,id.var="Percent_Developed")
ggplot(LongWidthDev,aes(x=Percent_Developed,y=value,col=variable))+geom_point()+scale_color_manual(values=c("lightskyblue3","salmon2"))+geom_smooth()+scale_x_continuous(name="Watershed Percent Developed")+scale_y_continuous(name="Width of 5yr Return Period CI")+ theme(legend.title=element_blank())
# No!  Just use the Annual Peaks! 

