function data = main_function(filename, columns)
% Read ONE hourly observation CSV into a MATLAB table.
% Example: data = main_function('data/.../2020-08-03_15.csv');
% Column names are identical in every observation CSV. Empty values become NaN.
% Optional: pass column names to read only the fields needed for a plot.

opts = detectImportOptions(filename, 'Delimiter', ',', 'Encoding', 'UTF-8', ...
    'VariableNamingRule', 'preserve');
opts = setvartype(opts, 'timestamp', 'string');
opts = setvartype(opts, opts.VariableNames(2:end), 'double');
if nargin > 1
    opts.SelectedVariableNames = columns;
end
data = readtable(filename, opts);
end
