function [data] = DNAread
%This function reads in the data from aminotable.dat
%Output is a character matrix

%open aminotable.dat
fid = fopen('aminotable.dat');
if fid == -1
    fprintf('File Open Failed\n')
else
    %read data from file
    dataarray = textscan(fid,'#%c#%c#%c-%c');
    datamat = zeros(64,4); %preallocate
    for i = 1:4
        datamat(:,i) = dataarray{i};
    end
    data = char(datamat);
end

%close aminotable.dat
close = fclose(fid);
if close == -1
    fprintf('File Close Failed\n')
end