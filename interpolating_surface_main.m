% clc
% clear all
% close all

% REQUIRED FILES
% |
% |- Matlab Files:
% create_sampling.m
% create_interpolating_surface.m
% evaluate_interpolating_surface.m

%>>> INPUTS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
f_blackBox    = @peaks;
%               L molar flowrate EB
xLowerBound   = [2  5];
xUpperBound   = [10  30];
nSamplePoints = 30;
%x = [1 1];
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%% Call the function that creates the sampling
% [samplePoints, ySample] = create_sampling(f_blackBox,xLowerBound, xUpperBound, nSamplePoints);
% 
% % plot the sampling points
% plot3(samplePoints(:,1),samplePoints(:,2),ySample,'o',...
%      'markersize',6,'MarkerFaceColor','blue','MarkerEdgeColor','black');
% grid on

sampling_PFR_with_Hysys_v2

%% Call the function that create the interpolate surface
 [model] = create_interpolating_surface(samplePoints, ySample);
 
%% Call the function that evaluates the interpolating surface at point
x = [3 10];
y = evaluate_interpolating_surface(x,model);
 
%% Build the interpolating surface
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
nDrawingPoints = 50;
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
xDimension = length(xLowerBound); 


for j = 1 : xDimension
    xMatrix(:,j) = linspace(xLowerBound(j),xUpperBound(j),nDrawingPoints)';
end
[x1Grid,x2Grid] = meshgrid(xMatrix(:,1),xMatrix(:,2));


for i = 1:size(x1Grid,1)
    for j = 1:size(x1Grid,2)
         yGrid(i,j) = evaluate_interpolating_surface( [x1Grid(i,j),x2Grid(i,j)] , model );
    end
end


hold on
colormap('winter') %copper,prism,summer.winter,jet,bone,colorcube,flag,gray
surf(x1Grid,x2Grid,yGrid,'facecolor','interp','facealpha',0.6,'LineWidth',1)
% plot contour lines
contour(x1Grid,x2Grid,yGrid,10,'LineColor',[1 0 1],'LineStyle','--',...
        'LineColor','red','LineWidth',1.5); 
grid on
view(0,-90)
xlabel('x_1','fontsize',10)
ylabel('x_2','fontsize',10)
zlabel('y','fontsize',10)
box on




