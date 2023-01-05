[dayvect,Pscav,dcpdata]=FitDistributions_ProbabilityOfScavenging;
 [dayvect,UseHoursPerday,dcpdata]=FitDistributions_UseHoursPerCarcassDay;


 figure
      plot(dayvect,Pscav.*UseHoursPerday,'k');hold on;
patch([3 3 5 5 3],[.5 2.6 2.6 .5 .5],[1 1 1]*.5)   

xlabel('days')
    zeroxlim(0,25)
    ylabel('hours')
    title(['Use hours per carcass day'])
    legend('HWI data','Expert')
    reallyreallyfattenplot