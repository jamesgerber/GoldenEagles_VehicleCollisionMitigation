function [dayvect,probavect,dcpdata]=FitDistributions_DeerCarcassPersistence;
% FitDistributions_DeerCarcassPersistence - fit for use hours per day
%
%  Syntax
%
%      [dayvect,probavect,dcpdata]=FitDistributions_DeerCarcassPersistence;
%
%        FitDistributions_DeerCarcassPersistence;  With no outputs, will
%        make a plot. 
%
%
%  this calls a function named 'getDeerCarcassData' which has some
%  hard-wired data in it.
%
%  J. Gerber
%  IonE
%  Nov 2021
%


y=getDeerCarcassData;
y(100)=0;
CauchyError(y);

x=fminsearch('CauchyError',[1]);


[err, yth,yout]=CauchyError(x);

t=1:numel(yth);

if nargout==0
    figure
    plot(t,yth);hold on;bar(t,yout)
    xlabel('days')
    title([' deer carcass persistence '])
    fattenplot
    
    figure
    
    hp=plot(t,y,'ok');
    set(hp,'MarkerFaceColor',[0 0 0])
        zeroxlim(0,40)

    xlabel('days')
    ylabel('Carcass persistence')
    title(['Carcass persistence interval (75 total carcasses)'])
    reallyreallyfattenplot
    
    figure
    plot(t,yth/max(yth)*100,'k');
    zeroxlim(0,40)
    xlabel('days')
    title([' Carcass persistence probability'])
    set(gca,'YTickLabel',{'0%','20%','40%','60%','80%','100%'})
    reallyreallyfattenplot

    figure
    plot(t,yth/max(yth)*100,'k',t,100*[1 1 1 .5 0 zeros(1,95)]);
    zeroxlim(0,40)
    xlabel('days')
    legend('HWI data','Expert')
    title([' Carcass persistence probability'])
    set(gca,'YTickLabel',{'0%','20%','40%','60%','80%','100%'})
    reallyreallyfattenplot

    
    figure
    hp=plot(t,yout,'ok')
    hold on
    plot(t,yth,'k')
        set(hp,'MarkerFaceColor',[0 0 0])
        zeroxlim(0,30)
    legend('data','model')
        ylabel('Persistance Probability')
        xlabel('Carcass Days')
        reallyreallyfattenplot

    
    
else
    dayvect=t;
    probavect=yth;
    dcpdata=y;
end


