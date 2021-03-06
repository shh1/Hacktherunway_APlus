%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\Harvey\Desktop\hackathon\Try\Cost Composition - Brand E.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2017/08/19 10:02:42

%% Initialize variables.
filename = 'C:\Users\Harvey\Desktop\hackathon\Try\Cost Composition - Brand E.csv';
delimiter = ',';
startRow = 2;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = [dataArray{:,1:end-1}];
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[5,8,9,10,11,12,13,14,15,17]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [5,8,9,10,11,12,13,14,15,17]);
rawCellColumns = raw(:, [1,2,3,4,6,7,16,18]);


%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
Category = rawCellColumns(:, 1);
TypeProductDesc = rawCellColumns(:, 2);
RetailClassDesc = rawCellColumns(:, 3);
RetailSubClassDesc = rawCellColumns(:, 4);
StyleEstimatedCost = cell2mat(rawNumericColumns(:, 1));
GenderDesc = rawCellColumns(:, 5);
CountryCd = rawCellColumns(:, 6);
eaFabricCost = cell2mat(rawNumericColumns(:, 2));
eaCMCost = cell2mat(rawNumericColumns(:, 3));
eaTrimCost = cell2mat(rawNumericColumns(:, 4));
eaArtCost = cell2mat(rawNumericColumns(:, 5));
eaWashCost = cell2mat(rawNumericColumns(:, 6));
eaOtherCost = cell2mat(rawNumericColumns(:, 7));
eaFOB = cell2mat(rawNumericColumns(:, 8));
LandingCosts = cell2mat(rawNumericColumns(:, 9));
Allempty = rawCellColumns(:, 7);
Season = cell2mat(rawNumericColumns(:, 10));
Date = rawCellColumns(:, 8);

%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw numericData col rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;