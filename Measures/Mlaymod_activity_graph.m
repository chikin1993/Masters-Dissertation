% A script to generate a network with the M layer model, and plot a graph
% of the number of nodes active on each layer

% Set up constants, done seperately to be easier to change 
N = 170397;
m_0 = 5;
m = 5;
M = 10;
l = 0.6;
r = 0;

% Start by generating the network
adjcell = Mlaymod(N, m_0, m, M, l, r);

% Create an empty vector to hold the node activities
activities = [];

% Use a loop to find the number of nodes with a non-zero degree in each
% layer and append to the list
for i=1:M
   
    nodesactive = nnz(sum(adjcell{i,1}));
    activities = [activities, nodesactive];
    
end

% Now plot this data to a graph
plot(activities);
title('Node activity in the M-Layer model')
xlabel('Network layer')
ylabel('Nodes active')