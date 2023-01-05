function [deer_road,km_road,vph,road_types]=CarcassOnRoads(countyFIPS)
% read in carcass on roads data, re-format
% written by Deepak Ray

%open and read in the vph file
    fidinr=fopen('WY_road_VPH_cty.csv');
    fidind=fopen('WY_deercarcass_VHP_cty.csv');
                 
    headerr=fgetl(fidinr);
    headerd=fgetl(fidind);
    
    ccr=strfind(headerr,sprintf(','));
    
    for i=1:length(ccr)-1
        
       countyfips=str2double(headerr(ccr(i)+1:ccr(i+1)-1));
       %fprintf('%d\n',countyfips);
       
       if countyfips == countyFIPS
           county_index=i;
       end
       
    end
    
    
    km_road=zeros(31,1);
    deer_road=zeros(31,1);
    
    %read in the raw km_road for this county
    for i=1:31
        
        oneLiner=fgetl(fidinr);
        ccr=strfind(oneLiner,sprintf(','));
        km_road(i)=str2double(oneLiner(ccr(county_index)+1:ccr(county_index+1)-1));
        
        oneLined=fgetl(fidind);
        ccd=strfind(oneLined,sprintf(','));
        deer_road(i)=str2double(oneLined(ccd(county_index)+1:ccd(county_index+1)-1));
        
    end
    
    
    fclose(fidinr);

    fclose(fidind);
    
       
    vph=[5
        15
        25
        35
        45
        55
        65
        75
        85
        95
        105
        115
        125
        135
        145
        155
        165
        175
        185
        195
        250
        350
        450
        550
        650
        750
        850
        950
        1050
        1150
        1200];
    
    
   
    
    
    
    
    
    
    
    
    
    
    ii=find(km_road == 0);
    
    n=length(ii);
    
    
    %make a smaller array removing those km_road and corresponding vph
    road_types=31-n;
    
    actual_vph=zeros(road_types,1);
    actual_km_road=zeros(road_types,1);
    actual_deer_road=zeros(road_types,1);
    
%     actual_removal_interval=zeros(road_types,1);
    
    
    
    
    n=1;
    for i=1:31
        %if km_road(i) > 0
        if deer_road(i) > 0
            %only study roads that have deer carcasses
            actual_vph(n)=vph(i);
            actual_km_road(n)=km_road(i);
            actual_deer_road(n)=deer_road(i);
%             actual_removal_interval(n)=removal_interval(i);
            n=n+1;
        end
    end
    
    
    
    
    
    %now swap back
    deer_road=actual_deer_road;
    km_road=actual_km_road;
    vph=actual_vph;