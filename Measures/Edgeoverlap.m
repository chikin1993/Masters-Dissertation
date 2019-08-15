% A function used to give the fraction of edges in a 2 layer network that
% are overlapping
function overlap = Edgeoverlap(alpha, beta)
    
    % Find the total number of edges in the network
    totaledges = (sum(sum(alpha)) + sum(sum(beta)))/2;
    
    % Find the number of overlapping edges by adding the matrices and
    % finding the values of 2
    incommon = alpha + beta;
    incommon = numel(find(incommon > 1));
    
    % Return this value as the fractional overlap
    overlap = incommon / totaledges;

end