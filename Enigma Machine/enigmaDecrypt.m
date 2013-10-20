function demsg = enigmaDecrypt(cyphertxt,key1,key2,key3)
%This function decrypts a cyphertext message letter by letter

%Preallocate output:
demsg = zeros(1,length(cyphertxt));

%Initialize character counter
counter = 0;

%loop through all letters in the message
for i = 1:length(cyphertxt)
    
    %decrypt with rotor III
    deletter = subDecrypt(cyphertxt(i),key3);
    
    %decrypt with rotor II
    deletter = subDecrypt(deletter,key2);
    
    %decrypt with rotor I
    demsg(i) = subDecrypt(deletter,key1);
    
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