   
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


figure
plot(t(1:50),yth(1:50),'k');hold on;
patch([3 3 5 5 3],[.5 2.6 2.6 .5 .5],[1 1 1]*.5)

xlabel('days')
zeroxlim(0,25)
ylabel('hours')
title(['Use hours per carcass day'])
legend('HWI data','Expert')
reallyreallyfattenplot


% make big fat plots of fall-off of usehours per day that can be
% compared to expert elicitation


