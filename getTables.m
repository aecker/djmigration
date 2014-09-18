function tables = getTables(schema, varargin)
% Returns a list of tables in the schema.
%   tables = getTables(schema, exclude1, exclude2, ...)
%
%   Returns all tables for which a class exists in the given package.
%
% AE 2014-01-23

a = what(schema);
c = a.m;
c = c(cellfun(@(x) lower(x(1)) ~= x(1), c));
c = cellfun(@(x) x(1 : end - 2), c, 'uni', false);

% deal with excludes
for i = 1 : numel(varargin)
    t = varargin{i};
    n = numel(t);
    if t(1) == '*'
        c = c(cellfun(@(x) ~strcmp(t(2 : end), x(max(1, end - n + 2) : end)), c));
    elseif t(end) == '*'
        c = c(cellfun(@(x) ~strcmp(t(1 : end - 1), x(1 : min(end, n - 1))), c));
    else
        c = setdiff(c, t);
    end
end

n = numel(c);
tables = cell(1, n);
for i = 1 : n
    tables{i} = eval([schema '.' c{i}]);
end
