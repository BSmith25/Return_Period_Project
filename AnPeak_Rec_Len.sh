cat basinIDs.txt | while read f1; do
	cp ../Flashy_basins/unit_vals/rec_lens/$f1.txt record_length/$f1.txt
	
	wget -q "http://nwis.waterdata.usgs.gov/nwis/peak?site_no=$f1&agency_cd=USGS&format=rdb"  --referer="nwis.waterdata.usgs.gov/nwis" -O anpeak
	grep $f1 anpeak | sed '1,2d' > anpeaks/$f1.txt

done