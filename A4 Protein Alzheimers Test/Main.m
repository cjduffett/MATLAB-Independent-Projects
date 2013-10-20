%********************************************************************
%A4 PROTEIN ALZHEIMERS TEST
%********************************************************************
%Created 8-Nov-2012
%Developed By:
%Carlton Duffett
%Sam Cheney

clear

%********************************************************************
%Create rna2amino Structure
%********************************************************************

%read in data from aminotable.dat
data = DNAread;

%create rna2amino structure
for i = 1:64
    rna2amino.(data(i,1)).(data(i,2)).(data(i,3)) = data(i,4);
end

%********************************************************************
%Control Data
%********************************************************************

%open ControlData.dat
fid = fopen('ControlData.dat');
if fid == -1
    fprintf('File Open Failed\n')
else
    %read ControlData.dat
    count = 1;
    controldna = zeros(1,5000); %Preallocate
    while ~feof(fid)
        aline = fgetl(fid);
        if count == 2
            %Primer strand
            primer = upper(aline(5:end));
        elseif count >= 4
            %Control DNA strand
            indexend = strfind(aline,' -') - 1;
            index = str2double(aline(1:indexend));
            startline = strfind(aline,'- ') + 2;
            aline = upper(aline(startline:end));
            aline = strrep(aline,' ','');
            controldna(index:(index + 49)) = aline;
        end
        count = count + 1;
    end
end

%close ControlData.dat
close = fclose(fid);
if close == -1
    fprintf('File Close Failed\n')
end

%Transcribe Control DNA
controlrna = Transcription(controldna,primer);
%Translate Control DNA
controlpseq = Translation(controlrna,rna2amino);

%*********************************************************************
%Patient Information
%*********************************************************************

%open patientinfo.dat
fid = fopen('patientinfo.dat');
if fid == -1
    fprintf('File Open Failed\n')
else
    %Read in information
    
    %preallocate structure
    PatientInfo(10) = struct('Name','','Age','','Sex','', ...
        'DOB',struct('Day','','Month','','Year',''),'History','');
    %Create structure
    for i = 1:10
        fgetl(fid);
        aline = fgetl(fid);
            PatientInfo(i).Name = aline(6:end);
        aline = fgetl(fid);
            PatientInfo(i).Age = aline(end-1:end);
        aline = fgetl(fid);
            PatientInfo(i).Sex = aline(end);
        aline = fgetl(fid);
            PatientInfo(i).DOB.Day = aline(8:9);
            PatientInfo(i).DOB.Month = aline(5:6);
            PatientInfo(i).DOB.Year = aline(11:end);
        aline = fgetl(fid);
            PatientInfo(i).History = aline(end);
    end
end

%close patientinfo.dat
close = fclose(fid);
if close == -1
    fprintf('File Close Failed\n')
end

run = 1;
while run > 0
    %*********************************************************************
    %Prompt User for Patient Number
    %*********************************************************************

    %prompt user
    patientid = input('Enter patient ID number: ');

    %error check
    while patientid > 10 || patientid < 1
        patientid = input('Enter a VALID patient ID number (1-10): ');
    end

    %*********************************************************************
    %Load Patient's DNA
    %*********************************************************************

    %open PatientsDNA.dat
    fid = fopen('PatientsDNA.dat');
    if fid == -1
        fprintf('File Open Failed\n')
    else
        %Get specific patient DNA
        for i = 1:patientid
            aline = fgetl(fid);
        end
        patientdna = upper(aline);
    end

    %close PatientsDNA.dat
    close = fclose(fid);
    if close == -1
        fprintf('File Close Failed\n')
    end

    %*********************************************************************
    %Test Patient DNA
    %*********************************************************************

    %Transcription
    patientrna = Transcription(patientdna,primer);

    %Translation
    [patientpseq mutation] = Translation(patientrna,rna2amino,controlpseq);

    %*********************************************************************
    %Output Result
    %*********************************************************************

    %Open Patient##_TestResults.dat
    filename = sprintf('Patient%2d_TestResults.dat',patientid);
    if ~isempty(strfind(filename,' '))
        filename = strrep(filename,' ','0');
    end
        
    fid = fopen(filename,'w');
    if fid == -1
        fprintf('File Open Failed\n')
    else
        %Write patient information
        fprintf(fid,'Name: %s\n',PatientInfo(patientid).Name);
        fprintf(fid,'Patient ID: %2d\n\n',patientid);
        fprintf(fid,'Age | Sex | DOB\n');
        fprintf(fid,' %s |   %c | %s/%s/%s\n\n',...
            PatientInfo(patientid).Age,PatientInfo(patientid).Sex, ...
            PatientInfo(patientid).DOB.Month, ...
            PatientInfo(patientid).DOB.Day, ...
            PatientInfo(patientid).DOB.Year);
        %Write patient history
        if PatientInfo(patientid).History == 'Y'
            fprintf(fid,'Family History: Y\n');
        else
            fprintf(fid,'Family History: N/A\n\n');
        end
        %Write test results
        if ~isempty(mutation)
            fprintf(fid,'Test Results: Positive\n');
            fprintf(fid,'Mutation Location:  %s\n\n',mutation);
        else
            fprintf(fid,'Test Results: Negative\n\n');
        end
        %Write protein strand
        count = 1;
        for i = 1:(length(patientpseq)/20)
            fprintf(fid,'%2d - %s %s\n',count,...
                patientpseq(count:count + 9), ...
                patientpseq(count + 10:count + 19));
            count = count + 20;
        end
        %last line of file
        fprintf(fid,'%2d - %s %s',count,patientpseq(count:count+9), ...
            patientpseq(end));
    end

    %close Patient##_TestResults.dat
    close = fclose('all');
    if close == -1
        fprintf('File Close Failed\n')
    end   

    %*********************************************************************
    %Prompt User for Another Analysis
    %*********************************************************************

    response = input('Would you like to run analysis on another patient (Y/N)? ','s');

    if response == 'Y' || response == 'y'
        run = run + 1;
    elseif response == 'N' || response == 'n'
        run = 0;
    else
        response = input('Error: Would you like to run analysis on another patient (Y/N)?','s');
    end
end