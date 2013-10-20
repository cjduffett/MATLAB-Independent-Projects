function [C_x C_y C_z G_x G_y G_z] = LarrysFileRead(filename)

% LarrysFileRead reads data from specified file and returns
% vectors of acceleration & gyroscopic data.
fid = fopen(filename);

fgetl(fid);
fgetl(fid);

accel_count = 1;
gyro_count = 1;

C_x = [];
C_y = [];
C_z = [];
G_x = [];
G_y = [];
G_z = [];

while ~feof(fid)
    line = fgetl(fid);
    [sensor rest] = strtok(line);
    [time rest] = strtok(strtrim(rest));
    [Xdata rest] = strtok(strtrim(rest));
    [Ydata Zdata] = strtok(strtrim(rest));
    Zdata = strtrim(Zdata);
    
    if strcmp(sensor,'ACCEL')
        
        accel_count = accel_count + 1;
    elseif strcmp(sensor,'GYRO')
        G_x = [G_x str2double(Xdata)];
        G_y = [G_y str2double(Ydata)];
        G_z = [G_z str2double(Zdata)];
        gyro_count = gyro_count + 1;
    end
end

fclose(fid);
end