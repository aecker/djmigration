function backupSchemaData(schema, restriction, varargin)
% Backup schema data into sql file.
%   backupSchema(schema)
%
% AE 2014-01-23

% create sql file for output
s = eval(sprintf('%s.getSchema', schema));
fid = fopen(sprintf('%s_data.sql', schema), 'w');
if ~fid
    error('Couldn''t open file for writing!')
end
fwrite(fid, sprintf('USE %s;\n\n', s.dbname));

% dump individual tables
tables = getTables(schema, varargin{:});
for i = 1 : numel(tables)
    backupTableData(tables{i}, restriction, true);
end
