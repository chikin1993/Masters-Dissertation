% A script to produce a phase diagram of edge overlap from a series of
% networks as a function of p and q, this version produces a lower
% resolution plot but with much larger networks

% Set up the constant values
N = 10000;
seed = 10;
m = 5;

% Create a vector that will give values for p and q
linvec = linspace(0,1,21);

% Create a matrix to hold the results
overlapvals = [];

% Now loop over values of p and q
for i=1:21
   
    for j=1:21
        
        % Create the network and record the edge overlap
        [alpha, beta] = GRmod_rand(N, seed, m, linvec(i), linvec(j));
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