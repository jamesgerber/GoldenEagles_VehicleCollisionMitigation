% This is a script which will -in theory- run the codes necessary to
% reproduce the results which are presented in Lonsdorf et al [currently in
% review at JWM]



% Note that while we are here sharing the codes, we are sharing
% the full set of data only to researchers who put in a request.  We are
% doing this so that we can know who has the data.  Requests can be made
% via e-mail to sslater@hawkwatch.org


% note that if a new set of data is incorporated, getDeerCarcassData.m will
% need to be updated.  See the comments in that file and the end of
% getEagleUseHourData for an explanation of why and how.


% set up the paths
% four directories:
%        codes/  are the codes written for this research program
%    utilcodes/  are codes that are necessary for codes/ to run
%    datafiles/  data files which codes/ will look for
%         util/  some usefile files 
setGOEAVCMpaths



%  Constants files.  Contains locations of datafiles, and some things users
%  may want to override.
GOEAVCMconstantsfile


% helper function that calls the main function
callEagleMortality

% Post-processing

% these functions, if called with no output arguments, will make figures.
FitDistributions_DeerCarcassPersistence
FitDistributions_ProbabilityOfScavenging
FitDistributions_UseHoursPerCarcassDay

% there are several other codes which make figures in the util/ directory