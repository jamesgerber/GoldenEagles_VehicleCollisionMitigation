function [dayvect,probavect,dcpdata]=FitDistributions_UseHoursPerCarcassDay(datafit);
% FitDistributions_UseHoursPerCarcassDay - fit for use hours per day
%
%  Syntax
%
%      [dayvect,probavect,dcpdata]=FitDistributions_UseHoursPerCarcassDay;
%
%      [dayvect,probavect,dcpdata]=FitDistributions_UseHoursPerCarcassDay(datafit);
%
%     Where datafit can be one of the following:
%        'alleaglescomplete'  % both ge and be, complete and incomplete sequences
%        'alleaglesallsightings'  % both ge and be, only complete views
%        'goldeneaglescomplete'  % only golden eagles, only complete views
%        (goldeneaglescomplete = DEFAULT)
%        
%
%        FitDistributions_DeerCarcassPersistence;  With no outputs, will
%        make a plot. 
%
%
%  this calls a function named 'getEagleUseHourData'
%
%  J Gerber
%  IonE
%  Nov, 2021
if nargin==0
    datafit='goldeneaglescomplete';
end
[carcassdays,usehours,CamID]=getEagleUseHourData(datafit);


tau=0.50;
CauchyErrorQuantile(carcassdays,usehours,tau);

x=fminsearch('CauchyErrorQuantile',[1 1]);


[err, yth,yout]=CauchyErrorQuantile(x);
%err

t=1:numel(yth);

if nargout==0
    figure
    plot(t(1:50),yth(1:50));hold on;plot(carcassdays,usehours,'o')    
    xlabel('days')
    title([' use hours per carcass day, Cauchy dist, OLS fit error = ' num2str(err)])
    fattenplot
    
    figure
    plot(carcassdays,usehours,'ok')    
    xlabel('days')
    zeroxlim(0,25)
    ylabel('hours')
    title(['Use hours per carcass day'])
    reallyreallyfattenplot
    
    figure
    plot(t(1:50),yth(1:50),'k');hold on;
    patch([3 3 5 5 3],[.5 2.6 2.6 .5 .5],[1 1 1]*.5)
    
    xlabel('days')
    zeroxlim(0,25)
    ylabel('hours')
    title(['Use hours per carcass day'])
    legend('HWI data','Expert')
    reallyreallyfattenplot
      
    
       
    figure
    plot(carcassdays,usehours,'ok',t(1:30),yth(1:30),'k')    
    xlabel('Carcass Days')
    zeroxlim(0,30)
    ylabel('Hours')
    legend('data','model')
  %  title(['Use hours per carcass day'])
    reallyreallyfattenplot
  
    
    
else
    dayvect=t;
    probavect=yth;
    dcpdata=yout;
end


