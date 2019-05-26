# This code runs through a list of streamflow gauges, given files for annual peaks, 
# Peaks-Over-Threshold, and record length (for POT), then runs the R code Return_Periods.R 
# to calculate the 5-year return period based on each dataset.

# The output files, in the Return_Periods directory contain: (annual peaks)# records, shape parameter, min CI value, 5yr return period, max CI value, (POT)# records, shape parameter, min CI value, 5yr return period, max CI value,  % difference in 5-year return periods

# Note that package "extRemes" must be installed in the R library and the path set up to the version of R

mkdir Return_Periods

ls anpeaks | sed 's/.txt//g' > basinIDs.txt

# Run through the basin IDs
cat basinIDs.txt | while read -r f1; do

# Only use gauges with >10 years of data and >1 POT per year
	cp record_length/$f1.txt len.txt
	reclen=$(cut -d' ' -f3 len.txt)
	reclen="${reclen//[$'\t\r\n ']}"
	POTpy=$(cut -d' ' -f5 len.txt)
	POTpy="${POTpy//[$'\t\r\n ']}"
	
	if [[ ${reclen%.*} -gt 10 && ${POTpy%.*} -gt 1 ]] ; then
		cp anpeaks/$f1.txt anpeak.txt
		cp POT/$f1.txt POT.txt
		
	# Run R file to figure out return period data

		/cygdrive/C/'Program Files'/R/R-3.4.2/bin/Rscript Return_Periods.R --quiet
	
		tr '\r\n' ' ' < R_EVDs.txt | sed 's/ \+/ /g' > Return_Periods/$f1.txt
	fi
	
	sleep 60s
	
done # close id file while loop

rm anpeak.txt POT.txt len.txt R_EVDs.txt

