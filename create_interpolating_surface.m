function [surface] = create_interpolating_surface(samplePoints, ySample)


nSamplePoints = length(ySample);

%% 
%  a basis fo the set of all polynomials in x of degree G
% pi := polynomial basis

%INPUT DATA>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
pi{1} = @(x) 1;
pi{2} = @(x) x(1);
pi{3} = @(x) x(2);
% pi{4} = @(x) x(1)*x(2);
% pi{5} = @(x) x(1)^2;
% pi{6} = @(x) x(2)^2;
% pi{7} = @(x) x(1)^2*x(2);
% pi{8} = @(x) x(1)  *x(2)^2;
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
nPolyBasis = length(pi);


%% basis function
%
%INPUT DATA>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%phi = @(z) norm(z,2);       % Euclidean norm
phi = @(z) (norm(z,2)).^3;  % Cubic
%phi = @(z) (norm(z,2)).^2.*log(norm(z,2)); % thin plate spline
%   gamma = 0.5;
%   phi = @(z) sqrt(norm(z,2).^2 + gamma^2);      %multiquadric
% theta = [1 1];
% p     = [2 2];
% phi = @(z) exp(sum(- theta.*(abs(z)).^p));   %kriging
%>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

%% Build the coefficient Matrix
A = zeros(nSamplePoints + nPolyBasis);

% Build the pi submatrix [nSamplePoints × nPolynomialBasis]
for i = 1:nSamplePoints
    for k = 1:nPolyBasis
        piSubMatrix(i,k) = pi{k}( samplePoints(i,:) );  %[nPoints×nPolynomialBasis];
    end
end

% Build submatrix conrrsepsonding to the basis functions
for i = 1:nSamplePoints
    for j = 1:nSamplePoints
        basisSubMatrix(i,j) = phi( samplePoints(i,:)- samplePoints(j,:) );  %[nPoints×nPoints];
    end
end

A (1:nSamplePoints, 1:nPolyBasis      )   = piSubMatrix;
A (1:nSamplePoints,   nPolyBasis+1:end)   = basisSubMatrix;
A (nSamplePoints+1:end, nPolyBasis+1:end) = piSubMatrix';


%% Build the constant terms vector


%% Compute the coefficients "b" for the basis function terms

coefficients = A\ [ySample; zeros(nPolyBasis,1)];
aCoeff = coefficients(1:nPolyBasis);
bCoeff = coefficients(nPolyBasis+1:end);


%% Rebuild the surface using the surrogate model

% for i = 1:size(xGrid,1)
%     for j = 1:size(xGrid,2)
%          zSurrogate(i,j) = f_surrogate([xGrid(i,j),yGrid(i,j)]);
%     end
% end

% figure(1)
% hold on
% colormap('winter') %copper,prism,summer.winter,jet,bone,colorcube,flag,gray
% surf(xGrid,yGrid,zSurrogate,'facecolor','none','LineWidth',1)
% % plot contour lines
% contour(xGrid,yGrid,zSurrogate,10,'LineColor',[1 0 1],'LineStyle','--',...
%         'LineColor','red','LineWidth',1.5); 
% grid on
% view(0,-90)
% xlabel('Temperatura (ºC)','fontsize',10)
% ylabel('Presión (atm)','fontsize',10)
% zlabel('Fracción molar','fontsize',10)

surface.a             = aCoeff;
surface.b             = bCoeff;
surface.samplePoints  = samplePoints;
surface.pi            = pi;
surface.phi           = phi;


end