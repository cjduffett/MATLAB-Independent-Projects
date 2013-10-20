%efficiency test
tic
[C_x C_y C_z G_x G_y G_z] = LarrysFileRead('A_DataCollection_2012-08-25.txt');
toc

tic
[C_x C_y C_z G_x G_y G_z] = loadData('A_DataCollection_2012-08-25.txt');
toc