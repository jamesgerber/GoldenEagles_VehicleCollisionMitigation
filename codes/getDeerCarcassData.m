function [data,counts]=getDeerCarcassData;

% This function returns hard-coded Deer Carcass Persistence data.
%  first output element is a vector whos Nth element is the number of deer
%  carcasses whose observed persistence is N days.
%
%  second output is this data reformatted to give counts.

data=[11
8
7
4
2
3
1
2
6
2
2
5
1
2
4
0
1
2
1
0
0
0
0
0
0
0
0
1
0
1
0
0
2
1
0
0
0
0
0
0
0
1
0
0
0
0
0
0
0
1
0
0
0
0
0
0
0
0
0
1
0
0
0
0
0
0
0
1
0
0
0
0
0
0
0
1
0
0
0
0
0
0
0
0
0
0
0
1];

z=[];
for j=1:numel(data)
    
    x=data(j);
    if x>0
    z=[z j*ones(1,x)];
    end
end
counts=z;
    
    
