
[basedir,b,c]=fileparts(which('setGOEAVCMpaths.m'));


EVSPhotoDataBaseDir=[basedir filesep 'datafiles' filesep];


EagleMortalityOutputFilename='EagleMortalityOutput.csv'



% used for the manuscript
%linearspacedJP=[.1:.1:2]*.0008;
%ksteps= [10:10:150];

linearspacedJP=[.1:.4:2]*.0008;
ksteps= [10:30:150];