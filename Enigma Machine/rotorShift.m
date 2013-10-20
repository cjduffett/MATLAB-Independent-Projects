function newkey = rotorShift(key)
% This function shifts the input rotor key to the right by one letter.
%The last letter of the key becomes the first letter of the key.

%Preallocate output
newkey = zeros(1,26);

%Store last value of key
move = key(end);

%Shift key elements to right 1 space
for i = 1:25
    newkey(i+1)=key(i);
    
    %Place last element of key in first space
    newkey(1) = move;
end

end