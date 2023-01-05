function [dayvect,probavect,dcpdata]=FitDistributions_ProbabilityOfScavenging(datafit);
% FitDistributions_ProbabilityOfScavenging - fit for use hours per day
%
%  Syntax
%
%      [dayvect,probavect,dcpdata]=FitDistributions_ProbabilityOfScavenging;
%
%      [dayvect,probavect,dcpdata]=FitDistributions_ProbabilityOfScavenging(datafit);
%
%     Where datafit can be one of the following:
%        'alleaglescomplete'  % both ge and be, complete and incomplete sequences
%        'alleaglesallsightings'  % both ge and be, only complete views
%        'goldeneaglescomplete'  % only golden eagles, only complete views
%        (goldeneaglescomplete = DEFAULT)
%        
%
%        FitDistributions_ProbabilityOfScavenging;  With no outputs, will
%        make a plot. 
%
%
%  this calls a function named 'getEagleUseHourData'
%
%  J Gerber
%  IonE
%  Nov, 2021

[carcassdays,usehours,CamID]=getEagleUseHourData('goldeneaglescomplete');

tmax=max(carcassdays)+5;


[N,edges]=histcounts(carcassdays,.5:1:(tmax+0.5));



t=1:tmax;
y=N/numel(unique(CamID));


tau=0.5;
CauchyErrorQuantile(t,y,tau);

x=fminsearch('CauchyErrorQuantile',[1 1]);


[err, yth,yout]=CauchyErrorQuantile(x);

t=1:numel(yth);

if nargout==0
    figure
    plot(t(1:30),yth(1:30));hold on;bar(t(1:numel(yout)),yout)
    xlabel('Carcass Days')
       % title([' deer carcass scavenging likelihood '])
    fattenplot
    
    figure
    plot(t(1:numel(yout)),yout,'k+',t(1:50),yth(1:50),'k')
    xlabel('Carcass Days')
    ylabel('Scavenging Probability')
    zeroxlim(0,30)
  %  title([' Deer carcass scavenging likelihood '])
    legend('data','model')
    reallyreallyfattenplot
    
else
    dayvect=t;
    probavect=yth;
    dcpdata=yout;
end


