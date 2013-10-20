function [rnastring] = Transcription(cdna,primer)
%This function performs transcription given a control DNA string
%and a primer string

%create template strand from coding strand
tdna = zeros(1,length(cdna));
avec = strfind(cdna,'A');
tvec = strfind(cdna,'T');
cvec = strfind(cdna,'C');
gvec = strfind(cdna,'G');
tdna(avec) = 'U';
tdna(tvec) = 'A';
tdna(cvec) = 'G';
tdna(gvec) = 'C';
tdna = fliplr(tdna);

%find starting index of primer
start = strfind(tdna,primer);

%create RNA strand
rnastring = tdna(start:end);

end