#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
** NAME
**            chose_state_basins.c
**
** SYNOPSIS
**            change_state_basins.exe
**
**            Compiles with:
**            cc change_state_basins.c  -o change_state_basins.exe
** DESCRIPTION
	this program takes arranged state gage ID data and filters to streamflow data (code 0600) with at least 10 years of observations
	input files:	state.txt data file for all gages in state, columns are: stnid typecode #records startyear startmonth startday endyear endmonth endday
					state_names.txt a file of all station names
	output files:	state_out.txt output file of all streamflow gages with records over 10 years, columns are: stnid typecode #records startyear startmonth startday endyear endmonth endday
					state_names_out.txt names of stations in state_out.txt 
			
**************************************************/


void main(int argc, char **argv){
	FILE  *datafile,*namefile,*outfilea, *outfileb;
	int  recno, syear, smonth, sday, eyear, emonth, eday;
	char type[5], sname[75], stn[10];

    /**** open state data file ****/
     if((datafile=fopen("state.txt","r")) == NULL)  {
        printf("cannot open state data file \n");
        exit(1);    
	}

    /**** open state name file ****/
    if((namefile=fopen("state_names.txt","r")) == NULL)  {
        printf("cannot state names file \n");
        exit(1);    
	}

	/**** open output file a ****/
 	if((outfilea=fopen("state_out.txt","w")) == NULL)  {
   		printf("cannot open output file a \n");
   		exit(1);    
	}

	/**** open output file b ****/
 	if((outfileb=fopen("state_names_out.txt","w")) == NULL)  {
   		printf("cannot open names output file a \n");
   		exit(1);    
	}
        
        /**** Find stations with discharge data (code 00060) and at least 3 years of data ****/
    while((fscanf(datafile,"%s %s %d %d %d %d %d %d %d \n", stn, type, &recno, &syear, &smonth, &sday, &eyear, &emonth, &eday) != EOF)) {
		fscanf(namefile,"%s \n",sname);
        if (strncmp(type,"00060",5)==0 && eyear-syear >= 10) {
		/*** pre-2007 water year ****/
			fprintf(outfilea,"%s \t %s \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n", stn, type, recno, syear, smonth, sday, eyear, emonth, eday);
			fprintf(outfileb,"%s \n",sname);
		}/*end of if*/
	} /*end of while*/
    fclose(outfilea);
    fclose(outfileb);
    fclose(datafile);
    fclose(namefile);
} /*end of main*/
	
