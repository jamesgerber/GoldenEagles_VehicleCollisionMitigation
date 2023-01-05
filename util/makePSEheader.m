% make a header for ParameterSpaceExplorationFiles

CountyName={'Albany',...
    'Big Horn',...
    'Campbell',...
    'Carbon',...
    'Converse',...
    'Crook',...
    'Fremont',...
    'Goshen',...
    'Hot Springs',...
    'Johnson',...
    'Laramie',...
    'Lincoln',...
    'Natrona',...
    'Niobrara',...
    'Park',...
    'Platte',...
    'Sheridan',...
    'Sublette',...
    'Sweetwater',...
    'Teton',...
    'Uinta',...
    'Washakie',...
    'Weston'};

fid=fopen('PSEheader.txt','w');

fprintf(fid,'AdultCollision,k,ScalarMult,Error,RemovalInterval');



for j=1:numel(CountyName)
    
    cn=CountyName{j};
    
    fprintf(fid,[',' cn '_GE']);
    fprintf(fid,[',' cn '_SU']);
    fprintf(fid,[',' cn '_deathNR50']);
    fprintf(fid,[',' cn '_deathR50']);
    fprintf(fid,[',' cn '_deathR20']);
    fprintf(fid,[',' cn '_deathR80']);
end

fprintf(fid,',ignore');

fprintf(fid,'\n')

fclose(fid)
    
    
% useful command
if 3==4
    
    !cat parameterSpaceexploration_3.csv | fgrep -v GE > noheader.csv
    !cat PSEheader.txt noheader.csv > PSEwithheader.csv
    
    % code to combine with pse_4
    !cat parameterSpaceexploration_4.csv | fgrep -v GE > noheader4.csv
    !cat PSEwithheader.csv  noheader4.csv > PSEwithheader2.csv

    % code to combine with pse_4
    !cat parameterSpaceexploration_2params.csv | fgrep -v Ad > noheader4.csv
    !cat PSEheader.txt  noheader4.csv > argh.csv
    
    

    
end
