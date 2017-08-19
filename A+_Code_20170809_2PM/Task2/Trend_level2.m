clear, clc, close all;

data_import;
load('MinWage.mat')
CountryCdName = {'ID', 'IN', 'BD', 'VN','CN','LK','KH','TH','TW','US','SV','GT','KR','KE','LS'};

% level 1, CategoryName       only consider _APPAREL
% level 2, TypeProductDesc    {'SWEATER';'KNIT';'WOVEN';} 

lv2 = 'SWEATER';

y_X_country = cell(15,1);
for i = 1:23400
    if strcmp(Category{i},'_APPAREL') && abs(eaCMCost(i)) > 0.1 ...
            && strcmp(TypeProductDesc{i},lv2)
        findcountry = strfind(CountryCdName,CountryCd{i});           
        countryID = find(~cellfun(@isempty,findcountry));        
        Year = Season(i);                   
        wage = MinWage (find(MinWage(:,1) == Year), countryID+1);             
        y_X_country{countryID} = [y_X_country{countryID}; [eaCMCost(i), 1, wage]];
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
for Ci = 1:5
    if ~isempty(y_X_country{Ci})
        [b,bint,r,rint,stats] = regress(y_X_country{Ci}(:,1),y_X_country{Ci}(:,2:3));
        wageplot = linspace(min(y_X_country{Ci}(:,3))*0.9, max(y_X_country{Ci}(:,3))*1.1, 100);
        Xplot = [ones(100,1), wageplot'];
        yplot = Xplot * b;
        plot(wageplot, yplot, 'color',col_v(Ci,:), 'LineWidth',2);
%         plot(y_X_country{Ci}(:,3), y_X_country{Ci}(:,1),'.')
        stats(1)
    end
end
legend(CountryCdName{1:8})
xlabel('Min Wage')
ylabel('CM Cost')

% 2010-2017point
for Ci = 1:5
    if ~isempty(y_X_country{Ci})
        [b,bint,r,rint,stats] = regress(y_X_country{Ci}(:,1),y_X_country{Ci}(:,2:3));
        Xplot = [ones(4,1), MinWage(5:8,Ci+1)];
        yplot = Xplot * b;
        plot(MinWage(5:8,Ci+1)', yplot, 'color',col_v(Ci,:), 'Marker','o');
    end
end    

