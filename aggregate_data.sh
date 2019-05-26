# This code runs through a list of streamflow gauges, and aggregates the information for their return periods and characteristics

ls Return_Periods | sed 's/.txt//g' > FinalBasinIDs.txt # create Station ID file for the gages with return period data

# Loop through the Station ID file
cat FinalBasinIDs.txt | while read -r f1 ; do
	cp Return_Periods/$f1.txt tempRP
	echo $f1 > stnID

# check if the basin is included in the GAGES dataset, if so add the Return Period and characteristic info to the master files
	if grep -q $f1 GAGESII/conterm_basinid.txt; then
		grep $f1 GAGESII/conterm_basinid.txt | sed 's/\".*\"//' > basinchar
		cut -d',' -f3 basinchar > AreaSqKm 										# Watershed area in Sq Km
		cut -d',' -f5 basinchar > Lat 											# Latitude of stream gauge
		cut -d',' -f6 basinchar > Lon											# Longitude of stream gauge
	
		grep $f1 GAGESII/conterm_bas_morph.txt | cut -d',' -f2 > BasComp		# Watershed compactness ratio (Area/perimeter^2 * 100%)
	
		grep $f1 GAGESII/conterm_hydro.txt | cut -d',' -f3 > MaxOrder			# Maximum Strahler Stream Order (roughly the size of the stream/river)
	
		grep $f1 GAGESII/conterm_soils.txt > soils								
		cut -d',' -f2 soils > HGA												# Percent of watershed with Hydrologic Group A (well-drained) soils
		cut -d',' -f6 soils > HGD												# Percent of watershed with Hydrologic Group D (poorly drained) soils
	
		grep $f1 GAGESII/conterm_lc06_basin.txt | cut -d',' -f2 > DevPct		# Percent of watershed that is developed
	
		grep $f1 GAGESII/conterm_pop_infrastr.txt | cut -d',' -f5 > RdDens		# Road density of watershed (km of roads/Watershed Area in km^2)
	
		grep $f1 GAGESII/conterm_hydromod_dams.txt | cut -d',' -f3 > DmDens		# Dam density in watershed (#dams/100 km^2)
	
		paste stnID AreaSqKm Lat Lon BasComp MaxOrder HGA HGD DevPct RdDens DmDens >> All_Char_Data.txt
	
	
		paste -d' ' stnID tempRP >> All_Return_Period_Data.txt					# This file contains stnID (annual peaks)# records, shape parameter, min CI value, 5yr return period, max CI value, (POT)# records, shape parameter, min CI value, 5yr return period, max CI value,  % difference in 5-year return period
	fi
	
done

rm stnID tempRP AreaSqKm Lat Lon basinchar BasComp MaxOrder soils HGA HGD DevPct RdDens DmDens
