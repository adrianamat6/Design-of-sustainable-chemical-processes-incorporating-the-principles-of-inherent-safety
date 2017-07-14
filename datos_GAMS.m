function XX = datos_GAMS(Archivo)

% Archivo = nombre del archivo GDX sin extension. p.e. 'Datos_25P_2D'

% crear la estructura para leer lo que interese 



%REQUIRED INPUT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%GAMS_path = 'C:\GAMS\win64\24.4';
GAMS_path =  'C:\GAMS\win64\24.7';
%'C\descargas\windows_x64_64';
%'C:\GAMS\win64\24.8';
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

addpath (GAMS_path, '-end');


x_s.name = 'x';
x_s.compress = 'true';
x_s.form = 'full';

% x2_s.name = 'x2';
% x2_s.compress = 'false';
% x2_s.form = 'full';

 i_s.name = 'i';
 i_s.compress = 'true';
 i_s.form = 'full';
 
 d_s.name = 'd';
 d_s.compress = 'true';
 d_s.form = 'full';
 

x = rgdx(Archivo, x_s);
i = rgdx(Archivo, i_s);
d = rgdx(Archivo, d_s);

xx = GDX_fill_zeros(x,{i,d});

XX = xx.val;

