function [err,ytheory,yout]=CauchyErrorQuantile(x,ytemp,tautemp);
% CauchyError - determine error for a cauchy distribution
%
%  Syntax
%  [err, yth,yout]=CauchyErrorQuantile(t,y,tau);   % initialization syntax
%  [err, yth,yout]=CauchyErrorQuantile(x);
%
%   Difference between first two syntaxes is number of elements in the
%   argument to the function.
%
%   err = OLS error between the cauchy distribution specified by gamma=x
%   and the initial dataset
%
%  Note that this can be called as follows:
%   x=fminsearch('CauchyError',[1])
%
%
%  J Gerber
%  IonE
%  Nov, 2021

persistent y tau t
if nargin==3
    y= ytemp;
    tau=tautemp;
    t=x;
    return
end





gamma=x(1);
scale=x(2);

%t0=1:max(t);   
t0=1:100;

if nargout==3
    % this means being called not by fminsearch but rather to pull out the
    % theoretical curve.  have t extend out to 100.
    t0=1:100;
end

ytheory=(gamma* (1+(t0./gamma).^2)).^(-1);
%ytheory=exp(-gamma*t0.^1);
ytheory=ytheory/sum(ytheory);
ytheory=ytheory*scale;

% now for each of the data points (t,y) which are in the form 'carcass days
% (integer), use hours' get a theoretical use hours expression.
for m=1:numel(t)
    this_t=t(m);
    j=find(this_t==t0);
    ymodel(m)=ytheory(j);
end

% now ymodel is a vector of length(t) containing modeled use-hours, can
% calculate error.

% OLS error:
err=(sum((ymodel(1:end)-y(1:end)).^2))/numel(y);


% Quantileerror
TAU=tau;
YVALS=y;
WVALS=ones(size(y));
% Quantile error

N=2;

ii=ymodel < YVALS;
jj=ymodel  >= YVALS;
E= TAU*sum(abs(ymodel(ii)-YVALS(ii)).^N)  + ...
    (1-TAU)*sum(abs(ymodel(jj)-YVALS(jj)).^N);

maxdebug=0;
if maxdebug==1
    figure(10)
    plot(t0,ytheory,t,y,'o')
    title(['ERROR = ' num2str(E) ' x ' num2str(x(1)) ' ' num2str(x(2))]);
    drawnow
     pause
end


err=E;


yout=y;

%fprintf('Gamma:%f err:%f\n',gamma,err);






