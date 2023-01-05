function [err,ytheory,yout]=CauchyError(x);
% CauchyError - determine error for a cauchy distribution
%
%  Syntax
%  [err, yth,yout]=CauchyError(initialdataset);
%  [err, yth,yout]=CauchyError(x);
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


persistent y t
if numel(x)>1
    y=x;        
    t=1:numel(y);    
    y=y/sum(y);
    y=y(:).';    
end

gamma=x(1);

ytheory=(gamma* (1+(t./gamma).^2)).^(-1);
ytheory=ytheory/sum(ytheory);
err=sum((ytheory(1:end)-y(1:end)).^2);

yout=y;

%fprintf('Gamma:%f err:%f\n',gamma,err);






