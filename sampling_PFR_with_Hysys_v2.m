% Interpoalte response surface using Kriging basis function for a 
% distillation column simulated in Aspen-Hysys
%
% REQUIRED FILES
% |
% |- Matlab Files:
% krigerOptToolbox.m
% kriger_interp.m
% |
% |- Hysys Files:
% columna.hsc (must be previously open in Hysys)
% |
% |- GDX Files:
% Datos_30P_2D (do not write the file extension *.gdx)
%

%>>> USER INPUTS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GAMS_path   = 'C:\GAMS\win64\24.8';
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% Add the GAMS directory to the MATLAB path.
addpath(GAMS_path,'-end');

% clear variables
% close all
% clc

%% Connect with Aspen-Hysys
feature('COM_SafeArraySingleDim', 1);
HyApp = actxserver('HYSYS.Application');         % Accedemos a Hysys
set(HyApp,'Visible',1);                         % Hacemos que la ventana se mantenga visible
HyCase = get(HyApp,'ActiveDocument');             % Accedemos al documento activo
HySolver = HyCase.Solver;                         % Accedemos al Solver de Hysys

Flow = get(HyCase,'Flowsheet');                   % Accedemos al Flowsheet

Materia = get(Flow,'MaterialStreams');            % Accedemos a las corrientes de materia
    HyFeed = get(Materia,'Item','Feed');             % Accedemos a la corriente de alimento
    HyProduct = get(Materia,'Item','Product');                   % Accedemos a la corriente de destilado

Energia = get(Flow,'EnergyStreams');              % Accedemos a las corrientes de energia
    HeatFlux = get(Energia, 'Item', 'Heat Flux');         % Accedemos al calor en el condensador
    
Operaciones = Flow.Operations;                     % Operaciones Unitarias del Flowsheet 
    PFR = get(Operaciones, 'Item','Plug Flow Reactor');    % Acceso a la Columna
        
        
%% Sampling points

Archivo = 'Datos_30P_2D';
XX = datos_GAMS(Archivo);

N = length(XX);
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
lengthMin = 2;        lengthMax = 10;              
lengthSampling = XX(:,1)*(lengthMax-lengthMin) + lengthMin;     
nEBmin = 5;        nEBmax = 30;              % Límites de BR
nEBSampling = XX(:,2)*(nEBmax-nEBmin) + nEBmin;      % Puntos equidistantes de BR 
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%% Simulate the distillation column in Hysys for different values of the 
% Reflux and Boilup Ratios

extentReaction1 = zeros(N,1);         

   
for i = 1:N
  try 
      HySolver.CanSolve = 0;
         PFR.tubeLengthValue = lengthSampling(i);
         Feed.ComponentMolarFlowValue = HyFeed.ComponentMolarFlow.GetValues('kgmole/h');
         Feed.ComponentMolarFlowValue(1) = nEBSampling(i);
         Feed.ComponentMolarFlowValue(9) = (106.17 * 2 / 18.01528 ) * nEBSampling(i);
         HyFeed.ComponentMolarFlow.SetValues( Feed.ComponentMolarFlowValue','kgmole/h');                 
      HySolver.CanSolve = 1;

      Product.ComponentMolarFlowValue = HyProduct.ComponentMolarFlow.GetValues('kgmole/h');

      extentReaction(i,1) = ( Product.ComponentMolarFlowValue(2) - ...
                            Feed.ComponentMolarFlowValue(2)   ) ;
      extentReaction(i,2) = ( Product.ComponentMolarFlowValue(10) - ...
                            Feed.ComponentMolarFlowValue(10)   ) ;
      extentReaction(i,3) = ( Product.ComponentMolarFlowValue(5) - ...
                            Feed.ComponentMolarFlowValue(5)   ) ; 
      extentReaction(i,4) = - ( ( Product.ComponentMolarFlowValue(4) - ...
                            Feed.ComponentMolarFlowValue(4)   )  - ...
                             extentReaction(i,2)   )     ;    
      extentReaction(i,5) = - ( ( Product.ComponentMolarFlowValue(8) - ...
                            Feed.ComponentMolarFlowValue(8)   )  - ...
                             extentReaction(i,3)    )     ;   
      extentReaction(i,6) = ( Product.ComponentMolarFlowValue(7) - ...
                            Feed.ComponentMolarFlowValue(7)   ) ;                 
  
         
         % 1   2   3    4    5     6               
%       A =[-1  -1  -1    0    0     0
%            1   0   0    0    0     0
%            1   0  -1    4    3     1
%            0   1   0    0    0     0
%            0   1   0    1    0     0
%            0   0   1    0    0     0
%            0   0   1    0   -1     0
%            0   0   0   -2   -1    -1
%            0   0   0    0    0     1] ;
%        
%        b = ( Product.ComponentMolarFlowValue(i) - ...
%              Feed.ComponentMolarFlowValue(i)   ) ;
%       extentReaction(i) = A\b ;                 
                        
  catch
      extentReaction = zeros (1,1:3) ;   
   end
end

%% Plot the Hysys simulation results 

% Optimizacion de los parametros del kriging
% Todo queda almacenado en la estrutura KR
X = [lengthSampling nEBSampling];

samplePoints = X
extentReaction
ySample =  extentReaction(:,1)

figure(3)
hold on
scatter3(lengthSampling, nEBSampling, extentReaction(:,1),40,extentReaction(:,1),'filled','MarkerEdgeColor','k')
% scatter3(X,Y,Z,S) draws each circle with the size specified by S.
% To plot each circle with equal size, specify S as a scalar. 
% To plot each circle with a specific size, specify S as a vector.

% plot height lines
for i = 1:length(lengthSampling)     
    line ([ lengthSampling(i) lengthSampling(i)],...
          [ nEBSampling(i)    nEBSampling(i)],...
          [  0                extentReaction(i,1)],'LineStyle',':','LineWidth',1);
end
grid on
xlabel('Reflux ratio','fontsize',10)
ylabel('Boilup ratio ','fontsize',10)
zlabel('Heat flow at the reboiler [kW]', 'Fontsize',10)





