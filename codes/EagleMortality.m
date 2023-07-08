function [x,EagleMortalityPerCounty,EaglesPerCounty,CountyMortalityStructure]=EagleMortalityNew(paramvector);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Golden Eagle road carcass kill and saving model
%%%%
%%%% Authors:
%%%% Deepak Ray (dray@umn.edu)
%%%% James Gerber (jsgerber@umn.edu)
%%%% Eric Lonsdorf ()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%REPORT WILL BE THE DRAFT OF A MANUSCRIPT
%METHODS SECTION AND RESULTS SECTION
%KEEP WRITING AND DESCRIBE THE MONTE CARLO SIMULATION
%MAKE FLOW CHART ESP
%HOW MANY CARCASSES DO YOU PICK UP - SOME 'X' # OF CARCASSES
%MAY NOT BE PALATABLE - BUT ERIC HAS TALKED HIMSELF OUT OF IT
%
%
% here's a fun syntax:
%
% minimumparamvector=fminsearch('main',[30 2 .0008]);
% [~,EagleMortalityPerCounty,EaglesPerCounty]=main(minimumparamvector);
%
% [x,EagleMortalityPerCounty,EaglesPerCounty]=main([30 2 .0008]);
%
%  %%Paramvector = [k UseHourScale AvgAdMortality TwiceJuvMortality];
%
% for AvgAdMortality = 0.0004:.0002:.001;;
%  ksteps=[10:20:300];
%  Usteps=[1:1:10];
% for j=1:numel(ksteps);
%     for m=1:numel(Usteps);
%         [minval(j,m),EagleMortalityPerCounty,EaglesPerCounty]=main([ksteps(j) Usteps(m) AvgAdMortality]);
%     end
% end
%
% figure,surface(ksteps,Usteps,minval.');
% xlabel('k')
% ylabel('Use hour multiplier')
% title([' Params where WY eagle mortality = 0.01. ' ...
%  'Here AvgAdMortality=' num2str( AvgAdMortality)]);
% colorbar
% outputfig('force');
% end




MakeFile=0;
%SeparateIsScavengedCalculationFlag=0;  Can be removed
lengthofseason=180;
ReferenceEagleDensity=0.03;
Nrealizations=10;
RemovalIntervalVector=[0 1]% 3 7 14 30];
TestCountyFlag=0;




if nargin==0
    disp('just testing, right?')
    paramvector=[30 2 .0008];
end

% paramvector=[k UHscale avg_ad_coll_per_veh ]



% this is useless / leaving here so line numbers don't change
% switch getenv('USER')
%     case 'jsgerber'
%         basedir='~/sandbox/jsg182_AWWI_EagleStrikes/outputfiles/';
%     otherwise
%         error('need to define basedir')
% end



%initialize some input datasets
%[FIPS,sq_km,Estimated_eagles,CountyName,County_SU,removal_interval_prescribed]=GetInitialEMParams();

switch TestCountyFlag
    case 0
        [FIPS,sq_km,CountyName]=GetWyomingCountyInfo;
        
    case 1;
        warndlg('Test Counties:  100 ; 10000 km^2, 10 deer on 25vph roads');
        FIPS=[101 103];
        sq_km=[100 10000];
        CountyName={'TestCounty1','TestCounty2'};
    case 2
        clear CountyName
        warndlg('Test Counties, vph changes, 10 deer per road, 10000 km^2 per county');
        
        vphvect=[10:5:100];
        
        for j=1:numel(vphvect);
            FIPS(j)=(199+j*2);
            sq_km(j)=10000;
            CountyName{j}=['TestCountyVPH' int2str(vphvect(j))];
        end
end



%% Initialization steps
% Initialize CycleThroughCarcassDays via IS ("Initialization Structure")

clear IS

% Key parameters: default values
IS.collisionperVxE=0.001;
IS.k=(10+35)/2.0; %50% disturbed
IS.UHscale=1; % reference density correction




IS.k=paramvector(1);
IS.UHscale=paramvector(2);
IS.collisionperVxE=paramvector(3);


% now tricky syntax to CycleThroughCarcassDays
%CycleThroughCarcassDays('Initialize',IS);    %



%do carcass day model fit
[dayvect2,avg_tot_usehr_percarcday_distribution1,dcpdata2]=FitDistributions_UseHoursPerCarcassDay;
[dayvect1,ProbabilityOfScavenging,dcpdata1]=FitDistributions_ProbabilityOfScavenging;
[dayvect,DeerCarcPersistenceProbaVect,dcpdata]=FitDistributions_DeerCarcassPersistence;%even though we have 1-88 days and need to determine probability of a
DCPcum=cumsum(DeerCarcPersistenceProbaVect);



%Cycle through each county

