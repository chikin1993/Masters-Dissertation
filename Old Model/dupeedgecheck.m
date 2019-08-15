% A function to check if a given index would lead to a multiple edge,
% checks in both directions by calling the checking function twice
function dupe = dupeedgecheck(index, ialpha, jalpha, ibeta, jbeta)
    
    % Call the duplicate function twice, with reversed order on alpha to
    % check for a duplicate edge
    dupe1 = dupeedge(index, ialpha, jalpha, ibeta, jbeta);
    dupe2 = dupeedge(index, jalpha, ialpha, ibeta, jbeta);
    dupe = and(dupe1, dupe2);

end