% A script to produce a phase diagram of edge overlap from a series of
% networks as a function of p and q

% Set up the constant values
N = 1000;
seed = 10;
m = 5;

% Create a vector that will give values for p and q
linvec = linspace(0,1,101);

% Create a matrix to hold the results
overlapvals = [];

% Now loop over values of p and q
for i=1:101
   
    for j=1:101
        
        % Create the network and record the edge overlap
        [alpha, beta] = GRmod(N, seed, m, linvec(i), linvec(j));
        overlap = Edgeoverlap(alpha, beta);
        
        % Record the value in a results matrix        
        overlapvals(i,j) = overlap;
        
    end
    
end

% Create the contour plot
contour(linvec, linvec, overlapvals)
colormap(jet);
colorbar;
ylabel('Values of p');
xlabel('Values of q');
title('Contour plot of edge overlap against p and q');