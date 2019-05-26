# Return_Period_Project
This project takes Peaks-Over-Threshold calculated from instantaneous USGS data and fits them to a GPD, then fits annual peaks to a GEV to see which is best for calculating return periods

The files and order to run them are as follows:

1. one_State_routine.sh: This shell script file dowloads all the USGS instantaneous streamflow sites for one state (can run for all states for a bigger database) then:
  a. runs choose_state_basins.exe to find gages with over 10 years of data
  b. downloads all instantaneous data for a gae site from waterservices.usgs.gov
  c. runs interp.exe to interpolate the data to a 1 minute time resolution
  d. runs peaks.exe to find the POT for the gage and saves it if there are > 2POT per year of data (based on Smith and Smith 2015, doi: 10.1175/JHM-D-14-0217.1)
  e. downloads all the annual peaks from USGS water services

  After step 1, the following directories and files would be created:
    Flashy_ones/anpeaks - contains all annual peak files with the gage id as filename
    Flashy_ones/POT - contains all peak over threshold files with the gage id as filename
    Flashy_ones/record_length - contains all record lengths with the gage id as filename

2. 

