# vis_stim
The scripts in this repository were written in MATLAB to read and analyze ECoG data downloaded from Labchart 

Code runs with "Data" folder in same location as scripts, filled with additional folders containing the experimental data for each animal (Trials 1-4, including a baseline "nb"). One channel is 0.1 Hz light stimulus 

SCRIPT KEY: 

median_PEN - collects penetration US cohort Data and finds the median RMS values for each trial or each light event, storing them in an accessible struct then calling median_SHAM

median_SHAM - collects penetration US cohort Data and finds the median RMS values for each trial or each event, storing them in an accessible struct, calls Harry_plotter or Harry_plotter2

Harry_Plotter - plots results from simple median analysis (one median RMS value/trial for each animal) 

Harry_PLotter2 - plots results median analysis of each running RMS light event (~58 median RMS values/trial for each animal) 

calc_baseline60sec - finds median RMS value in baseline to normalize animal data 

miniUS_Diag_stim - data processing/conditioning, called by median_PEN and median_SHAM for each trial 

super_looopy - runs experiment for one animal, producing a colormap imagesc plot for each trial 

super_US_diag_stim - data processing/conditioning, called by super_looopy
