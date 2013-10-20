function plainletter = subDecrypt(cypherletter,key)
%%This function converts a cypherletter letter input to its corresponding
%plaintext letter given a predetermined key

%Create alphabet for reference
alphabet = [65:90];

%decrypt:
plainletter = alphabet(find(key == cypherletter));

end