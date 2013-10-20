function cypherletter = subEncrypt(plainletter,key)
%This function converts a plaintext letter input to its corresponding
%cyphertext letter given a predetermined key

%encrypt:
cypherletter = key(plainletter-64);

end