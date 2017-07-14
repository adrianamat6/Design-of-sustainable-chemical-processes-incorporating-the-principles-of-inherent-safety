function [samplePoints, ySample] = create_sampling(f_blackBox,xLowerBound, xUpperBound, nSamplePoints)


%% Create a sampling with nSamplePoints
xDimension = length(xLowerBound); 

sample = lhsdesign(nSamplePoints-4,xDimension,'criterion','maximin'); % returns an n-by-p matrix, X, containing a latin hypercube sample of n values on each of p variables. 

samplePoints = repmat(xLowerBound, nSamplePoints-4,1) + ...
               sample * diag (xUpperBound - xLowerBound);

% add corner points
samplePoints = [samplePoints
                xLowerBound 
                xUpperBound 
                xLowerBound(1) xUpperBound(2)
                xUpperBound(1) xLowerBound(2)
                ];

            
%% Compute the values of the dependent variable at each sampling point
ySample = f_blackBox(samplePoints(:,1),samplePoints(:,2));
% ySample = [4.75246498987093
%            1.236
           

end