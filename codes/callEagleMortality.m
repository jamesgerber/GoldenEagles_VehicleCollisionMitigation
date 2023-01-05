

% first call the constantsfiles

GOEAVCMconstantsfile

% script to call EagleMortality

fidout=fopen(EagleMortalityOutputFilename,'w');

% call with default parameters just to get the County names.
[minval,EagleMortalityPerCounty,EaglesPerCounty,CountyMortalityStructure]=EagleMortality;

fprintf(fidout,'%s','CollisionMortality,k,ScalarMultiplier,RemovalInterval,code,deathsWY,mortalityWY');

for j=1:numel(CountyMortalityStructure);
    cn=CountyMortalityStructure(j).CountyName;
    fprintf(fidout,',%s',[cn '_totalEagles,' cn '_SU,' cn '_SUremoved50p,' cn '_GEdeathNR50,' cn '_GEdeathWR50,' cn '_GEdeathNR20,' cn '_GEdeathWR20,' cn '_GEdeathNR80,' cn '_GEdeathWR80'  ])
end
fprintf(fidout,'\n');

clear minval

for m=1:numel(linearspacedJP)
    
    AvgAdMortality = linearspacedJP(m); %actually this is the collision rate
    Usteps= 5; 
    for j=1:numel(ksteps)
        [minval(j,m),EagleMortalityPerCounty,EaglesPerCounty,CountyMortalityStructure]=EagleMortality([ksteps(j) Usteps AvgAdMortality]);
        deaths(j,m)=sum(EagleMortalityPerCounty);
        mortality(j,m)=sum(EagleMortalityPerCounty)/sum(EaglesPerCounty);
        
        [ksteps(j) Usteps*AvgAdMortality]
        
        RIV=CountyMortalityStructure(1).RemovalIntervalVector;
        
        code=[num2str(AvgAdMortality) '_' num2str(ksteps(j)) '_' num2str(Usteps)];
        
        
        for jRI=1:numel(RIV);
            RI=RIV(jRI);
            
            % calculate
            
            
            
            fprintf(fidout,'%f,%f,%f,%f,%s,%f,%f',AvgAdMortality,ksteps(j),Usteps,RI,code,deaths(j,m),mortality(j,m));
            
            for jcty=1:numel(CountyMortalityStructure);
                CMS=CountyMortalityStructure(jcty);
                
                TotalEagles=EaglesPerCounty(jcty);
                SU=CMS.NumDeerThisCounty;
                SUremoved=CMS.CountySURemovals(jRI);
                
                GEdeathNR50=CMS.CountyMortality(1,2);
                GEdeathNR20=CMS.CountyMortality(1,1);
                GEdeathNR80=CMS.CountyMortality(1,3);
                GEdeathWR50=CMS.CountyMortality(jRI,2);
                GEdeathWR20=CMS.CountyMortality(jRI,1);
                GEdeathWR80=CMS.CountyMortality(jRI,3);
                
                
                fprintf(fidout,',%f,%f,%f,%f,%f,%f,%f,%f,%f',TotalEagles,SU,SUremoved,GEdeathNR50,GEdeathWR50,GEdeathNR20,GEdeathWR20,GEdeathNR80,GEdeathWR80);
            end
            fprintf(fidout,'\n');
            
        end
    end
end




figure,surface(ksteps,linearspacedJP,minval.');
xlabel('k')
ylabel('Multi-eagle collision proba impact')
title([' Params where WY eagle mortality = 0.01. ' ...
    ]);
colorbar



fclose(fidout);


figure,surface(ksteps,linearspacedJP*1000,minval.');
xlabel(' Traffic Avoidance Parameter ')
ylabel(' Collision Likelihood Parameter (*1000) ')
shading interp
title([' WY eagle mortality agreement '    ]);
reallyreallyfattenplot
colorbar


figure,surface(ksteps,linearspacedJP*1000,mortality.');


% slightly different graphcs code used in making figures in paper
cmap=colormap('parula');
newmap=stretchcolormap(cmap,0,.04,.01);
colormap(newmap)
caxis([0 .04]);
xlabel(' Traffic Avoidance Parameter ')
ylabel(' Collision Likelihood Parameter (*1000) ')
shading interp
title([' WY eagle mortality  '    ]);
reallyreallyfattenplot
colorbar
hold on
[c,h]=contour(ksteps,linearspacedJP*1000,mortality.',[.01 .01])
% ZD=h.ZData+100;
% set(h,'ZData',ZD)
% set(h,'LineWidth',10)
% set(h,'LineColor',[0 0 0])
h=plot3(c(1,2:end),c(2,2:end),ones(size(c(1,2:end)))+100)
set(h,'LineWidth',2)
set(h,'Color',[0 0 0])
