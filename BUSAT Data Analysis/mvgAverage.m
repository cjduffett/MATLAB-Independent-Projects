function [ADJUSTEDvector] = mvgAverage(RAWvector, sampleSize)
% This function takes a RAW vector and returns a moving average
% of a given sample size between 2 and 10

% preallocate
RAWmat = zeros(sampleSize, length(RAWvector)); % s x l matrix of zeros
RAWmat(1,:) = RAWvector; % first row of matrix is RAWvector

for i = 2:sampleSize
    % creates matrix of shifted elements
    RAWmat(i,:) = circshift(RAWvector, [0 -(1*i - 1)]);
end
    % create adjusted vector
    ADJUSTEDvector = sum(RAWmat)/sampleSize;
    % truncate adjusted vector
    ADJUSTEDvector = ADJUSTEDvector(1:end-(sampleSize-1));
end