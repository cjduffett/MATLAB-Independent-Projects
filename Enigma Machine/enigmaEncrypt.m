function enmsg = enigmaEncrypt(plaintxt,key1,key2,key3)
%This function encrypts a plaintext message letter by letter

%Preallocate output:
enmsg = zeros(1,length(plaintxt));

%Initialize character counter
counter = 0;

%loop through all letters in the message
for i = 1:length(plaintxt)
    
    %encrypt with rotor I
    enletter = subEncrypt(plaintxt(i),key1);
    
    %encrypt with rotor II
    enletter = subEncrypt(enletter,key2);
    
    %encrypt with rotor III
    enmsg(i) = subEncrypt(enletter,key3);
    
    counter = counter + 1;
    
    %shift rotors
    if rem(counter,1) == 0
        key1 = rotorShift(key1);
    end
    if rem(counter,26) == 0
        key2 = rotorShift(key2);
    end
    if rem(counter,676) == 0
        key3 = rotorShift(key3);
    end
    
end

end