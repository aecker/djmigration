function backupTableData(table, restriction, append)
% Backup table data into sql file.
%   backupTableData(table) writes all data from the given table into the
%   file <schema>/<table>_data.sql. Only data is written, no CREATE TABLE
%   statements.
%
%   backupTableData(table, restriction) writes only the data matching the
%   given restriction.
%
%   backupTableData(table, restriction, append) appends the output to the
%   file <schema>_data.sql instead of writing it into a separate file for
%   each table.
%
% AE 2014-01-23

% restrict data to be dumped?
where = '';
if nargin > 1
    rel = table & restriction;
    where = rel.whereClause;
    if numel(where) > 7
        where = sprintf('-w''%s''', where(8 : end));
    else
        where = '';
    end
end

% append or put into separate file?
db = table.schema.dbname;
tab = table.table.plainTableName;
if nargin > 2 && append
    output = sprintf('>> %s_data.sql', db);
else
    output = sprintf('> %s/%s_data.sql', db, tab);
    if ~exist([pwd filesep db], 'dir')
        mkdir(db)
    end
end

args = '--complete-insert --insert-ignore --no-create-info --single-transaction';
host = getenv('DJ_HOST');
user = getenv('DJ_USER');
pass = getenv('DJ_PASS');

cmd = sprintf('mysqldump -h%s -u%s -p%s %s %s "%s" "%s" %s', host, user, pass, args, where, db, tab, output);
fprintf('%s.%s\n', db, tab);
system(cmd);
