function r=GaussianDistribution_Mean_to_Realization(meanvals)
% GaussianDistribution_Mean_to_Realization samples of a gaussian dist
%
%   This is intended to be used after calling FitDistributions_UseHoursPerCarcassDay
%
%SYNTAX
%   realizations=GaussianDistribution_Mean_to_Realization(meanvals)
%
%  using 1/2 gaussian distribituion
%
%  so CDF=erf(x/sqrt(sigma)/sqrt(2))  (see wikipedia)
%
%
%
%  Example
%
% [dayvect,probavect,dcpdata]=FitDistributions_UseHoursPerCarcassDay;
%
% figure
% plot(dayvect,probavect)
%hold on
%for m=1:numel(dayvect)
%    r=GaussianDistribution_Mean_to_Realization(probavect(m)*[1 1 1 1 1]);
%    plot(dayvect(m),r,'ok')
%    plot(dayvect(m),mean(r),'kd')
%end
%
% %reallyreallyfattenplot
% %zeroxlim(0,25)

N=1e6;
persistent counter listoferfinvs

if isempty(listoferfinvs)
    listoferfinvs=erfinv(rand(1,N));
    counter=1;
end



for j=1:numel(meanvals);
    
    mu=meanvals(j);  % the mean in standard notation
    
    
    sigma=sqrt(pi)/sqrt(2)*mu;
    
    % don't actually need these because erfinv exists.
    %   z=linspace(0,mu*5,10000);
    %   f=sqrt(2)/(sigma*sqrt(pi))*exp(-z.^2/(2*sigma.^2));
    
    
    %   r(j)=sigma*sqrt(2)*erfinv(rand);
    
    counter=counter+1;
    if counter>N
        counter=1;
        listoferfinvs=erfinv(rand(1,N));
    end
    r(j)=sigma*sqrt(2)*listoferfinvs(counter);
        
    
end
