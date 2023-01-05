% Here is a validation study to perform semi-analytically what we expect
% eagle mortality to be for a test case.


% This code doesn't actually run ... but it's a record of how we validated
% the code, so I'm providing it.  You'd have to copy and paste.


%First, for each carcass (with no scaling) what is the expected number of use-hours?


%do carcass day model fit
[dayvect2,avg_tot_usehr_percarcday_distribution1,dcpdata2]=FitDistributions_UseHoursPerCarcassDay;
[dayvect1,ProbabilityOfScavenging,dcpdata1]=FitDistributions_ProbabilityOfScavenging;
[dayvect,DeerCarcPersistenceProbaVect,dcpdata]=FitDistributions_DeerCarcassPersistence;%even though we have 1-88 days and need to determine probability of a
DCPcum=cumsum(DeerCarcPersistenceProbaVect);



% need to fit a distribution:

Nreal=1000;

for jc=1:Nreal
    
    
    [NumDays]=min(find(DCPcum>rand));
    
    % % %                 % code to test the above
    % % %                 for j=1:1e6
    % % %                     NumDays(j)=min(find(DCPcum>rand));
    % % %                 end
    % % %                 [N,x]=hist(NumDays,1000);
    % % %                 plot(dayvect,DeerCarcPersistenceProbaVect,x,N/sum(N))
    
    
    usehoursrealization=zeros(1,NumDays);
    for jd=1:NumDays
        
        %will carcass be scavenged ?
        %[dayvect1,ProbabilityOfScavenging,dcpdata1]=FitDistributions_ProbabilityOfScavenging;
        
        if rand<ProbabilityOfScavenging(jd)
            % yes, going to be scavenged
            
            % mean use hours:
            meanusehours=avg_tot_usehr_percarcday_distribution1(jd);
            
            % stochastic use hours:
            usehoursrealization(jd)=GaussianDistribution_Mean_to_Realization(meanusehours);
        else
            % no scavenging
            usehoursrealization(jd)=0;
        end
    end
    
    
    TotalUseHours(jc)=sum(usehoursrealization);
end


Hsum=mean(TotalUseHours);

% put on test flag

each county has 10 deer on 25 Vph roads, in counties of 100 and 10000 miles


mu=.0001
u=1
k=40
[minval,EagleMortalityPerCounty,EaglesPerCounty,CountyMortalityStructure]=EagleMortalityNew([k u mu]);
EagleMortalityPerCounty

t=25
V=t
theta=(t^2)/(t^2+k^2);

H=(1-theta)*u*Hsum;


M=1 - (1-mu).^(V*H)
10*M
% expected mortality per carcass = 0.0094



% now a distribution of mortality values:

for j=1:Nreal
    
    H=(1-theta)*u*TotalUseHours(j);
    
    Mvect(j)= 1 - (1-mu).^(V*H);
end

mean(Mvect)
median(Mvect)







