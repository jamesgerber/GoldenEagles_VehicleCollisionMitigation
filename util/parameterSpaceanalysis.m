%(1) No removal at all then each of these counties have 1% mortality of WY, 
%but what is the mortality for Lincoln county etc. counties (some of the SW WY counties)

%(2) For removal interval of say 1 day or 7 days compute GE saved (y axis) 
%in entire WY and x-axis is (scalar multiplier, collision rate, and k).

%for #1, to be clear, 
%I"m imagining a graph like the one in the attached photo.    
%You could have scalar multiplier (u) or collision rate (theta) along the x-axis as well.
%for both (1) and (2) you are picking u,theta,or k for the x axis. 


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






%number of data points with least error to analyze

removal_interval=1; %1 day removal interval

county=12; %Lincoln=12






M = readmatrix('parameterSpaceexploration_3.csv');

%sort on error and get 'n' number of points
[~,idx] = sort(M(:,4)); 
sortedM = M(idx,:);

choppedM=sortedM(1:n,:);

% ii=find(sortedM(:,4) == 0);
% noerror=length(ii);
%sorted output based on ascending values (min to max) of error (4th column)



county_index=5+(county-1)*6;
mortality_county=choppedM(:,county_index+3)./choppedM(:,county_index+1);
ScalarMultiplier_county=choppedM(:,3); %u
AdultCollisionRate_county=choppedM(:,1); %theta
k_county=choppedM(:,2); %k



%%%%Figure 1 - mortality = GE death from no removal / total GE
%all removal days included

figure

subplot(3,1,1);
hold on;
scatter(ScalarMultiplier_county,mortality_county);
xlabel('Scalar Multiplier')
ylabel('GE mortality fraction');
title(CountyName{county});


subplot(3,1,2);
scatter(AdultCollisionRate_county,mortality_county);
xlabel('AdultCollisionRate')
ylabel('GE mortality fraction');

subplot(3,1,3);
scatter(k_county,mortality_county);
xlabel('k')
ylabel('GE mortality fraction');


%%%%Figure 2
%for fixed removal day - GE saved
ii=find(choppedM(:,5) == removal_interval);

GE_saved=(choppedM(ii,county_index+3)-choppedM(ii,county_index+4));

ScalarMultiplier_county=choppedM(ii,3); %u
AdultCollisionRate_county=choppedM(ii,1); %theta
k_county=choppedM(ii,2); %k

figure;
subplot(3,1,1);
hold on;

scatter(ScalarMultiplier_county,GE_saved);
xlabel('Scalar Multiplier')
ylabel('GE saved');
title(sprintf('%s removal interval %d day',CountyName{county},removal_interval));


subplot(3,1,2);
scatter(AdultCollisionRate_county,GE_saved);
xlabel('AdultCollisionRate')
ylabel('GE saved');

subplot(3,1,3);
scatter(k_county,GE_saved);
xlabel('k')
ylabel('GE saved');


%These are the various columns in M

%Column 1: AdultCollisionRate
%Column 2: k
%Column 3: ScalarMultiplier
%Column 4: Error
%Column 5: Removal_interval

%Columns 6:11 (6 columns)
%Column 6: Albany_GE,
%Column 7: Albany_SUremoved50p
%Column 8: Albany_GE_deathNR50p
%Column 9: Albany_GE_deathR50p
%Column 10: Albany_GE_deathR20p
%Column 11: Albany_GE_deathR80p

%Column 12:17 Big Horn
%Column 18:23 Campbell
%Column 24:29 Carbon
%Column 30:35 Converse
%Column 36:41 Crook
%Column 42:47 Fremont
%Column 48:53 Goshen
%Column 54:59 Hot Springs
%Column 60:65 Johnson
%Column 66:71 Laramie
%Column 72:77 Lincoln
%Column 78:83 Natrona
%Column 84:89 Niobrara
%Column 90:95 Park
%Column 96:101 Platte
%Column 102:107 Sheridan
%Column 108:113 Sublette
%Column 114:119 Sweetwater
%Column 120:125 Teton
%Column 126:131 Uinta
%Column 132:137 Washakie
%Column 138:143 Weston





