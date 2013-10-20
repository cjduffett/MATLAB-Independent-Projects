function [pseq,varargout] = Translation(mrna,rna2amino,varargin)
%This function performs translation
%varargin - control protein sequence
%varargout - mutation string (A#B)

%convert mRNA to protein sequence
count = 1;

mrna = char(mrna);
for i = 1:3:(length(mrna)-2)
    pseq(count) = rna2amino.(mrna(i)).(mrna(i+1)).(mrna(i+2));
    count = count + 1;
end
stop = strfind(pseq,'Z');
pseq = pseq(1:stop(1));

if nargin == 3
    %Find mutation
    controlpseq = varargin{1};
    mutation = find(pseq ~= controlpseq);
    if ~isempty(mutation)
        A = controlpseq(mutation);
        B = pseq(mutation);
        varargout{1} = [A num2str(mutation) B];
    else
        varargout{1} = [];
    end
end

end

    

    
    