function [parsed_code] = parseSource(source,a)
%parseSource parses the code from a source file into a standard format.
%   parseSource(source,a) takes the name of a source file and returns the
%   code from that file without comments or extra white space. This format
%   is easier to grade. Optionally the user can specify the type of return
%   character used in the file by providing the ASCII equivalent value.
%   parseSource preserves white space in strings.
%
%   In MATLAB the standard return character is char(10).
%   On the edX edge platform, the return character is char(13).
%   The default is char(13) for use with edX edge.
%
%   For example:
%   
%   parsed_code = parseSource('sourceFile.m');
%
%   Or to specify the expected return character:
%   parsed_code = parseSource('sourceFile.m',10);

if nargin == 2
    retchar = char(a);
else
    retchar = char(13);
end

raw_code = fileread(source);
comment_start = strfind(raw_code,'%');
comment_end = strfind(raw_code,retchar);

% 1. Replace all comments with blank spaces
% -----------------------------------------
for i = 1:length(comment_start)
   
    local_start = comment_start(i);
    next_return = comment_end(find(comment_end > local_start,1));
    raw_code(local_start:next_return) = blanks(next_return - local_start + 1); 
end

% 2. Compress white space
% -----------------------------------------
raw_code = strtrim(raw_code);

% prior to compressing internal spaces, replace any spaces delimiting
% arguments with a comma, for example change [r c] = size(n) to be
% [r,c] = size(n) before compressing
open_bracket = strfind(raw_code,'[');
close_bracket = strfind(raw_code,']');

for i = 1:length(open_bracket)
   
    % snippet is the content between the brackets
    snippet = raw_code(open_bracket(i)+1:close_bracket(i)-1); 
    len = length(snippet);
    snippet = strtrim(snippet);
    
    % compress white space within the snippet
    while ~isempty(strfind(snippet,'  '));
        snippet = strrep(snippet,'  ',' ');
    end
    
    snippet = strrep(snippet,' ',',');
    
    % insert delimited snippet with trailing blanks to preserve original length
    raw_code(open_bracket(i)+1:close_bracket(i)-1) = [snippet, blanks(len - length(snippet))];
end

raw_code=strrep(raw_code,' ','');

% 3. Compress line breaks
% -----------------------------------------
twobreaks = [retchar retchar];
while ~isempty(strfind(raw_code,twobreaks))
    raw_code = strrep(raw_code,twobreaks,retchar);
end

parsed_code = raw_code;

end

