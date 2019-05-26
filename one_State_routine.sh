# This script creates annual peak and POT data for all streamflow gauges within a state 
# with records over 10 years and at least 1 POT per year of data.   

# Annual peaks are downloaded from USGS Water Services and POT (Peak Over Threshold) is caluclated 
# as streamflow peaks over a threshold of 1 cms/sq. km separated by at least 12 hours from USGS 
# instantaneous streamflow values interpolated down to 1 minute.
 
# The program deafult is to run for New York, "ny" and the state can be updates in line 22 
# as the 2 letter state abbreviation "stateCd=__"
# the time and streamflow thresholds can be changed in peaks.c

# Requirements:
# the tool wget is used here, so you should be using a machine with
# RedHat Linux or cygwin with wget

# Create folders for the saved peak and discharge files
mkdir Flashy_ones
mkdir Flashy_ones/anpeaks
mkdir Flashy_ones/POT
mkdir Flashy_ones/record_length

# Download site numbers for a state
wget  -q "http://waterservices.usgs.gov/nwis/site/?format=rdb,1.0&stateCd=ny&outputDataTypeCd=iv,id&parameterCd=00060&hasDataTypeCd=iv,id"  --referer="http://waterservices.usgs.gov/" -O tempdl

# Organize the data into a names file and data file
grep "USGS" tempdl > temp1
cut -f2 temp1 > stn
cut -f3 temp1 > tempnames
cut -f14 temp1 > type
cut -f22 temp1 > startd
cut -c1-4 startd > syear
cut -c6-7 startd > smonth
cut -c9-10 startd > sday
cut -f23 temp1 > endd
cut -c1-4 endd > eyear
cut -c6-7 endd > emonth
cut -c9-10 endd > eday
cut -f24 temp1 > recno

#paste stn type recno syear smonth sday eyear emonth eday > state.txt
sed -e 's/ /_/g' tempnames > state_names.txt

# Make a new gauge file with sites where records are over 10 years and data is streamflow
cc choose_state_basins.c -o choose_state_basins.exe
./choose_state_basins.exe

# make sure c files are compiled
cc interp_record.c -o interp_record.exe
cc peaks.c -o peaks.exe

# make a copy of the guage file to mess up
cp state_out.txt state_copy

# Find the station number and dates from the gauges file and download the data
cat state_copy | while read -r f1 f2 f3 f4 f5 f6 f7 f8 f9; do

# download area of basin, only cotinue if the area exists
	wget -q "http://waterservices.usgs.gov/nwis/site/?format=rdb&sites=$f1&siteOutput=expanded"  --referer="http://waterservices.usgs.gov/" -O temparea
	grep $f1 temparea | cut -f30 > temparea2
	if [ -s temparea2 ]; then 
		
	# Download all streamflow values data
	    wget -q "http://waterservices.usgs.gov/nwis/iv/?format=rdb&sites=$f1&startDT=1960-01-01&parameterCd=00060"  --referer="http://waterservices.usgs.gov/" -O tempsf
	    grep $f1 tempsf | sed '1,2d'  > tempsf2          
	    cut -f3 tempsf2 > date
	    cut -c1-4 date > year
	    cut -c6-7 date > month
	    cut -c9-10 date > day
	    cut -c12-13 date > hour
	    cut -c15-16 date > minute
	    cut -f2 tempsf2 > stn
	    cut -f5 tempsf2 > value
		if [ ! -s value ]; then 	
			echo $f1
      		echo "instantaneous streamflow is empty."
       	fi
		
    # Save this file as interp_in temporarily
	   	paste -d" " stn year month day hour minute value > interp_in
				      
	# Interpret data to one minute time step
	   	./interp_record.exe
	          
	# check number of peaks over 1 cms/km^2
	   	./peaks.exe
          
    # if there are more than 2 POT per year, save the POT and length files and download the annual peaks
	   	if grep -q "yes" YNPOTpy; then 
	   		cp POT Flashy_ones/POT/$f1.txt
			cp len Flashy_ones/record_length/$f1.txt
			
			wget -q "http://nwis.waterdata.usgs.gov/nwis/peak?site_no=$f1&agency_cd=USGS&format=rdb"  --referer="nwis.waterdata.usgs.gov/nwis" -O anpeak
			grep $f1 anpeak | sed '1,2d' > Flashy_ones/anpeaks/$f1.txt
	   	fi
	
	else
		echo $f1
		echo "area is empty"
	fi #close if statement for area
done # close while loop for reading states file

# remove all un-needed files
 rm  date day eday emonth endd eyear hour interp_in len minute month POT recno sday sf1min smonth startd stn state_copy syear temp1 temp2 temparea temparea2 tempdl tempnames tempsf tempsf2 type value year YNPOYpy 













