

% first call the constantsfiles

GOEAVCMconstantsfile

% script to call EagleMortality

fidout=fopen(EagleMortalityOutputFilename,'w');

[~,~,CountyName]=GetWyomingCountyInfo;
% "~" syntax tells matlab you don't need the output/makes cleaner code.

fprintf(fidout,'%s','CollisionMortality,k,ScalarMultiplier,RemovalInterval,code,deathsWY,mortalityWY');

for j=1:numel(CountyName);
    cn=CountyName{j};
    fprintf(fidout,',%s',[cn '_totalEagles,' cn '_SU,' cn '_SUremoved50p,' cn '_GEdeathNR50,' cn '_GEdeathWR50,' cn '_GEdeathNR20,' cn '_GEdeathWR20,' cn '_GEdeathNR80,' cn '_GEdeathWR80'  ]);
end
fprintf(fidout,'\n');

clear minval


% about to start a brute force search over JP and k space.    JP is "joint
% product" which is a product of U and C where U is use hours and C is
% collision probability.  k is traffic avoidance parameter.   We do the
% search over JP because eagle mortality is more or less independent of U *
% C.  (Think about it:  if Use hours goes up by 2 and collision probability
% goes down by 2, you'll get the same number of collisions.)  It's not
% perfectly independent - the probability expressions have to take into
% account higher-order things such as running out eagles to collide with.
% 
% One thing that makes the code below a bit unclear (in my opinion) is that
% EagleMortality takes a single parameter which is a three element vector
% ("paramvector") where paramvector = [k U C].  So just below here, I pick
% some arbitrary value of U and use that.
%
% Since the three parameters correspond to the numerical expressions in the
% paper, I'm keeping this syntax for EagleMortality.
for m=1:numel(linearspacedJP)
    for j=1:numel(ksteps)
        
        AvgAdMortality = linearspacedJP(m); %actually this is the collision rate
        Usteps= 5;

        
        [minval(j,m),EagleMortalityPerCounty,EaglesPerCounty,CountyMortalityStructure]=EagleMortality([ksteps(j) Usteps AvgAdMortality]);
        deaths(j,m)=sum(EagleMortalityPerCounty);
        mortality(j,m)=sum(EagleMortalityPerCounty)/sum(EaglesPerCounty);
        
 %       [ksteps(j) Usteps*AvgAdMortality]
        
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
