clear, clc, close all;
% 
data_import;
load('MinWage.mat')
CountryCdName = {'ID', 'IN', 'BD', 'VN','CN','LK','KH','TH','TW','US','SV','GT','KR','KE','LS'};

% level 1, CategoryName       only consider _APPAREL
% level 2, TypeProductDesc    'SWEATER' 'KNIT' 'WOVEN'
% level 3, RetailClassDesc    e.g., 'Bottoms'  'Knit Tops'  'Tops'

lv2 = 'WOVEN';
lv3 = 'Tops';


YearQ = zeros(15,3);
YearC = cell(15,3);
for i = 1:23400
    if strcmp(Category{i},'_APPAREL') && abs(eaCMCost(i)) > 0.1 ...
            && strcmp(TypeProductDesc{i},lv2) && ~isempty(strfind(RetailClassDesc{i},lv3))  && strcmp(GenderDesc{i},'Girl')
        findcountry = strfind(CountryCdName,CountryCd{i});           
        countryID = find(~cellfun(@isempty,findcountry));        
        Year = Season(i);                   
        YearQ(countryID, Year-2014) = YearQ(countryID, Year-2014)+1;
        YearC{countryID, Year-2014} = [YearC{countryID, Year-2014}; eaCMCost(i)];
    end
end

figure, hold on;
col_v =[ ...
     0    0.4470    0.7410; ...
0.8500    0.3250    0.0980; ...
0.9290    0.6940    0.1250; ...
0.4940    0.1840    0.5560; ...
0.4660    0.6740    0.1880; ...
0.3010    0.7450    0.9330; ...
0.6350    0.0780    0.1840; ...
     0         0    1.0000; ...
     0    0.5000         0; ...
1.0000         0         0; ...
     0    0.7500    0.7500; ...
0.7500         0    0.7500; ...
0.7500    0.7500         0; ...
0.2500    0.2500    0.2500; ...
     0         0         0];

% line trend
legendi = [];
for Ci = 1:5
    if  YearQ(Ci,1) ~= 0
        [b,bint,r,rint,stats] = regress([mean(YearC{Ci,1}); mean(YearC{Ci,2}); mean(YearC{Ci,3})],[ones(3,1), MinWage(6:8,Ci+1)]);
        wageplot = linspace(MinWage(6,Ci+1)*0.9, MinWage(8,Ci+1)*1.1, 100);
        Xplot = [ones(100,1), wageplot'];
        yplot = Xplot * b;
        plot(wageplot, yplot, 'color',col_v(Ci,:), 'LineWidth',2);
        stats(1)
        legendi = [legendi, Ci];
    end
end
legend(CountryCdName{legendi})
xlabel('Min Wage (2015-17)')
ylabel('CM Cost')
title('Given certain product, if assume CM cost ONLY depends on Min Wage')
axis([50 350 0 120]);
txt1 = 'Category:                APPAREL';
text(70,110,txt1)
txt1 = ['TypeProduct:       ',lv2];
text(80,103,txt1)
txt1 = ['RetailClass:      ',lv3];
text(90,96,txt1)
txt1 = 'Gender:                   Boy';
text(70,89,txt1)

for Ci = 1:5
    if  YearQ(Ci,1) ~= 0
        scatter(MinWage(6:8,Ci+1)', [mean(YearC{Ci,1}); mean(YearC{Ci,2}); mean(YearC{Ci,3})]', 'MarkerEdgeColor', col_v(Ci,:));
    end
end   

