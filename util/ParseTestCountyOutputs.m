a=readgenericcsv('EagleMortalityOutput4.csv');
avos=sov2vos(a)
%%
idx=200;
M0=.005;


RemovalInterval=3;


vphvect=10:10:100;



%  CollisionMortality: [480×1 double]
%                                 k: [480×1 double]
%                  ScalarMultiplier: [480×1 double]
%                   RemovalInterval: [480×1 double]
%                              code: {480×1 cell}
%                          deathsWY: [480×1 double]
%                       mortalityWY: [480×1 double]


WYmortality=a.mortalityWY;
kvect=a.k;


idxk=find(kvect==30 & a.RemovalInterval==0);


[~,jj]=min((a.mortalityWY(idxk)-M0).^2)
idx0=idxk(jj);
idx3=idx0+2;

a.k(idx)

for j=1:vphvect
    vph=vphvect(j);
    tcn=['TestCountyVPH' int2str(vph)];
    deadGOEANR(j)=a.([tcn '_GEdeathNR50'])(idx0);
    deadGOEAWR(j)=a.([tcn '_GEdeathWR50'])(idx3);
    totalGOEA1(j)=a.([tcn '_totalEagles'])(idx0);
    SUremoved(j)=a.([tcn '_SUremoved50p'])(idx3);
end

eaglessaved=deadGOEANR-deadGOEAWR
eaglessavedperSUremoved1=eaglessaved./SUremoved



idxk=find(kvect==70 & a.RemovalInterval==0);


[~,jj]=min((a.mortalityWY(idxk)-M0).^2)
idx0=idxk(jj);
idx3=idx0+2;

a.k(idx)

for j=1:vphvect
    vph=vphvect(j);
    tcn=['TestCountyVPH' int2str(vph)];
    deadGOEANR(j)=a.([tcn '_GEdeathNR50'])(idx0);
    deadGOEAWR(j)=a.([tcn '_GEdeathWR50'])(idx3);
    totalGOEA1(j)=a.([tcn '_totalEagles'])(idx0);
    SUremoved(j)=a.([tcn '_SUremoved50p'])(idx3);
end

eaglessaved=deadGOEANR-deadGOEAWR
eaglessavedperSUremoved2=eaglessaved./SUremoved



figure
plot(vphvect,eaglessavedperSUremoved1,'k:',vphvect,eaglessavedperSUremoved2,'k')
xlabel('vph')
title('Eagles saved per SU removed, 3 day intervals')
ylabel('Eagles / SU')
legend('k=30 vph','k=70 vph')
reallyfattenplot



