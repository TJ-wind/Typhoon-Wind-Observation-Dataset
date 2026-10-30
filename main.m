%% 1. Choose ONE CSV file. Change this path to read your own hour.
root = fileparts(mfilename('fullpath'));
filename = fullfile(root, 'data', '2020_04_Hagupit', 'observations', ...
    'reconstructed', '2020-08-03', '2020-08-03_15.csv');

% Every observation folder uses the SAME CSV columns and the SAME reader:
% Khanun:   2017_20_Khanun / observations / component_profiles / date / hour.csv
% Mangkhut: 2018_22_Mangkhut / observations / component_profiles / date / hour.csv
% Lekima:   2019_09_Lekima / observations / reconstructed_unfiltered / date / hour.csv
%           Also available: reconstructed_filtered, radial_unfiltered, radial_filtered.
% Hagupit:  2020_04_Hagupit / observations / reconstructed / date / hour.csv
%           The separate analysis_subset keeps the original repeated subset.
% Higos:    2020_07_Higos / observations / radial / date / hour.csv
%           For horizontal wind: 2020_07_Higos / derived / horizontal_profiles / date / hour.csv
% Ma-on:    2022_09_Maon / observations / storm_subset / date / hour.csv
%           The continuous folder contains the longer July-August observations.
% Muifa:    2022_12_Muifa / observations / reconstructed / date / hour.csv
% Kong-rey: 2024_21_Kongrey / observations / reconstructed / date / hour.csv
% See each event's README.md for the available dates and an actual file example.

%% 2. Read this file into ONE variable.
data = main_function(filename);
% For example: data.height_m, data.horizontal_wind_speed_mps, data.wind_direction_deg

%% 3. Plot one profile from this file.
quantity = 'horizontal_wind_speed_mps';
% For a radial-wind CSV, change the line above to 'radial_wind_speed_mps'.
quality = isnan(data.wind_status) | data.wind_status == 1;
if strcmp(quantity, 'radial_wind_speed_mps')
    quality = isnan(data.radial_status) | data.radial_status == 1;
end

% Start with the first available profile. To select another, set recordTime
% to a timestamp from data.timestamp, for example data.timestamp(1000).
first = find(quality & isfinite(data.(quantity)), 1);
assert(~isempty(first), 'No accepted values for this quantity in this file.');
recordTime = data.timestamp(first);
keep = data.timestamp == recordTime & quality;
profile = data(keep, :);

figure('Color', 'w');
plot(profile.(quantity), profile.height_m, 'o-', 'LineWidth', 1);
xlabel(strrep(strrep(quantity, '_mps', ' (m/s)'), '_', ' ')); ylabel('Height (m)');
title(recordTime, 'Interpreter', 'none');
set(gca, 'FontName', 'Microsoft YaHei', 'FontSize', 10, 'TickDir', 'in');
box on;
