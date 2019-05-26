# Return_Period_Project
This project takes Peaks-Over-Threshold calculated from instantaneous USGS data and fits them to a GPD, then fits annual peaks to a GEV to see which is best for calculating return periods

The files and order to run them are as follows:

1. one_State_routine.sh: This shell script file dowloads all the USGS instantaneous streamflow sites for one state (can run for all states for a bigger database) then:
  a. runs choose_state_basins.exe to find gages with over 10 years of data
  b. downloads all instantaneous data for a gage site from waterservices.usgs.gov
  c. runs interp.exe to interpolate the data to a 1 minute time resolution
  d. runs peaks.exe to find the POT for the gage and saves it if there are > 2POT per year of data (based on Smith and Smith 2015, doi: 10.1175/JHM-D-14-0217.1)
  e. downloads all the annual peaks from USGS water services

  After step 1, the following directories would be created:
    anpeaks - contains all annual peak files with the gage id as filename
    POT - contains all peak over threshold files with the gage id as filename
    record_length - contains all record lengths with the gage id as filename

2. Return_periods.sh runs return_periods.r to calculate return periods for all gages based on fitting POT to a GPD and annual peaks to a GEV.  To run, must install the R package "extRemes" and make sure the path is set to the correct version of R.  Also double check that file columns are correct - they may have gotten a bit off when updating code from different data sources.
  After step 2, the following directories would be created:
    Return_Periods - contains all return period data with the gage id as filename
    
3. aggregate_data.sh this script re-organizes all the data into a single file (All_Return_Period_Data.txt) to use for analysis.  In order to run this, USGS GAGES II Data must be diwnloaded from https://water.usgs.gov/GIS/metadata/usgswrd/XML/gagesII_Sept2011.xml

4. Analysis.R this code analizes the return perios data and potential impacts on which method to use.  Info on results is included in the comments.

