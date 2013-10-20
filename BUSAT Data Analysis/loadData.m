function [C_x C_y C_z G_x G_y G_z] = loadData(filename)
% FileRead reads data from a specified file and returns
% xyz vectors of acceleration & gyroscopic data.

fid = fopen(filename);
if fid == -1
    disp('ERROR: File Open Failed')
else
         
    % read file using textscan (ignores first two lines)
    RAWdata = textscan(fid,'%s %f %f %f %f','headerLines',2);
    
    % extract data
    C_x = (RAWdata{3}(2:4:end))';
    C_y = (RAWdata{4}(2:4:end))';
    C_z = (RAWdata{5}(2:4:end))';
    
    G_x = (RAWdata{3}(3:4:end))';
    G_y = (RAWdata{4}(3:4:end))';
    G_z = (RAWdata{5}(3:4:end))';
    
end

close = fclose(fid);
if close == -1
    disp('ERROR: File Close Failed')
end