for jcounty=1:length(CountyName)  %jcounty loop
    
    Nmax=1e7;
    listoferfinvs=erfinv(rand(1,Nmax));
    erfinvcounter=0;
    
    fprintf('Evaluating %s FIPS:%d\n',CountyName{jcounty},FIPS(jcounty));
    
    
    
    
    %Different counties in Wyoming have a different set of roads (in terms
    %of VPH and road length and number of deer carcasses observed in each
    %road segment. So,
    %determine the observed small ungulates on roads in the county and the
    %vehicles per hour on those roads.
    
    switch TestCountyFlag
        case 0
            [deer_road,km_road,vph,road_types]=CarcassOnRoads(FIPS(jcounty));
        case 1
            deer_road=[0 1.5 2]';
            vph=[15 25 35];
        case 2
            
            deer_road=[25 25];
            vph=[1 1]*vphvect(jcounty);
    end
    clear M
    clear RemovalMat
    %Nrealizations is hardwired above.  set to 10 or so for developing
    for jreal=1:Nrealizations
        
        % Construct a Carcass Structure "CS"
        clear CSvector
        
        % Carcass Structure has the following fields
        %
        %     .VPH
        %     .RemovalInterval  % can be a vector
        %     .UseHoursPerDay
        %
        %     and has one element for each carcass.
        counter=0;  % this will count up the number of carcasses in this realization of this county.
        Ndeer=0;
        for jrt=1:numel(vph)   % road type loop
            % counting over every type of road
            % jrt = "j road type"
            numDeerOnThisRoadType=deer_road(jrt);
            % now round to nearest integer but statistically.  in other
            % words if there is 1.3 deer on road, there is a 30% chance
            % that you have 2 deer, a 70% chance you have 1 deer going
            % forward in simulation
            f=mod(numDeerOnThisRoadType,1); % f= fraction left over
            
            x=rand;
            
            if x>f
                numDeerOnThisRoadTypeInteger=floor(numDeerOnThisRoadType);
            else
                numDeerOnThisRoadTypeInteger=ceil(numDeerOnThisRoadType);
            end
            
            Ndeer(jrt)=numDeerOnThisRoadTypeInteger;
            % now preparing for modeling below, going to model each deer individually,
            % so get the characteristics associated with this deer into CS ("Carcass
            % Structre"
            
            
            
            
            
            
            for j=1:numDeerOnThisRoadTypeInteger
                clear CS
                
                CS.VPH=vph(jrt);
                CS.RemovalInterval=RemovalIntervalVector;
                
                counter=counter+1;
                CSvector(counter)=CS;
            end
        end
        % end of road type loop
        NumDeerThisCounty(jreal)=sum(Ndeer);
        
        %  for reference, to help understand codes below.  but calls are above
        %  to be outside of loop
        %     [dayvect2,avg_tot_usehr_percarcday_distribution1,dcpdata2]=FitDistributions_UseHoursPerCarcassDay;
        %     [dayvect1,ProbabilityOfScavenging,dcpdata1]=FitDistributions_ProbabilityOfScavenging;
        %     [dayvect,DeerCarcPersistenceProbaVect,dcpdata]=FitDistributions_DeerCarcassPersistence;
        %     DCPcum=cumsum(DeerCarcPersistenceProbaVect);
        
        
        
        % for each element and realization, need to construct vector of
        % use hours per day.
        for jv=1:numel(CSvector);
            
            CS=CSvector(jv);
            
            % how many days for this particular carcass x this particular realization?
            [NumDays]=min(find(DCPcum>rand));
            
            usehoursrealization=zeros(1,NumDays);
            for jd=1:NumDays
                
                
                %will carcass be scavenged ?
                %[dayvect1,ProbabilityOfScavenging,dcpdata1]=FitDistributions_ProbabilityOfScavenging;
                %                 if SeparateIsScavengedCalculationFlag==1
                %                     if rand<ProbabilityOfScavenging(jd)
                %                         % yes, going to be scavenged
                %
                %                         % mean use hours:
                %                         meanusehours=avg_tot_usehr_percarcday_distribution1(jd);
                %
                %                         % stochastic use hours:
                %                         usehoursrealization(jd)=GaussianDistribution_Mean_to_Realization(meanusehours);
                %                     else
                %                         % no scavenging
                %                         usehoursrealization(jd)=0;
                %                     end
                %                 else
                % below: theoretical distributions.
                meanusehours=avg_tot_usehr_percarcday_distribution1(jd).*ProbabilityOfScavenging(jd);
                %   usehoursrealization(jd)=GaussianDistribution_Mean_to_Realization(meanusehours);
                erfinvcounter=erfinvcounter+1;
                % this is how you invert a distribution of random
                % variables that are described by a Cauchy Dist.
                sigma=sqrt(pi)/sqrt(2)*meanusehours;
                
                usehoursrealization(jd)=sigma*sqrt(2)*listoferfinvs(erfinvcounter);
                
                
                %                 end
            end
            % what day of interval did this carcass appear?
            
            % now cycle through number of removal intervals ...
            % calculate total vph
            
            
            for jRI=1:numel(CSvector(jv).RemovalInterval);
                %  CS=CSvector(jv);
                RI=CSvector(jv).RemovalInterval(jRI);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % This is the heart of the algorithm right here   %
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                % we have a timeseries of use-hours per day, Day
                % carcass appeared, Removal Interval, VPH and the
                % external parameters (k,U,mu)
                
                if RI==0 | isinf(RI)
                    % this is a flag for no removal
                    RemovalFlag=0;
                    
                    Ndays=numel(usehoursrealization);  % confusing code, sorry ... how many days here?
                else
                    % calculate number of days carcass is around
                    % it will be the minimum of the number of days of
                    % calculated carass persistence or the days of
                    % interval between removals.
                    DOI=randi(RI);
                    if DOI < numel(usehoursrealization)
                        % this is a removal!!
                        Ndays=DOI;
                        RemovalFlag=1;
                    elseif  DOI == numel(usehoursrealization)
                        % this is a removal!!
                        Ndays=DOI;
                        usehoursrealization(Ndays)=usehoursrealization(Ndays)/2;
                        RemovalFlag=1;
                    else
                        % no removal
                        RemovalFlag=0;
                        Ndays=numel(usehoursrealization);
                    end
                end
                
                % here is where we pull everything together and calculate
                % chance of an eagle collision for this realization of a
                % carcass being there and number of eagles.
                % ok ... let's calculate exponent:  vehicles per hour x
                % use hours
                
                %                     IS.k=paramvector(1);
                %                     IS.UHscale=paramvector(2);
                %                     IS.collisionperVxE=paramvector(3);
                %
                k=IS.k;
                UHscale=IS.UHscale;
                t=CSvector(jv).VPH;
                theta=t^2/(t^2+k^2);
                
                H=(1-theta)*UHscale*sum(usehoursrealization(1:Ndays));
                VH=CSvector(jv).VPH*H;
                mu=IS.collisionperVxE;
                % M is for Mortality from Eq 1 of paper.  However, N in the paper is number of carcasses, where
                % here is the 3rd dimension M, so we'll have to sum over
                % that below.  In other words, strictly, speaking the sum
                % indicated in equation 1 needs to be carried out over the
                % 3rd dimension of the variable M here.
                % M's dimensions (in this code) thus are:
                % removal interval
                % which realization
                % which carcass
                M(jRI,jreal,jv)=(1-(1-mu)^VH);
                
                RemovalMat(jRI,jreal,jv)=RemovalFlag;
            end %% End of removal interval loop.
        end  % end of loop over 'jv' number of carcasses on roads in this simulation
        % how many days until this carcass is removed?
        %    CSvector(jv).Mortality=quantile(M,[.2 .5 .8],2);
        %    CSvector(jv).Removals=mean(RemovalMat,2);
    end   % number of realizations
    
    % now have done all of the realizations and need to figure out some
    % statistics.  Everything is in M.
    tmp=sum(M,3);
    Mortality=quantile(tmp,[.2 .5 .8],2);
    % dimensions of Mortality:  [removal intervals ] x 3, where 3 is
    % quantiles.
    
    tmp=sum(RemovalMat,3);
    Removals=mean(tmp,2);
    
    
    %     % now calculate total mortality for this county
    %     if numel(CSvector)==0
    %         keyboard
    %         CountyMortality=0;
    %     else
    %         CountyMortality=CSvector(1).Mortality*0;
    %         CountySURemovals=CSvector(1).Removals*0;
    %         for jv=1:numel(CSvector)
    %             CountyMortality=CountyMortality+CSvector(jv).Mortality;
    %             CountySURemovals=CountySURemovals+CSvector(jv).Removals;
    %         end
    %     end
    
    CountyMortalityStructure(jcounty).CountyMortality=Mortality;
    CountyMortalityStructure(jcounty).CountyName=CountyName{jcounty};
    CountyMortalityStructure(jcounty).RemovalIntervalVector=RemovalIntervalVector;
    CountyMortalityStructure(jcounty).CountySURemovals=Removals;
    CountyMortalityStructure(jcounty).SU=RemovalIntervalVector;
    CountyMortalityStructure(jcounty).NumDeerThisCounty=mean(NumDeerThisCounty);
    
end  % end of jcounty loop
% calculate total mortality

for j=1:numel(FIPS)
    CountyMortalityNoRemovals(j)=CountyMortalityStructure(j).CountyMortality(1,2);
    EaglesPerCounty(j)=sq_km(j)*ReferenceEagleDensity;
end

EagleMortalityPerCounty=CountyMortalityNoRemovals;

% now we calculate "x" this is something we might want to minimize so it
% can take advnatage of some built-in optimization functions.
x=(1-sum(CountyMortalityNoRemovals)/sum(EaglesPerCounty)).^2;






